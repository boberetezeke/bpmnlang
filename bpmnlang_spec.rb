require './BPMNLang'

describe BPMNLang::Runner do
  context "when parsing statements" do
    it "should parse a simple task" do
      node = BPMNLang::Runner.parse('task :task1')

      #expect_match(node, [
      #  BPMNLang::StatementsNode, statements: [
      #    BPMNLang::
      expect(node.is_a?(BPMNLang::StatementsNode)).to eq(true)
      expect(node.statements.size).to eq(1)
      task = node.statements.first
      expect(task.is_a?(BPMNLang::TaskNode)).to eq(true)
      expect(task.name).to eq('task1')
    end

    it "should parse a task with leading and trailing spaces" do
      node = BPMNLang::Runner.parse(<<-EOT)
        task :task1 
      EOT

      expect(node.is_a?(BPMNLang::StatementsNode)).to eq(true)
      expect(node.statements.size).to eq(1)
      task = node.statements.first
      expect(task.is_a?(BPMNLang::TaskNode)).to eq(true)
      expect(task.name).to eq('task1')
    end

    it "should parse two tasks" do
      node = BPMNLang::Runner.parse(<<-EOT)
        task :task1 
        task :task2 
      EOT

      expect(node.is_a?(BPMNLang::StatementsNode)).to eq(true)
      expect(node.statements.size).to eq(2)
      task1, task2 = node.statements
      expect(task1.is_a?(BPMNLang::TaskNode)).to eq(true)
      expect(task1.name).to eq('task1')
      expect(task2.is_a?(BPMNLang::TaskNode)).to eq(true)
      expect(task2.name).to eq('task2')
    end
  end

  context "when doing in_parallel and in_order" do
    it "should parse an empty block" do
      node = BPMNLang::Runner.parse('in_order do end')

      expect(node.is_a?(BPMNLang::StatementsNode)).to eq(true)
      in_order_node = node.statements.first
      expect(in_order_node.is_a?(BPMNLang::InOrderNode)).to eq(true)
      in_order_block_statements = in_order_node.statements
      expect(in_order_block_statements.size).to eq(0)
    end

    it "should parse an in_order with a block with a task in it" do
      node = BPMNLang::Runner.parse('in_order do task :task1 end')

      expect(node.is_a?(BPMNLang::StatementsNode)).to eq(true)
      in_order_node = node.statements.first
      expect(in_order_node.is_a?(BPMNLang::InOrderNode)).to eq(true)
      in_order_block_statements = in_order_node.statements
      expect(in_order_block_statements.size).to eq(1)
      task = in_order_block_statements.first
      expect(task.is_a?(BPMNLang::TaskNode)).to eq(true)
      expect(task.name).to eq('task1')
    end

    it "should parse an in_order with a block with two tasks in it" do
      node = BPMNLang::Runner.parse(<<-EOT)
        in_order do
          task :task1 
          task :task2 
        end
      EOT

      expect(node.is_a?(BPMNLang::StatementsNode)).to eq(true)
      in_order_node = node.statements.first
      expect(in_order_node.is_a?(BPMNLang::InOrderNode)).to eq(true)
      in_order_block_statements = in_order_node.statements
      expect(in_order_block_statements.size).to eq(2)
      task1, task2 = in_order_block_statements
      expect(task1.is_a?(BPMNLang::TaskNode)).to eq(true)
      expect(task1.name).to eq('task1')
      expect(task2.is_a?(BPMNLang::TaskNode)).to eq(true)
      expect(task2.name).to eq('task2')
    end

    it "should parse in_parallel with a block with a task in it" do
      node = BPMNLang::Runner.parse('in_parallel do task :task1 end')

      expect(node.is_a?(BPMNLang::StatementsNode)).to eq(true)
      in_order_node = node.statements.first
      expect(in_order_node.is_a?(BPMNLang::InParallelNode)).to eq(true)
      in_order_block_statements = in_order_node.statements
      expect(in_order_block_statements.size).to eq(1)
      task = in_order_block_statements.first
      expect(task.is_a?(BPMNLang::TaskNode)).to eq(true)
      expect(task.name).to eq('task1')
    end

    it "should parse an in_order block with a nested in_parallel block in it with a task" do

      node = BPMNLang::Runner.parse(<<-EOT)
        in_order do
          task :task1 
          in_parallel do
            task :task2
          end
        end
      EOT

      expect(node.is_a?(BPMNLang::StatementsNode)).to eq(true)
      in_order_node = node.statements.first
      expect(in_order_node.is_a?(BPMNLang::InOrderNode)).to eq(true)
      in_order_block_statements = in_order_node.statements
      expect(in_order_block_statements.size).to eq(2)
      task1, in_parallel = in_order_block_statements
      expect(task1.is_a?(BPMNLang::TaskNode)).to eq(true)
      expect(task1.name).to eq('task1')
      expect(in_parallel.is_a?(BPMNLang::InParallelNode)).to eq(true)
      expect(in_parallel.statements.size).to eq(1)
      task2 = in_parallel.statements.first
      expect(task2.is_a?(BPMNLang::TaskNode)).to eq(true)
      expect(task2.name).to eq('task2')
    end
  end
end
