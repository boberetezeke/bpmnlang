require 'rubygems'
require 'treetop'
require 'polyglot'
require './bpmnlang_parser'
require './compiler'
require 'nokogiri'

module BPMNLang
  class Runner
    def self.parse(text, options={})
      self.new.parse(text, options)
    end

    def initialize
      @parser = BPMNLangParser.new
    end

    def parse(text, options={})
      root_node = @parser.parse(text)
      if root_node.nil?
        puts "--------- NO MATCH ---------"
        puts @parser.failure_reason
        puts "----------------------------"
      else
        #root_node = clean_tree(root_node).first
        if options[:dump]
          puts "-------------- DUMP ----------------"
          dump_tree(root_node)
          puts "----------------------------------"
        end
      end
      root_node
    end

    def dump_tree(node, level=0)
      puts((' ' * level) + " elements: #{node.elements}")
      if node.elements
        node.elements.each do |element|
          dump_tree(element, level+2)
        end
      end
    end
  end

  class XmlGenerator
    def initialize(process_node)
      @process_node = process_node
      @previous_instruction_id = nil
      @flow_counter = 1
      @gateway_counter = 1
    end

    def generate
      x = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.definitions( 
          'id' =>               'definitions', 
          'targetNamespace' =>  'http://activiti.org/bpmn20',
          'xmlns' =>            'http://www.omg.org/spec/BPMN/20100524/MODEL',
          'xmlns:xsi' =>        'http://www.w3.org/2001/XMLSchema-instance',
          'xmlns:activiti' =>   'http://activiti.org/bpmn') do

          xml.process 'id' =>   @process_node.name.identifier, 'name' => @process_node.description do
            process_instructions(xml, @process_node.generate(self))
          end
        end
      end.to_xml

      debug 0, "xml = #{x}"
      x

=begin 
      <?xml version="1.0" encoding="UTF-8" ?>
      <definitions id="definitions"
                   targetNamespace="http://activiti.org/bpmn20"
                   xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xmlns:activiti="http://activiti.org/bpmn">
=end
    end

    def process_instructions(xml, instructions, sequence_flows=[], symbol_table={}, options={})
      level = options[:level] || 0

      debug level, "process_instructions: instructions = #{instructions}"
      debug level, "process_instructions: sequence_flows = #{sequence_flows}"
      last_sequence_id = nil
      super_sequence_flows = []

      instructions.each_with_index do |instruction, index|
        instruction_type = instruction.delete(:type)
        case instruction_type
        when :xml
          instruction_xml = instruction.delete(:xml)
          instruction_id =  instruction.delete(:id)

          next_statement_sequence_flows, sequence_flows = sequence_flows.partition do |i| 
            i[:target] == Target::NextInstruction.new || 
            i[:target] == Target::ById.new(instruction_id)
          end
          next_statement_sequence_flows.each {|i| i[:target] = Target::ById.new(instruction_id)}

          next_statement_sequence_flows.each do |sequence_flow|
            process_sequence_flow(xml, sequence_flow, level)
          end

          debug level, "xml: #{instruction_xml}##{instruction_id}: options: #{instruction}"
          xml.send(instruction_xml, {id: instruction_id}.merge(instruction))
          last_sequence_id = instruction_id

          # fill out symbols that are currently nil with current instruction_id
          symbol_table.each do |symbol, value|
            if value.nil?
              debug level, "saving #{instruction_id} for symbol: #{symbol}"
              symbol_table[symbol] = instruction_id 
            end
          end

        when :instructions
          debug level, "instructions: #{instruction[:instructions]}"
          next_sub_instruction_sequence_flows, sequence_flows = sequence_flows.partition{|i| i[:target] == Target::NextSubInstruction.new}
          debug level, "next_sub_instruction_sequence_flows = #{next_sub_instruction_sequence_flows}, sequence_flows = #{sequence_flows}"
          last_sequence_id, new_sequence_flows = process_instructions(xml, instruction[:instructions], next_sub_instruction_sequence_flows.map{|i| i[:target] = Target::NextInstruction.new; i}, symbol_table, level: level + 1)
          debug level, "returned: last_sequence_id = #{last_sequence_id}"
          sequence_flows += new_sequence_flows

        when :sequence_flow
          source = instruction[:source]
          target = instruction[:target]

          if target == Target::NextSuperInstruction.new
            instruction[:target] = Target::NextInstruction.new
            super_sequence_flows.push(instruction)
          elsif target == Target::NextInstruction.new || target == Target::NextSubInstruction.new
            sequence_flows.push(instruction)
          elsif target.is_a?(Target::Label)
            debug level, "resolving #{symbol_table[target.name]} for symbol: #{target.name}"
            instruction[:target] = Target::ById.new(symbol_table[target.name])
          end

          # This needs to be after resolving the target so that queued up sequence flows can take
          # their target from the current instruction's target
          if source == :prev
            # if the instruction source is previous, then for each sequence flow queued up for
            # next, change the target to the prev's target
            next_sequence_flows, sequence_flows = sequence_flows.partition { |sf| sf[:target] == Target::NextInstruction.new }
            next_sequence_flows.each do |sf|
              sf[:target] = instruction[:target].dup
              process_sequence_flow(xml, sf, level)
            end
          end

          # if the sequence flow instruction is fully resolved
          if instruction[:source] != :prev && instruction[:target].resolved?
            process_sequence_flow(xml, instruction, level)
          end

        when :label
          symbol_table[instruction[:name]] = nil
        end
      end

      debug level, "returning last_sequence_id=#{last_sequence_id}, sequence_flows=#{sequence_flows}"
      return [last_sequence_id, sequence_flows + super_sequence_flows]
    end

    def process_sequence_flow(xml, sequence_flow, level)
      flow_id = next_flow_id
      debug level, "sequence_flow: #{flow_id}, source: #{sequence_flow[:source]}, target: #{sequence_flow[:target]}"
      conditions = sequence_flow.delete(:conditions)
      if conditions
        debug level, "  with conditions: #{conditions}"
        xml.sequenceFlow id: "flow#{flow_id}", sourceRef: sequence_flow[:source], targetRef: sequence_flow[:target].id do
          xml.conditionalExpression  "${#{conditions}}", "xsi:type" => "tFormalExpression"
        end
      else
        xml.sequenceFlow id: "flow#{flow_id}", sourceRef: sequence_flow[:source], targetRef: sequence_flow[:target].id
      end
    end

    def debug(level, str)
      #puts "#{'  ' * level}#{str}"
    end

    def next_flow_id
      ret = @flow_counter
      @flow_counter += 1
      ret
    end

    def next_gateway_id
      ret = @gateway_counter
      @gateway_counter += 1
      ret
    end
  end
end
