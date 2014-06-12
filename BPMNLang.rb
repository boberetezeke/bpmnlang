require 'rubygems'
require 'treetop'
require './bpmnlang_parser'

module BPMNLang
  class StatementsNode < Treetop::Runtime::SyntaxNode
    def statements
      s = []
      self.elements.each_with_index do |element, index|
        s.push(element)
      end

      s
    end
  end

  class TaskNode < Treetop::Runtime::SyntaxNode
    def name
      elements.first.name
    end
  end

  class SymbolNode < Treetop::Runtime::SyntaxNode
    def name
      elements[0].text_value + elements[1].text_value
    end
  end

  class IdentifierStartNode < Treetop::Runtime::SyntaxNode
  end

  class IdentifierRestNode < Treetop::Runtime::SyntaxNode
  end

  class Runner
    def self.parse(text)
      self.new.parse(text)
    end

    def initialize
      @parser = BPMNLangParser.new
    end

    def parse(text)
      root_node = @parser.parse(text)
      root_node = clean_tree(root_node).first
      #puts "-------------- DUMP ----------------"
      #dump_tree(root_node)
      #puts "----------------------------------"
      root_node
    end

    def dump_tree(node, level=0)
      puts((' ' * level) + node.class.to_s) # + " elements: #{node.elements.size}")
      if node.elements
        node.elements.each do |element|
          dump_tree(element, level+2)
        end
      end
    end

    def clean_tree(root_node, level = 0)
      left_margin = "  " * level
      #puts "#{left_margin} root_node = #{root_node.class}"
      if (root_node.elements.nil? || root_node.elements == [])
        #puts "#{left_margin} is leaf node"
        if root_node.class.name == "Treetop::Runtime::SyntaxNode"
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
        if root_node.class.name == "Treetop::Runtime::SyntaxNode"
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
