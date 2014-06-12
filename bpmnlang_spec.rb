require './BPMNLang'

describe BPMNLang::Runner do
  it "should parse a simple task" do
    node = BPMNLang::Runner.parse('task :task1')

    expect(node.class).to eq(BPMNLang::StatementsNode)
    expect(node.statements.size).to eq(1)
    task = node.statements.first
    expect(task.class).to eq(BPMNLang::TaskNode)
    expect(task.name).to eq('task1')
  end

  it "should parse a task with leading and trailing spaces" do
    node = BPMNLang::Runner.parse(<<-EOT)
      task :task1 
    EOT

    expect(node.class).to eq(BPMNLang::StatementsNode)
    expect(node.statements.size).to eq(1)
    task = node.statements.first
    expect(task.class).to eq(BPMNLang::TaskNode)
    expect(task.name).to eq('task1')
  end

  it "should parse two tasks" do
    node = BPMNLang::Runner.parse(<<-EOT)
      task :task1 
      task :task2 
    EOT

    expect(node.class).to eq(BPMNLang::StatementsNode)
    expect(node.statements.size).to eq(2)
    task1, task2 = node.statements
    expect(task1.class).to eq(BPMNLang::TaskNode)
    expect(task1.name).to eq('task1')
    expect(task2.class).to eq(BPMNLang::TaskNode)
    expect(task2.name).to eq('task2')
  end
end
