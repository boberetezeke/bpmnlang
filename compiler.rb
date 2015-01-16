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
          {type: :sequence_flow,  source: 'start', target: :next_sub_instruction},
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
        instructions.push({type: :sequence_flow, source: gateway_id, target: :next_sub_instruction, conditions: conditions })
        instructions.push({type: :instructions, instructions: statements_to_instructions(generator, @if_statements)})
      else
        instructions.push({type: :sequence_flow, source: gateway_id, target: :next, conditions: conditions })
      end

      if @else_statements
        instructions.push({type: :sequence_flow, source: gateway_id, target: :next_sub_instruction, conditions:  not_conditions })
        instructions.push({type: :instructions, instructions: statements_to_instructions(generator, @else_statements)})
      else
        instructions.push({type: :sequence_flow, source: gateway_id, target: :next, conditions: not_conditions })
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
      
      if @optional_statements
        instructions = @optional_statements.map{|s| s.generate} + [exclusive_gateway]
      else
        instructions = [exclusive_gateway]
      end

      conditions = expression.to_s
      not_conditions = "!(#{conditions})"

      instructions.push({type: :sequence_flow, source: gateway_id, target: :next_sub_instruction, conditions:  conditions })
      instructions.push({type: :sequence_flow, source: gateway_id, target: :next_super_instruction, conditions:  not_conditions })
      instructions.push({type: :instructions, instructions: statements_to_instructions(generator, @statements)})
      instructions.push({type: :sequence_flow, source: :prev, target: gateway_id })
      
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
        {type: :sequence_flow, source: @name.identifier, target: :next}
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
