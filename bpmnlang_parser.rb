# Autogenerated from a Treetop grammar. Edits may be lost.


module BPMNLang
  include Treetop::Runtime

  def root
    @root ||= :process
  end

  module Process0
    def optional_ws1
      elements[0]
    end

    def ws1
      elements[2]
    end

    def symbol
      elements[3]
    end

    def ws2
      elements[4]
    end

    def block
      elements[5]
    end

    def optional_ws2
      elements[6]
    end
  end

  module Process1
    def ast 
      Compiler::Process.new(symbol.ast, block.ast)
    end
  end

  def _nt_process
    start_index = index
    if node_cache[:process].has_key?(index)
      cached = node_cache[:process][index]
      if cached
        node_cache[:process][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_optional_ws
    s0 << r1
    if r1
      if (match_len = has_terminal?('process', false, index))
        r2 = instantiate_node(SyntaxNode,input, index...(index + match_len))
        @index += match_len
      else
        terminal_parse_failure('process')
        r2 = nil
      end
      s0 << r2
      if r2
        r3 = _nt_ws
        s0 << r3
        if r3
          r4 = _nt_symbol
          s0 << r4
          if r4
            r5 = _nt_ws
            s0 << r5
            if r5
              r6 = _nt_block
              s0 << r6
              if r6
                r7 = _nt_optional_ws
                s0 << r7
              end
            end
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Process0)
      r0.extend(Process1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:process][start_index] = r0

    r0
  end

  module Block0
    def s
      elements[0]
    end

    def ws
      elements[1]
    end
  end

  module Block1
    def ws
      elements[1]
    end

    def statements
      elements[2]
    end

  end

  module Block2
    def ast 
      statements.elements.map{|e| e.s.ast}
    end
  end

  def _nt_block
    start_index = index
    if node_cache[:block].has_key?(index)
      cached = node_cache[:block][index]
      if cached
        node_cache[:block][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if (match_len = has_terminal?('do', false, index))
      r1 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      @index += match_len
    else
      terminal_parse_failure('do')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_ws
      s0 << r2
      if r2
        s3, i3 = [], index
        loop do
          i4, s4 = index, []
          r5 = _nt_statement
          s4 << r5
          if r5
            r6 = _nt_ws
            s4 << r6
          end
          if s4.last
            r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
            r4.extend(Block0)
          else
            @index = i4
            r4 = nil
          end
          if r4
            s3 << r4
          else
            break
          end
        end
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
        s0 << r3
        if r3
          if (match_len = has_terminal?('end', false, index))
            r7 = instantiate_node(SyntaxNode,input, index...(index + match_len))
            @index += match_len
          else
            terminal_parse_failure('end')
            r7 = nil
          end
          s0 << r7
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Block1)
      r0.extend(Block2)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:block][start_index] = r0

    r0
  end

  module ElseBlock0
    def s
      elements[0]
    end

    def ws
      elements[1]
    end
  end

  module ElseBlock1
    def ws
      elements[1]
    end

    def statements
      elements[2]
    end

  end

  module ElseBlock2
    def ast 
      statements.elements.map{|e| e.s.ast}
    end
  end

  def _nt_else_block
    start_index = index
    if node_cache[:else_block].has_key?(index)
      cached = node_cache[:else_block][index]
      if cached
        node_cache[:else_block][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if (match_len = has_terminal?('do', false, index))
      r1 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      @index += match_len
    else
      terminal_parse_failure('do')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_ws
      s0 << r2
      if r2
        s3, i3 = [], index
        loop do
          i4, s4 = index, []
          r5 = _nt_statement
          s4 << r5
          if r5
            r6 = _nt_ws
            s4 << r6
          end
          if s4.last
            r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
            r4.extend(ElseBlock0)
          else
            @index = i4
            r4 = nil
          end
          if r4
            s3 << r4
          else
            break
          end
        end
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
        s0 << r3
        if r3
          if (match_len = has_terminal?('else', false, index))
            r7 = instantiate_node(SyntaxNode,input, index...(index + match_len))
            @index += match_len
          else
            terminal_parse_failure('else')
            r7 = nil
          end
          s0 << r7
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(ElseBlock1)
      r0.extend(ElseBlock2)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:else_block][start_index] = r0

    r0
  end

  module Statement0
    def t
      elements[0]
    end
  end

  module Statement1
    def ast; t.ast; end
  end

  module Statement2
    def i1
      elements[0]
    end
  end

  module Statement3
    def ast; i1.ast; end
  end

  module Statement4
    def i2
      elements[0]
    end
  end

  module Statement5
    def ast; i2.ast; end
  end

  module Statement6
    def i3
      elements[0]
    end
  end

  module Statement7
    def ast; i3.ast; end
  end

  module Statement8
    def w
      elements[0]
    end
  end

  module Statement9
    def ast; w.ast; end
  end

  def _nt_statement
    start_index = index
    if node_cache[:statement].has_key?(index)
      cached = node_cache[:statement][index]
      if cached
        node_cache[:statement][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_task
    s1 << r2
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Statement0)
      r1.extend(Statement1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r1 = SyntaxNode.new(input, (index-1)...index) if r1 == true
      r0 = r1
    else
      i3, s3 = index, []
      r4 = _nt_in_order
      s3 << r4
      if s3.last
        r3 = instantiate_node(SyntaxNode,input, i3...index, s3)
        r3.extend(Statement2)
        r3.extend(Statement3)
      else
        @index = i3
        r3 = nil
      end
      if r3
        r3 = SyntaxNode.new(input, (index-1)...index) if r3 == true
        r0 = r3
      else
        i5, s5 = index, []
        r6 = _nt_in_parallel
        s5 << r6
        if s5.last
          r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
          r5.extend(Statement4)
          r5.extend(Statement5)
        else
          @index = i5
          r5 = nil
        end
        if r5
          r5 = SyntaxNode.new(input, (index-1)...index) if r5 == true
          r0 = r5
        else
          i7, s7 = index, []
          r8 = _nt_if
          s7 << r8
          if s7.last
            r7 = instantiate_node(SyntaxNode,input, i7...index, s7)
            r7.extend(Statement6)
            r7.extend(Statement7)
          else
            @index = i7
            r7 = nil
          end
          if r7
            r7 = SyntaxNode.new(input, (index-1)...index) if r7 == true
            r0 = r7
          else
            i9, s9 = index, []
            r10 = _nt_while
            s9 << r10
            if s9.last
              r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
              r9.extend(Statement8)
              r9.extend(Statement9)
            else
              @index = i9
              r9 = nil
            end
            if r9
              r9 = SyntaxNode.new(input, (index-1)...index) if r9 == true
              r0 = r9
            else
              @index = i0
              r0 = nil
            end
          end
        end
      end
    end

    node_cache[:statement][start_index] = r0

    r0
  end

  module If0
    def ws1
      elements[1]
    end

    def e1
      elements[2]
    end

    def ws2
      elements[3]
    end

    def b1
      elements[4]
    end
  end

  module If1
    def ast
      Compiler::If.new(e1.ast, b1.ast, nil)
    end
  end

  module If2
    def ws1
      elements[1]
    end

    def e2
      elements[2]
    end

    def ws2
      elements[3]
    end

    def b2
      elements[4]
    end

    def ws3
      elements[5]
    end

    def b3
      elements[6]
    end
  end

  module If3
    def ast
      Compiler::If.new(e2.ast, b2.ast, b3.ast)
    end
  end

  def _nt_if
    start_index = index
    if node_cache[:if].has_key?(index)
      cached = node_cache[:if][index]
      if cached
        node_cache[:if][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if (match_len = has_terminal?('if', false, index))
      r2 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      @index += match_len
    else
      terminal_parse_failure('if')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_ws
      s1 << r3
      if r3
        r4 = _nt_expression
        s1 << r4
        if r4
          r5 = _nt_ws
          s1 << r5
          if r5
            r6 = _nt_block
            s1 << r6
          end
        end
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(If0)
      r1.extend(If1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r1 = SyntaxNode.new(input, (index-1)...index) if r1 == true
      r0 = r1
    else
      i7, s7 = index, []
      if (match_len = has_terminal?('if', false, index))
        r8 = instantiate_node(SyntaxNode,input, index...(index + match_len))
        @index += match_len
      else
        terminal_parse_failure('if')
        r8 = nil
      end
      s7 << r8
      if r8
        r9 = _nt_ws
        s7 << r9
        if r9
          r10 = _nt_expression
          s7 << r10
          if r10
            r11 = _nt_ws
            s7 << r11
            if r11
              r12 = _nt_else_block
              s7 << r12
              if r12
                r13 = _nt_ws
                s7 << r13
                if r13
                  r14 = _nt_block
                  s7 << r14
                end
              end
            end
          end
        end
      end
      if s7.last
        r7 = instantiate_node(SyntaxNode,input, i7...index, s7)
        r7.extend(If2)
        r7.extend(If3)
      else
        @index = i7
        r7 = nil
      end
      if r7
        r7 = SyntaxNode.new(input, (index-1)...index) if r7 == true
        r0 = r7
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:if][start_index] = r0

    r0
  end

  module While0
    def bs
      elements[1]
    end

    def ws1
      elements[2]
    end

    def e
      elements[3]
    end

    def ws2
      elements[4]
    end

    def b
      elements[5]
    end
  end

  module While1
    def ast
      Compiler::While.new(bs.empty? ? nil: bs.ast, e.ast, b.ast)
    end
  end

  def _nt_while
    start_index = index
    if node_cache[:while].has_key?(index)
      cached = node_cache[:while][index]
      if cached
        node_cache[:while][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if (match_len = has_terminal?('while', false, index))
      r1 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      @index += match_len
    else
      terminal_parse_failure('while')
      r1 = nil
    end
    s0 << r1
    if r1
      r3 = _nt_braced_statements
      if r3
        r2 = r3
      else
        r2 = instantiate_node(SyntaxNode,input, index...index)
      end
      s0 << r2
      if r2
        r4 = _nt_ws
        s0 << r4
        if r4
          r5 = _nt_expression
          s0 << r5
          if r5
            r6 = _nt_ws
            s0 << r6
            if r6
              r7 = _nt_block
              s0 << r7
            end
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(While0)
      r0.extend(While1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:while][start_index] = r0

    r0
  end

  module BracedStatements0
    def s
      elements[0]
    end

    def ws
      elements[1]
    end
  end

  module BracedStatements1
    def optional_ws1
      elements[0]
    end

    def optional_ws2
      elements[2]
    end

    def statements
      elements[3]
    end

  end

  module BracedStatements2
    def ast
      if statements.empty?
        nil
      else
        statements.elements.map{|e| e.s.ast}
      end
    end
  end

  def _nt_braced_statements
    start_index = index
    if node_cache[:braced_statements].has_key?(index)
      cached = node_cache[:braced_statements][index]
      if cached
        node_cache[:braced_statements][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_optional_ws
    s0 << r1
    if r1
      if (match_len = has_terminal?('{', false, index))
        r2 = true
        @index += match_len
      else
        terminal_parse_failure('{')
        r2 = nil
      end
      s0 << r2
      if r2
        r3 = _nt_optional_ws
        s0 << r3
        if r3
          s4, i4 = [], index
          loop do
            i5, s5 = index, []
            r6 = _nt_statement
            s5 << r6
            if r6
              r7 = _nt_ws
              s5 << r7
            end
            if s5.last
              r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
              r5.extend(BracedStatements0)
            else
              @index = i5
              r5 = nil
            end
            if r5
              s4 << r5
            else
              break
            end
          end
          r4 = instantiate_node(SyntaxNode,input, i4...index, s4)
          s0 << r4
          if r4
            if (match_len = has_terminal?('}', false, index))
              r8 = true
              @index += match_len
            else
              terminal_parse_failure('}')
              r8 = nil
            end
            s0 << r8
          end
        end
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(BracedStatements1)
      r0.extend(BracedStatements2)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:braced_statements][start_index] = r0

    r0
  end

  module InOrder0
    def ws
      elements[1]
    end

    def block
      elements[2]
    end
  end

  module InOrder1
    def ast
      Compiler::InOrder.new(block.ast)
    end
  end

  def _nt_in_order
    start_index = index
    if node_cache[:in_order].has_key?(index)
      cached = node_cache[:in_order][index]
      if cached
        node_cache[:in_order][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if (match_len = has_terminal?('in_order', false, index))
      r1 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      @index += match_len
    else
      terminal_parse_failure('in_order')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_ws
      s0 << r2
      if r2
        r3 = _nt_block
        s0 << r3
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(InOrder0)
      r0.extend(InOrder1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:in_order][start_index] = r0

    r0
  end

  module InParallel0
    def ws
      elements[1]
    end

    def block
      elements[2]
    end
  end

  module InParallel1
    def ast
      Compiler::InParallel.new(block.ast)
    end
  end

  def _nt_in_parallel
    start_index = index
    if node_cache[:in_parallel].has_key?(index)
      cached = node_cache[:in_parallel][index]
      if cached
        node_cache[:in_parallel][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if (match_len = has_terminal?('in_parallel', false, index))
      r1 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      @index += match_len
    else
      terminal_parse_failure('in_parallel')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_ws
      s0 << r2
      if r2
        r3 = _nt_block
        s0 << r3
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(InParallel0)
      r0.extend(InParallel1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:in_parallel][start_index] = r0

    r0
  end

  module Task0
    def ws
      elements[1]
    end

    def symbol
      elements[2]
    end
  end

  module Task1
    def ast
      Compiler::Task.new(symbol.ast)
    end
  end

  def _nt_task
    start_index = index
    if node_cache[:task].has_key?(index)
      cached = node_cache[:task][index]
      if cached
        node_cache[:task][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if (match_len = has_terminal?('task', false, index))
      r1 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      @index += match_len
    else
      terminal_parse_failure('task')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_ws
      s0 << r2
      if r2
        r3 = _nt_symbol
        s0 << r3
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Task0)
      r0.extend(Task1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:task][start_index] = r0

    r0
  end

  module Expression0
    def optional_ws1
      elements[1]
    end

    def e
      elements[2]
    end

    def optional_ws2
      elements[3]
    end

  end

  module Expression1
    def ast
      e.ast
    end
  end

  module Expression2
    def b
      elements[0]
    end
  end

  module Expression3
    def ast
      b.ast
    end
  end

  module Expression4
    def u
      elements[0]
    end
  end

  module Expression5
    def ast
      u.ast
    end
  end

  def _nt_expression
    start_index = index
    if node_cache[:expression].has_key?(index)
      cached = node_cache[:expression][index]
      if cached
        node_cache[:expression][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    i1, s1 = index, []
    if (match_len = has_terminal?('(', false, index))
      r2 = true
      @index += match_len
    else
      terminal_parse_failure('(')
      r2 = nil
    end
    s1 << r2
    if r2
      r3 = _nt_optional_ws
      s1 << r3
      if r3
        r4 = _nt_expression
        s1 << r4
        if r4
          r5 = _nt_optional_ws
          s1 << r5
          if r5
            if (match_len = has_terminal?(')', false, index))
              r6 = true
              @index += match_len
            else
              terminal_parse_failure(')')
              r6 = nil
            end
            s1 << r6
          end
        end
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(Expression0)
      r1.extend(Expression1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r1 = SyntaxNode.new(input, (index-1)...index) if r1 == true
      r0 = r1
    else
      i7, s7 = index, []
      r8 = _nt_binary_expression
      s7 << r8
      if s7.last
        r7 = instantiate_node(SyntaxNode,input, i7...index, s7)
        r7.extend(Expression2)
        r7.extend(Expression3)
      else
        @index = i7
        r7 = nil
      end
      if r7
        r7 = SyntaxNode.new(input, (index-1)...index) if r7 == true
        r0 = r7
      else
        i9, s9 = index, []
        r10 = _nt_unary_expression
        s9 << r10
        if s9.last
          r9 = instantiate_node(SyntaxNode,input, i9...index, s9)
          r9.extend(Expression4)
          r9.extend(Expression5)
        else
          @index = i9
          r9 = nil
        end
        if r9
          r9 = SyntaxNode.new(input, (index-1)...index) if r9 == true
          r0 = r9
        else
          @index = i0
          r0 = nil
        end
      end
    end

    node_cache[:expression][start_index] = r0

    r0
  end

  module BinaryExpression0
    def o1
      elements[0]
    end

    def optional_ws1
      elements[1]
    end

    def binary_operator
      elements[2]
    end

    def optional_ws2
      elements[3]
    end

    def e
      elements[4]
    end
  end

  module BinaryExpression1
    def ast
      Compiler::BinaryExpression.new(o1.text_value, binary_operator.text_value, e.ast)
    end
  end

  module BinaryExpression2
    def o1
      elements[0]
    end

    def optional_ws1
      elements[1]
    end

    def binary_operator
      elements[2]
    end

    def optional_ws2
      elements[3]
    end

    def o2
      elements[4]
    end
  end

  module BinaryExpression3
    def ast
      Compiler::BinaryExpression.new(o1.text_value, binary_operator.text_value, o2.text_value)
    end
  end

  def _nt_binary_expression
    start_index = index
    if node_cache[:binary_expression].has_key?(index)
      cached = node_cache[:binary_expression][index]
      if cached
        node_cache[:binary_expression][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_operand
    s1 << r2
    if r2
      r3 = _nt_optional_ws
      s1 << r3
      if r3
        r4 = _nt_binary_operator
        s1 << r4
        if r4
          r5 = _nt_optional_ws
          s1 << r5
          if r5
            r6 = _nt_expression
            s1 << r6
          end
        end
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(BinaryExpression0)
      r1.extend(BinaryExpression1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r1 = SyntaxNode.new(input, (index-1)...index) if r1 == true
      r0 = r1
    else
      i7, s7 = index, []
      r8 = _nt_operand
      s7 << r8
      if r8
        r9 = _nt_optional_ws
        s7 << r9
        if r9
          r10 = _nt_binary_operator
          s7 << r10
          if r10
            r11 = _nt_optional_ws
            s7 << r11
            if r11
              r12 = _nt_operand
              s7 << r12
            end
          end
        end
      end
      if s7.last
        r7 = instantiate_node(SyntaxNode,input, i7...index, s7)
        r7.extend(BinaryExpression2)
        r7.extend(BinaryExpression3)
      else
        @index = i7
        r7 = nil
      end
      if r7
        r7 = SyntaxNode.new(input, (index-1)...index) if r7 == true
        r0 = r7
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:binary_expression][start_index] = r0

    r0
  end

  def _nt_binary_operator
    start_index = index
    if node_cache[:binary_operator].has_key?(index)
      cached = node_cache[:binary_operator][index]
      if cached
        node_cache[:binary_operator][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    if (match_len = has_terminal?('+', false, index))
      r1 = true
      @index += match_len
    else
      terminal_parse_failure('+')
      r1 = nil
    end
    if r1
      r1 = SyntaxNode.new(input, (index-1)...index) if r1 == true
      r0 = r1
    else
      if (match_len = has_terminal?('-', false, index))
        r2 = true
        @index += match_len
      else
        terminal_parse_failure('-')
        r2 = nil
      end
      if r2
        r2 = SyntaxNode.new(input, (index-1)...index) if r2 == true
        r0 = r2
      else
        if (match_len = has_terminal?('*', false, index))
          r3 = true
          @index += match_len
        else
          terminal_parse_failure('*')
          r3 = nil
        end
        if r3
          r3 = SyntaxNode.new(input, (index-1)...index) if r3 == true
          r0 = r3
        else
          if (match_len = has_terminal?('/', false, index))
            r4 = true
            @index += match_len
          else
            terminal_parse_failure('/')
            r4 = nil
          end
          if r4
            r4 = SyntaxNode.new(input, (index-1)...index) if r4 == true
            r0 = r4
          else
            if (match_len = has_terminal?('==', false, index))
              r5 = instantiate_node(SyntaxNode,input, index...(index + match_len))
              @index += match_len
            else
              terminal_parse_failure('==')
              r5 = nil
            end
            if r5
              r5 = SyntaxNode.new(input, (index-1)...index) if r5 == true
              r0 = r5
            else
              if (match_len = has_terminal?('>', false, index))
                r6 = true
                @index += match_len
              else
                terminal_parse_failure('>')
                r6 = nil
              end
              if r6
                r6 = SyntaxNode.new(input, (index-1)...index) if r6 == true
                r0 = r6
              else
                if (match_len = has_terminal?('>=', false, index))
                  r7 = instantiate_node(SyntaxNode,input, index...(index + match_len))
                  @index += match_len
                else
                  terminal_parse_failure('>=')
                  r7 = nil
                end
                if r7
                  r7 = SyntaxNode.new(input, (index-1)...index) if r7 == true
                  r0 = r7
                else
                  if (match_len = has_terminal?('<', false, index))
                    r8 = true
                    @index += match_len
                  else
                    terminal_parse_failure('<')
                    r8 = nil
                  end
                  if r8
                    r8 = SyntaxNode.new(input, (index-1)...index) if r8 == true
                    r0 = r8
                  else
                    if (match_len = has_terminal?('<=', false, index))
                      r9 = instantiate_node(SyntaxNode,input, index...(index + match_len))
                      @index += match_len
                    else
                      terminal_parse_failure('<=')
                      r9 = nil
                    end
                    if r9
                      r9 = SyntaxNode.new(input, (index-1)...index) if r9 == true
                      r0 = r9
                    else
                      @index = i0
                      r0 = nil
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    node_cache[:binary_operator][start_index] = r0

    r0
  end

  module UnaryExpression0
    def unary_operator
      elements[0]
    end

    def optional_ws
      elements[1]
    end

    def expression
      elements[2]
    end
  end

  module UnaryExpression1
    def ast
      Compiler::UnaryExpression.new(unary_operator.text_value, expression.ast)
    end
  end

  module UnaryExpression2
    def unary_operator
      elements[0]
    end

    def optional_ws
      elements[1]
    end

    def operand
      elements[2]
    end
  end

  module UnaryExpression3
    def ast
      Compiler::UnaryExpression.new(unary_operator.text_value, expression.ast)
    end
  end

  def _nt_unary_expression
    start_index = index
    if node_cache[:unary_expression].has_key?(index)
      cached = node_cache[:unary_expression][index]
      if cached
        node_cache[:unary_expression][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    i1, s1 = index, []
    r2 = _nt_unary_operator
    s1 << r2
    if r2
      r3 = _nt_optional_ws
      s1 << r3
      if r3
        r4 = _nt_expression
        s1 << r4
      end
    end
    if s1.last
      r1 = instantiate_node(SyntaxNode,input, i1...index, s1)
      r1.extend(UnaryExpression0)
      r1.extend(UnaryExpression1)
    else
      @index = i1
      r1 = nil
    end
    if r1
      r1 = SyntaxNode.new(input, (index-1)...index) if r1 == true
      r0 = r1
    else
      i5, s5 = index, []
      r6 = _nt_unary_operator
      s5 << r6
      if r6
        r7 = _nt_optional_ws
        s5 << r7
        if r7
          r8 = _nt_operand
          s5 << r8
        end
      end
      if s5.last
        r5 = instantiate_node(SyntaxNode,input, i5...index, s5)
        r5.extend(UnaryExpression2)
        r5.extend(UnaryExpression3)
      else
        @index = i5
        r5 = nil
      end
      if r5
        r5 = SyntaxNode.new(input, (index-1)...index) if r5 == true
        r0 = r5
      else
        @index = i0
        r0 = nil
      end
    end

    node_cache[:unary_expression][start_index] = r0

    r0
  end

  def _nt_unary_operator
    start_index = index
    if node_cache[:unary_operator].has_key?(index)
      cached = node_cache[:unary_operator][index]
      if cached
        node_cache[:unary_operator][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    if (match_len = has_terminal?('!', false, index))
      r0 = instantiate_node(SyntaxNode,input, index...(index + match_len))
      @index += match_len
    else
      terminal_parse_failure('!')
      r0 = nil
    end

    node_cache[:unary_operator][start_index] = r0

    r0
  end

  def _nt_operand
    start_index = index
    if node_cache[:operand].has_key?(index)
      cached = node_cache[:operand][index]
      if cached
        node_cache[:operand][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0 = index
    r1 = _nt_numeric_literal
    if r1
      r1 = SyntaxNode.new(input, (index-1)...index) if r1 == true
      r0 = r1
    else
      r2 = _nt_string_literal
      if r2
        r2 = SyntaxNode.new(input, (index-1)...index) if r2 == true
        r0 = r2
      else
        r3 = _nt_identifier
        if r3
          r3 = SyntaxNode.new(input, (index-1)...index) if r3 == true
          r0 = r3
        else
          @index = i0
          r0 = nil
        end
      end
    end

    node_cache[:operand][start_index] = r0

    r0
  end

  def _nt_numeric_literal
    start_index = index
    if node_cache[:numeric_literal].has_key?(index)
      cached = node_cache[:numeric_literal][index]
      if cached
        node_cache[:numeric_literal][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?(@regexps[gr = '\A[\\d]'] ||= Regexp.new(gr), :regexp, index)
        r1 = true
        @index += 1
      else
        terminal_parse_failure('[\\d]')
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
    end

    node_cache[:numeric_literal][start_index] = r0

    r0
  end

  module StringLiteral0
  end

  def _nt_string_literal
    start_index = index
    if node_cache[:string_literal].has_key?(index)
      cached = node_cache[:string_literal][index]
      if cached
        node_cache[:string_literal][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if (match_len = has_terminal?("'", false, index))
      r1 = true
      @index += match_len
    else
      terminal_parse_failure("'")
      r1 = nil
    end
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        if has_terminal?(@regexps[gr = '\A[^\']'] ||= Regexp.new(gr), :regexp, index)
          r3 = true
          @index += 1
        else
          terminal_parse_failure('[^\']')
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = instantiate_node(SyntaxNode,input, i2...index, s2)
      s0 << r2
      if r2
        if (match_len = has_terminal?("'", false, index))
          r4 = true
          @index += match_len
        else
          terminal_parse_failure("'")
          r4 = nil
        end
        s0 << r4
      end
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(StringLiteral0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:string_literal][start_index] = r0

    r0
  end

  module Symbol0
    def identifier
      elements[1]
    end
  end

  module Symbol1
    def ast
      Compiler::Symbol.new(identifier.text_value)
    end
  end

  def _nt_symbol
    start_index = index
    if node_cache[:symbol].has_key?(index)
      cached = node_cache[:symbol][index]
      if cached
        node_cache[:symbol][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    if (match_len = has_terminal?(':', false, index))
      r1 = true
      @index += match_len
    else
      terminal_parse_failure(':')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_identifier
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Symbol0)
      r0.extend(Symbol1)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:symbol][start_index] = r0

    r0
  end

  module Identifier0
    def identifier_start
      elements[0]
    end

    def identifier_rest
      elements[1]
    end
  end

  def _nt_identifier
    start_index = index
    if node_cache[:identifier].has_key?(index)
      cached = node_cache[:identifier][index]
      if cached
        node_cache[:identifier][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_identifier_start
    s0 << r1
    if r1
      r2 = _nt_identifier_rest
      s0 << r2
    end
    if s0.last
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
      r0.extend(Identifier0)
    else
      @index = i0
      r0 = nil
    end

    node_cache[:identifier][start_index] = r0

    r0
  end

  def _nt_identifier_start
    start_index = index
    if node_cache[:identifier_start].has_key?(index)
      cached = node_cache[:identifier_start][index]
      if cached
        node_cache[:identifier_start][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    if has_terminal?(@regexps[gr = '\A[A-Za-z]'] ||= Regexp.new(gr), :regexp, index)
      r0 = instantiate_node(SyntaxNode,input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('[A-Za-z]')
      r0 = nil
    end

    node_cache[:identifier_start][start_index] = r0

    r0
  end

  def _nt_identifier_rest
    start_index = index
    if node_cache[:identifier_rest].has_key?(index)
      cached = node_cache[:identifier_rest][index]
      if cached
        node_cache[:identifier_rest][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?(@regexps[gr = '\A[A-Za-z0-9]'] ||= Regexp.new(gr), :regexp, index)
        r1 = true
        @index += 1
      else
        terminal_parse_failure('[A-Za-z0-9]')
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(SyntaxNode,input, i0...index, s0)

    node_cache[:identifier_rest][start_index] = r0

    r0
  end

  def _nt_optional_ws
    start_index = index
    if node_cache[:optional_ws].has_key?(index)
      cached = node_cache[:optional_ws][index]
      if cached
        node_cache[:optional_ws][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?(@regexps[gr = '\A[ \\t\\n]'] ||= Regexp.new(gr), :regexp, index)
        r1 = true
        @index += 1
      else
        terminal_parse_failure('[ \\t\\n]')
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = instantiate_node(SyntaxNode,input, i0...index, s0)

    node_cache[:optional_ws][start_index] = r0

    r0
  end

  def _nt_ws
    start_index = index
    if node_cache[:ws].has_key?(index)
      cached = node_cache[:ws][index]
      if cached
        node_cache[:ws][index] = cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
        @index = cached.interval.end
      end
      return cached
    end

    s0, i0 = [], index
    loop do
      if has_terminal?(@regexps[gr = '\A[ \\t\\n]'] ||= Regexp.new(gr), :regexp, index)
        r1 = true
        @index += 1
      else
        terminal_parse_failure('[ \\t\\n]')
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      @index = i0
      r0 = nil
    else
      r0 = instantiate_node(SyntaxNode,input, i0...index, s0)
    end

    node_cache[:ws][start_index] = r0

    r0
  end

end

class BPMNLangParser < Treetop::Runtime::CompiledParser
  include BPMNLang
end

