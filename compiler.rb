require "./target"

module Compiler
  module GeneratorMethods
    def statements_to_instructions(generator, statements, instructions=[])
      statements.each do |statement|
        statement.generate(generator).each do |instruction|
          instructions.push(instruction)
        end
      end

      instructions
    end
  end

  class Process
    include GeneratorMethods

    attr_reader :name, :statements, :description
    def initialize(name, statements)
      @name = name
      @statements = statements
      @description = "process name"
    end

    def generate(generator)
      if @statements.empty?
        []
      else
        [
          {type: :xml,            xml: :startEvent, id: 'start'},
          {type: :sequence_flow,  source: 'start', target: Target::NextSubInstruction.new},
          {type: :instructions,   instructions: statements_to_instructions(generator, @statements)},
          {type: :xml,            xml: :endEvent, id: 'end1'}
        ]
      end
    end
  end

  class If
    include GeneratorMethods
    attr_reader :expression, :if_statements, :else_statements
    def initialize(expression, if_statements, else_statements)
      @expression = expression
      @if_statements = if_statements
      @else_statements = else_statements
    end

    def generate(generator)
      gateway_id = "gateway#{generator.next_gateway_id}"
      instructions = [{
        type: :xml, xml: :exclusiveGateway, id: gateway_id
      }]

      conditions = @expression.to_s
      not_conditions = "!(#{conditions})"
      if @if_statements.size > 0
        instructions.push({type: :sequence_flow, source: gateway_id, target: Target::NextSubInstruction.new, conditions: conditions })
        instructions.push({type: :instructions, instructions: statements_to_instructions(generator, @if_statements)})
      else
        instructions.push({type: :sequence_flow, source: gateway_id, target: Target::NextInstruction.new, conditions: conditions })
      end

      if @else_statements
        instructions.push({type: :sequence_flow, source: gateway_id, target: Target::NextSubInstruction.new, conditions:  not_conditions })
        instructions.push({type: :instructions, instructions: statements_to_instructions(generator, @else_statements)})
      else
        instructions.push({type: :sequence_flow, source: gateway_id, target: Target::NextInstruction.new, conditions: not_conditions })
      end

      instructions
    end
  end

  class While 
    include GeneratorMethods

    attr_reader :optional_statements, :expression, :statements
    def initialize(optional_statements, expression, statements)
      @optional_statements = optional_statements
      @expression = expression
      @statements = statements
    end

    def generate(generator)
      gateway_id = "gateway#{generator.next_gateway_id}"
      exclusive_gateway = { type: :xml, xml: :exclusiveGateway, id: gateway_id }
      label = { type: :label, name: :label1 }
      
      if @optional_statements
        instructions = [label] + statements_to_instructions(generator, @optional_statements) + [exclusive_gateway]
        loop_target = Target::Label.new(:label1)
      else
        instructions = [exclusive_gateway]
        loop_target = Target::ById.new(gateway_id)
      end

      conditions = expression.to_s
      not_conditions = "!(#{conditions})"

      instructions.push({type: :sequence_flow, source: gateway_id, target: Target::NextSubInstruction.new, conditions:  conditions })
      instructions.push({type: :sequence_flow, source: gateway_id, target: Target::NextSuperInstruction.new, conditions:  not_conditions })
      instructions.push({type: :instructions, instructions: statements_to_instructions(generator, @statements)})
      instructions.push({type: :sequence_flow, source: :prev, target: loop_target })
      
      instructions
    end
  end

  class InOrder
    attr_reader :statements
    def initialize(statements)
      @statements = statements
    end
  end

  class InParallel
    attr_reader :statements
    def initialize(statements)
      @statements = statements
    end
  end

  class Task
    include GeneratorMethods

    attr_reader :name
    def initialize(name)
      @name = name
    end

    def generate(generator)
      [
        {type: :xml, xml: :userTask, id: @name.identifier},
        {type: :sequence_flow, source: @name.identifier, target: Target::NextInstruction.new}
      ]
    end
  end

  class BinaryExpression
    attr_reader :left_operand, :operator, :right_operand
    def initialize(left_operand, operator, right_operand)
      @left_operand = left_operand
      @operator = operator
      @right_operand = right_operand
    end

    def to_s
      "#{@left_operand} #{@operator} #{@right_operand}"
    end
  end

  class UnaryExpression
    attr_reader :operator, :expression
    def initialize(operator, expression)
      @operator = operator
      @expresssion = expression
    end
  end

  class Symbol
    attr_reader :identifier
    def initialize(identifier)
      @identifier = identifier
    end
  end
end
