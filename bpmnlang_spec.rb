require './BPMNLang'

include BPMNLang

describe Runner do
  def expect_match(node, node_spec, matches=[])
    traces = []
    begin
    node_spec.each_slice(2) do |klass, methods_and_values|
      traces.push "checking for klass: #{klass} for node:#{node.class}"
      expect(node.is_a?(klass)).to eq(true)
      matches.push([:is_a?, klass])
      methods_and_values.each do |method, value|
        traces.push("method: #{method}, value: #{value}")
        if value.is_a?(Array) && value.first.is_a?(Module)
          new_nodes = node.send(method)
          new_nodes = [new_nodes] unless new_nodes.is_a?(Array)
          traces.push("recurse: node = #{node.inspect}, method = #{method}, new_nodes = #{new_nodes}")
          value.each_slice(2) do |klass, methods_and_values2|
            traces.push("new_nodes = #{new_nodes}")
            new_node = new_nodes.shift
            traces.push("new_node = #{new_node.inspect}")
            expect_match(new_node, [klass, methods_and_values2], matches)
          end
        else
          traces.push("check value, node: #{node.inspect}")
          expect(node.send(method)).to eq(value)
          matches.push([:method, value])
        end
      end
    end
    rescue Exception => e
      puts "SUCCESSFUL matches: #{matches}"
      puts "TRACES:"
      puts traces.join("\n")
      raise
    end
  end

  context "when parsing statements" do
    it "should parse a simple task" do
      node = Runner.parse("process :p1 do end").ast

      puts "node = #{node.inspect}"
      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
          ]
        }
      ])
    end

    it "should parse a task with leading and trailing spaces" do
      node = Runner.parse(<<-EOT).ast
        process :p1 do 
          task :task1 
        end
      EOT

      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
            Compiler::Task, {
              name: [
                Compiler::Symbol, { 
                  identifier: 'task1'
                }
              ]
            }
          ]
        }
      ])
    end

    it "should parse two tasks" do
      node = Runner.parse(<<-EOT).ast
        process :p1 do
          task :task1 
          task :task2 
        end
      EOT

      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
            Compiler::Task, {
              name: [
                Compiler::Symbol, { 
                  identifier: 'task1'
                }
              ]
            },
            Compiler::Task, {
              name: [
                Compiler::Symbol, { 
                  identifier: 'task2'
                }
              ]
            }
          ]
        }
      ])
    end
  end

  context "when doing in_parallel and in_order" do
    it "should parse an empty block" do
      node = Runner.parse('process :p1 do in_order do end end').ast

      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
            Compiler::InOrder, {
              statements: [] 
            }
          ]
        }
      ])
    end

    it "should parse an in_order with a block with a task in it" do
      node = Runner.parse('process :p1 do in_order do task :task1 end end').ast

      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
            Compiler::InOrder, {
              statements: [
                Compiler::Task, {
                  name: [
                    Compiler::Symbol, { 
                      identifier: 'task1'
                    }
                  ]
                }
              ] 
            }
          ]
        }
      ])
    end

    it "should parse an in_order with a block with two tasks in it" do
      node = Runner.parse(<<-EOT).ast
        process :p1 do
          in_order do
            task :task1 
            task :task2 
          end
        end
      EOT

      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
            Compiler::InOrder, {
              statements: [
                Compiler::Task, {
                  name: [
                    Compiler::Symbol, { 
                      identifier: 'task1'
                    }
                  ]
                },
                Compiler::Task, {
                  name: [
                    Compiler::Symbol, { 
                      identifier: 'task2'
                    }
                  ]
                }
              ] 
            }
          ]
        }
      ])
    end

    it "should parse in_parallel with a block with a task in it" do
      node = Runner.parse('process :p1 do in_parallel do task :task1 end end').ast

      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
            Compiler::InParallel, {
              statements: [
                Compiler::Task, {
                  name: [
                    Compiler::Symbol, { 
                      identifier: 'task1'
                    }
                  ]
                }
              ] 
            }
          ]
        }
      ])
    end

    it "should parse an in_order block with a nested in_parallel block in it with a task" do

      node = Runner.parse(<<-EOT).ast
        process :p1 do
          in_order do
            task :task1 
            in_parallel do
              task :task2
            end
          end
        end
      EOT

      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
            Compiler::InOrder, {
              statements: [
                Compiler::Task, {
                  name: [
                    Compiler::Symbol, { 
                      identifier: 'task1'
                    }
                  ]
                },
                Compiler::InParallel, {
                  statements: [
                    Compiler::Task, {
                      name: [
                        Compiler::Symbol, { 
                          identifier: 'task2'
                        }
                      ]
                    }
                  ]
                }
              ] 
            }
          ]
        }
      ])
    end
  end

  context "when parsing if and while statements" do
    it "should parse an if statement with a simple expression and a statement" do
      node = Runner.parse(<<-EOT).ast
        process :p1 do
          if 1 == 2 do
            task :task1
          end
        end
      EOT

      
      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
            Compiler::If, {
              expression: [
                Compiler::BinaryExpression, {
                  left_operand: "1",
                  operator: "==",
                  right_operand: "2"
                }
              ],
              if_statements: [
                Compiler::Task, {
                  name: [
                    Compiler::Symbol, { 
                      identifier: 'task1'
                    }
                  ]
                }
              ]
            }
          ]
        }
      ])
    end

    it "should parse an if statement with a simple expression" do
      node = Runner.parse(<<-EOT).ast
        process :p1 do
          if 1 + 2 - 3 do 
          end
        end
      EOT

      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
            Compiler::If, {
              expression: [
                Compiler::BinaryExpression, {
                  left_operand: "1",
                  operator: "+",
                  right_operand: [
                    Compiler::BinaryExpression, {
                      left_operand: "2",
                      operator: "-",
                      right_operand: "3"
                    }
                  ]
                }
              ],
              if_statements: [
              ]
            }
          ]
        }
      ])
    end

    it "should parse an if / else block with a simple expression" do
      node = Runner.parse(<<-EOT).ast
        process :p1 do
          if 1 + 2 - 3 do 
            task :task1
          else do
            task :task2
          end
        end
      EOT

      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
            Compiler::If, {
              expression: [
                Compiler::BinaryExpression, {
                  left_operand: "1",
                  operator: "+",
                  right_operand: [
                    Compiler::BinaryExpression, {
                      left_operand: "2",
                      operator: "-",
                      right_operand: "3"
                    }
                  ]
                }
              ],
              if_statements: [
                Compiler::Task, {
                  name: [
                    Compiler::Symbol, { 
                      identifier: 'task1'
                    }
                  ]
                }
              ],
              else_statements: [
                Compiler::Task, {
                  name: [
                    Compiler::Symbol, { 
                      identifier: 'task2'
                    }
                  ]
                }
              ]
            }
          ]
        }
      ])
    end

    it "should parse a while statement with a simple expression" do
      node = Runner.parse(<<-EOT).ast
        process :p1 do
          while 1 + 2 - 3 do 
          end
        end
      EOT

      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
            Compiler::While, {
              expression: [
                Compiler::BinaryExpression, {
                  left_operand: "1",
                  operator: "+",
                  right_operand: [
                    Compiler::BinaryExpression, {
                      left_operand: "2",
                      operator: "-",
                      right_operand: "3"
                    }
                  ]
                }
              ],
              statements: [
              ]
            }
          ]
        }
      ])
    end

    it "should parse a while statement with a optional statement and a simple expression" do
      node = Runner.parse(<<-EOT).ast
        process :p1 do
          while { task :task1 task :task2 } 1 + 2 - 3 do 
            task :task2
          end
        end
      EOT

      expect_match(node, [
        Compiler::Process, {
          name: [
            Compiler::Symbol, { 
              identifier: 'p1'
            }
          ],
          statements: [ 
            Compiler::While, {
              expression: [
                Compiler::BinaryExpression, {
                  left_operand: "1",
                  operator: "+",
                  right_operand: [
                    Compiler::BinaryExpression, {
                      left_operand: "2",
                      operator: "-",
                      right_operand: "3"
                    }
                  ]
                }
              ],
              optional_statements: [
                Compiler::Task, {
                  name: [
                    Compiler::Symbol, { 
                      identifier: 'task1'
                    }
                  ]
                },
                Compiler::Task, {
                  name: [
                    Compiler::Symbol, { 
                      identifier: 'task2'
                    }
                  ]
                }
              ],
              statements: [
                Compiler::Task, {
                  name: [
                    Compiler::Symbol, { 
                      identifier: 'task2'
                    }
                  ]
                }
              ]
            }
          ]
        }
      ])
    end
  end
end
