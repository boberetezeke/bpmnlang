require './BPMNLang'

include BPMNLang

describe Runner do
  def expect_match(node, node_spec, matches=[])
    begin
    node_spec.each_slice(2) do |klass, methods_and_values|
      expect(node.is_a?(klass)).to eq(true)
      matches.push([:is_a?, klass])
      methods_and_values.each do |method, value|
        #puts "method: #{method}, value: #{value}"
        if value.is_a?(Array) && value.first.is_a?(Module)
          new_nodes = node.send(method)
          #puts "recurse"
          value.each_slice(2) do |klass, methods_and_values2|
            new_node = new_nodes.shift
            #puts "new_node = #{new_node}"
            expect_match(new_node, [klass, methods_and_values2], matches)
          end
        else
          #puts "check value"
          expect(node.send(method)).to eq(value)
          matches.push([:method, value])
        end
      end
    end
    rescue Exception
      puts "SUCCESSFUL matches: #{matches}"
      raise
    end
  end

  context "when parsing statements" do
    it "should parse a simple task" do
      node = Runner.parse('task :task1')

      expect_match(node, [
        StatementsNode, { 
          statements: [ 
            TaskNode, {
              name: 'task1'  
            }
          ]
        }
      ])
    end

    it "should parse a task with leading and trailing spaces" do
      node = Runner.parse(<<-EOT)
        task :task1 
      EOT

      expect_match(node, [
        StatementsNode, { 
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
        task :task1 
        task :task2 
      EOT

      expect_match(node, [
        StatementsNode, { 
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
      node = Runner.parse('in_order do end')

      expect_match(node, [
        StatementsNode, { 
          statements: [ 
            InOrderNode, {
              statements: [] 
            }
          ]
        }
      ])
    end

    it "should parse an in_order with a block with a task in it" do
      node = Runner.parse('in_order do task :task1 end')

      expect_match(node, [
        StatementsNode, { 
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
        in_order do
          task :task1 
          task :task2 
        end
      EOT

      expect_match(node, [
        StatementsNode, { 
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
      node = Runner.parse('in_parallel do task :task1 end')

      expect_match(node, [
        StatementsNode, { 
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
        in_order do
          task :task1 
          in_parallel do
            task :task2
          end
        end
      EOT

      expect_match(node, [
        StatementsNode, { 
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
end
