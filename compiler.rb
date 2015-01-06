module Compiler
  class Process
    attr_reader :name, :statements, :description
    def initialize(name, statements)
      @name = name
      @statements = statements
      @description = "process name"
    end
  end

  class If
    attr_reader :expression, :if_statements, :else_statements
    def initialize(expression, if_statements, else_statements)
      @expression = expression
      @if_statements = if_statements
      @else_statements = else_statements
    end
  end

  class While
    attr_reader :optional_statements, :expression, :statements
    def initialize(optional_statements, expression, statements)
      @optional_statements = optional_statements
      @expression = expression
      @statements = statements
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
    attr_reader :name
    def initialize(name)
      @name = name
    end
  end

  class BinaryExpression
    attr_reader :left_operand, :operator, :right_operand
    def initialize(left_operand, operator, right_operand)
      @left_operand = left_operand
      @operator = operator
      @right_operand = right_operand
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
