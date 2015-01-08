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
            process_instructions(xml, @process_node.generate)
          end
        end
      end.to_xml

      #puts "xml = #{x}"
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

    def process_instructions(xml, instructions, initial_previous_instructions=[], conditions=nil)
      previous_instructions = initial_previous_instructions
      #puts "previous instructions = #{previous_instructions}"
      #puts "instructions = #{instructions}"
      instructions.each_with_index do |instruction, index|
        instruction_type = instruction.delete(:type)
        case instruction_type
        when :xml
          instruction_xml = instruction.delete(:xml)
          instruction_id =  instruction.delete(:id)
          process_instruction(xml, instruction_xml, instruction_id, previous_instructions,
                              instruction.merge(index == 0 && conditions ? {conditions: conditions} : {}))

        when :exclusive_gateway
          conditions = instruction.delete(:conditions) || {}
          gateway_id = "gateway#{next_gateway_id}"
          process_instruction(xml, :exclusiveGateway, gateway_id, previous_instructions)

          children_positive_instructions = instruction.delete(:children_positive_instructions)
          children_negative_instructions = instruction.delete(:children_negative_instructions)
          
          previous_instruction = previous_instructions.first.dup
          previous_instructions += process_instructions(xml, children_positive_instructions, [previous_instruction.merge(conditions: conditions)])
          if children_negative_instructions
            # delete gateway as a previous instruction as that will go to the else case
            previous_instructions.delete_if{|p| p[:id] == gateway_id}
            previous_instructions += (process_instructions(xml, children_negative_instructions, [previous_instruction.merge(conditions:"!(#{conditions})")]))
          else
            # modify gateway as a previous instruction to add the negative condition to it
            pi_gateway = previous_instructions.select{|p| p[:id] == gateway_id}.first
            pi_gateway.merge!(conditions: "!(#{conditions})")
            #puts "after if previous_instructions = #{previous_instructions}"
          end

        when :goto
        end
      end

      previous_instructions
    end

    def process_instruction(xml, message, id_val, previous_instructions, options={})
      previous_instructions.each do |previous_instruction|
        conditions = previous_instruction.delete(:conditions)
        if conditions 
          xml.sequenceFlow id: "flow#{next_flow_id}", sourceRef: previous_instruction[:id], targetRef: id_val do
            xml.conditionalExpression  "${#{conditions}}", "xsi:type" => "tFormalExpression"
          end
        else
          xml.sequenceFlow id: "flow#{next_flow_id}", sourceRef: previous_instruction[:id], targetRef: id_val
        end
      end

      previous_instructions.clear

      xml.send(message, {id: id_val}.merge(options))
      previous_instructions.push({id: id_val})
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
