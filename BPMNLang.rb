require 'rubygems'
require 'treetop'
require './bpmnlang_parser'

module BPMNLang
  module StatementsNode
    def statements
      s = []
      self.elements.each_with_index do |element, index|
        s.push(element)
      end

      s
    end
  end

  module StatementNode
  end

  module InOrderNode
    def statements
      elements
    end
  end

  module InParallelNode
    def statements
      elements
    end
  end

  module BlockNode
  end

  module TaskNode
    def name
      elements.first.name
    end
  end

  module SymbolNode
    def name
      elements[0].text_value + elements[1].text_value
    end
  end

  module IdentifierStartNode
  end

  module IdentifierRestNode
  end

  NODE_MODULES = [
        StatementsNode, StatementNode, 
        InOrderNode, InParallelNode, TaskNode, 
        SymbolNode, IdentifierStartNode, IdentifierRestNode
      ]

  class Runner
    def self.parse(text)
      self.new.parse(text)
    end

    def initialize
      @parser = BPMNLangParser.new
    end

    def parse(text)
      root_node = @parser.parse(text)
      return nil unless root_node

      root_node = clean_tree(root_node).first
      #puts "-------------- DUMP ----------------"
      #dump_tree(root_node)
      #puts "----------------------------------"
      root_node
    end

    def dump_tree(node, level=0)
      puts((' ' * level) + matched_nodes(node).to_s) # + " elements: #{node.elements.size}")
      if node.elements
        node.elements.each do |element|
          dump_tree(element, level+2)
        end
      end
    end

    def matched_nodes(node)
      matched_nodes = NODE_MODULES.select do |node_module|
        node.is_a?(node_module)
      end
    end

    def our_node(node)
      !(matched_nodes(node).empty?)
    end

    def clean_tree(root_node, level = 0)
      left_margin = "  " * level
      #puts "#{left_margin} root_node = #{root_node.class}"
      if (root_node.elements.nil? || root_node.elements == [])
        #puts "#{left_margin} is leaf node"
        if !our_node(root_node)
          #puts "#{left_margin} is syntax node"
          return nil
        else
          #puts "#{left_margin} is real node"
          return [root_node]
        end

      else

        #puts "#{left_margin} is not leaf node"

        new_elements = []
        root_node.elements.each do |node|
          elements = clean_tree(node, level+1)
          if elements
            #puts "#{left_margin} got elements from clean: #{elements.map{|e| e.class.to_s}.join(',')}"
            new_elements += elements
          end
        end

        #puts "#{left_margin} root_node2 = #{root_node.class}"
        if !our_node(root_node)
          if new_elements.empty?
            #puts "#{left_margin} is syntax node, no non syntax elements, returning nil"
            return nil
          else
            #puts "#{left_margin} is syntax node, returning #{new_elements.size} elements"
            return new_elements
          end
        else
          #puts "#{left_margin} is not syntax node, returning #{root_node.class}"
          root_node.elements.delete_if{|e| true}
          new_elements.each_with_index {|element, index| root_node.elements.insert(index, element)}
          return [root_node]
        end
      end
    end
  end
end
