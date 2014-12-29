require './BPMNLang'

include BPMNLang

describe Runner do
  def expect_match(node, node_spec, matches=[])
    traces = []
    begin
    node_spec.each_slice(2) do |klass, methods_and_values|
      expect(node.is_a?(klass)).to eq(true)
      matches.push([:is_a?, klass])
      methods_and_values.each do |method, value|
        traces.push("method: #{method}, value: #{value}")
        if value.is_a?(Array) && value.first.is_a?(Module)
          new_nodes = node.send(method)
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
      node = Runner.parse("process :p1 do end")

      expect_match(node, [
        ProcessNode, {
          name: 'p1',
          statements: [ 
          ]
        }
      ])
    end

    it "should parse a task with leading and trailing spaces" do
      node = Runner.parse(<<-EOT)
        process :p1 do 
          task :task1 
        end
      EOT

      expect_match(node, [
        ProcessNode, {
          name: 'p1',
          statements: [ 
            TaskNode, {
              name: 'task1'  
            }
          ]
        }
      ])
    end

    it "should parse two tasks" do
      node = Runner.parse(<<-EOT)
        process :p1 do
          task :task1 
          task :task2 
        end
      EOT

      expect_match(node, [
        ProcessNode, {
          name: 'p1',
          statements: [ 
            TaskNode, {
              name: 'task1'  
            },
            TaskNode, {
              name: 'task2'  
            }
          ]
        }
      ])
    end
  end

  context "when doing in_parallel and in_order" do
    it "should parse an empty block" do
      node = Runner.parse('process :p1 do in_order do end end')

      expect_match(node, [
        ProcessNode, {
          name: 'p1',
          statements: [ 
            InOrderNode, {
              statements: [] 
            }
          ]
        }
      ])
    end

    it "should parse an in_order with a block with a task in it" do
      node = Runner.parse('process :p1 do in_order do task :task1 end end')

      expect_match(node, [
        ProcessNode, {
          name: 'p1',
          statements: [ 
            InOrderNode, {
              statements: [
                TaskNode, {
                  name: 'task1'
                }
              ]
            }
          ]
        }
      ])
    end

    it "should parse an in_order with a block with two tasks in it" do
      node = Runner.parse(<<-EOT)
        process :p1 do
          in_order do
            task :task1 
            task :task2 
          end
        end
      EOT

      expect_match(node, [
        ProcessNode, {
          name: 'p1',
          statements: [ 
            InOrderNode, {
              statements: [
                TaskNode, {
                  name: 'task1'
                },
                TaskNode, {
                  name: 'task2'
                }
              ]
            }
          ]
        }
      ])
    end

    it "should parse in_parallel with a block with a task in it" do
      node = Runner.parse('process :p1 do in_parallel do task :task1 end end')

      expect_match(node, [
        ProcessNode, {
          name: 'p1',
          statements: [ 
            InParallelNode, {
              statements: [
                TaskNode, {
                  name: 'task1'
                }
              ]
            }
          ]
        }
      ])
    end

    it "should parse an in_order block with a nested in_parallel block in it with a task" do

      node = Runner.parse(<<-EOT)
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
        ProcessNode, {
          name: 'p1',
          statements: [ 
            InOrderNode, {
              statements: [
                TaskNode, {
                  name: 'task1'  
                },
                InParallelNode, {
                  statements: [
                    TaskNode, {
                      name: 'task2'  
                    },
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
    it "should parse an if statement with a simple expression" do
      node = Runner.parse(<<-EOT)
        process :p1 do
          if 1 == 1 do
          end
        end
      EOT

      
      expect_match(node, [
        ProcessNode, {
          name: 'p1',
          statements: [
            IfNode, {
              evaluate: "1 == 1"
            }
          ]
        }
      ])
    end

    it "should parse an if statement with a simple expression" do
      node = Runner.parse(<<-EOT)
        process :p1 do
          if 1 + 1 + 1 do 
          end
        end
      EOT

      expect_match(node, [
        ProcessNode, {
          name: 'p1',
          statements: [
            IfNode, {
              evaluate: "1 + 1 + 1"
            }
          ]
        }
      ])
    end
  end
end
