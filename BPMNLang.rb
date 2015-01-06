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
    end

    def generate
      Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.definitions( 
          'id' =>               'definitions', 
          'targetNamespace' =>  'http://activiti.org/bpmn20',
          'xmlns' =>            'http://www.omg.org/spec/BPMN/20100524/MODEL',
          'xmlns:xsi' =>        'http://www.w3.org/2001/XMLSchema-instance',
          'xmlns:activiti' =>   'http://activiti.org/bpmn') do

          xml.process 'id' =>   @process_node.name.identifier, 'name' => @process_node.description do
            if @process_node.statements.size > 0
              xml.startEvent 'id' => 'start'
              @process_node.statements.each do |statement|
                xml.userTask 'id' => statement.name.identifier
              end
              xml.endEvent 'id' => 'end1'
            end
          end
        end
      end.to_xml

=begin 
      <?xml version="1.0" encoding="UTF-8" ?>
      <definitions id="definitions"
                   targetNamespace="http://activiti.org/bpmn20"
                   xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xmlns:activiti="http://activiti.org/bpmn">
=end
    end
  end
end
