require './BPMNLang'

include BPMNLang

describe XmlGenerator do
  def expect_xml_match(generated_xml, expected_xml)
    expect(cleaned_xml(generated_xml)).to eq(cleaned_xml(expected_xml))
  end

  def cleaned_xml(xml)
    xml.split("\n").map do |line|
      m = /^\s*(.*)$/.match(line)
      if m
        m[1]
      else
        line
      end
    end.reject{|line| line.strip.empty?}.join("\n")
  end

  def expected_definition_xml
    <<-EOT
      <?xml version="1.0" encoding="UTF-8"?>
      <definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:activiti="http://activiti.org/bpmn" id="definitions" targetNamespace="http://activiti.org/bpmn20">
      #{yield}
      </definitions>
    EOT
  end


  it "creates an empty process" do
    xml = XmlGenerator.new(Runner.parse("process :p1 do end").ast)
    expect_xml_match(xml.generate,
      expected_definition_xml do <<-EOT
          <process id="p1" name="process name"/>
        EOT
      end
    )
  end

  it "creates a process with one task in it" do
    xml = XmlGenerator.new(Runner.parse("process :p1 do task :task1 end").ast)
    expect_xml_match(xml.generate,
      expected_definition_xml do <<-EOT
          <process id="p1" name="process name">
            <startEvent id="start"/>
            <sequenceFlow id="flow1" sourceRef="start" targetRef="task1"/>
            <userTask id="task1"/>
            <sequenceFlow id="flow2" sourceRef="task1" targetRef="end1"/>
            <endEvent id="end1"/>
          </process>
        EOT
      end
    )
  end

  it "creates a process with an if statement and one task in it" do
    xml = XmlGenerator.new(Runner.parse(<<-EOT).ast)
      process :p1 do 
        if 1 == 2 do
          task :task1 
        end
      end
    EOT

    expect_xml_match(xml.generate,
      expected_definition_xml do <<-EOT
          <process id="p1" name="process name">
            <startEvent id="start"/>
            <sequenceFlow id="flow1" sourceRef="start" targetRef="gateway1"/>
            <exclusiveGateway id="gateway1"/>
            <sequenceFlow id="flow2" sourceRef="gateway1" targetRef="task1">
              <conditionalExpression xsi:type="tFormalExpression">${1 == 2}</conditionalExpression>
            </sequenceFlow>
            <userTask id="task1"/>
            <sequenceFlow id="flow3" sourceRef="task1" targetRef="end1"/>
            <sequenceFlow id="flow4" sourceRef="gateway1" targetRef="end1">
              <conditionalExpression xsi:type="tFormalExpression">${!(1 == 2)}</conditionalExpression>
            </sequenceFlow>
            <endEvent id="end1"/>
          </process>
        EOT
      end
    )
  end

  it "creates a process with an if statement and one task in it" do
    xml = XmlGenerator.new(Runner.parse(<<-EOT).ast)
      process :p1 do 
        if 1 == 2 do
          if 3 == 4 do
            task :task1 
          end
        end
      end
    EOT

    expect_xml_match(xml.generate,
      expected_definition_xml do <<-EOT
          <process id="p1" name="process name">
            <startEvent id="start"/>
            <sequenceFlow id="flow1" sourceRef="start" targetRef="gateway1"/>
            <exclusiveGateway id="gateway1"/>
            <sequenceFlow id="flow2" sourceRef="gateway1" targetRef="gateway2">
              <conditionalExpression xsi:type="tFormalExpression">${1 == 2}</conditionalExpression>
            </sequenceFlow>
            <exclusiveGateway id="gateway2"/>
            <sequenceFlow id="flow3" sourceRef="gateway2" targetRef="task1">
              <conditionalExpression xsi:type="tFormalExpression">${3 == 4}</conditionalExpression>
            </sequenceFlow>
            <userTask id="task1"/>
            <sequenceFlow id="flow4" sourceRef="task1" targetRef="end1"/>
            <sequenceFlow id="flow5" sourceRef="gateway2" targetRef="end1">
              <conditionalExpression xsi:type="tFormalExpression">${!(3 == 4)}</conditionalExpression>
            </sequenceFlow>
            <sequenceFlow id="flow6" sourceRef="gateway1" targetRef="end1">
              <conditionalExpression xsi:type="tFormalExpression">${!(1 == 2)}</conditionalExpression>
            </sequenceFlow>
            <endEvent id="end1"/>
          </process>
        EOT
      end
    )
  end

  it "creates a process with an if statement with one task in it and an else statement with one task in it" do
    xml = XmlGenerator.new(Runner.parse(<<-EOT).ast)
      process :p1 do 
        if 1 == 2 do
          task :task1 
        else do
          task :task2 
        end
      end
    EOT

    expect_xml_match(xml.generate,
      expected_definition_xml do <<-EOT
          <process id="p1" name="process name">
            <startEvent id="start"/>
            <sequenceFlow id="flow1" sourceRef="start" targetRef="gateway1"/>
            <exclusiveGateway id="gateway1"/>
            <sequenceFlow id="flow2" sourceRef="gateway1" targetRef="task1">
              <conditionalExpression xsi:type="tFormalExpression">${1 == 2}</conditionalExpression>
            </sequenceFlow>
            <userTask id="task1"/>
            <sequenceFlow id="flow3" sourceRef="gateway1" targetRef="task2">
              <conditionalExpression xsi:type="tFormalExpression">${!(1 == 2)}</conditionalExpression>
            </sequenceFlow>
            <userTask id="task2"/>
            <sequenceFlow id="flow4" sourceRef="task1" targetRef="end1"/>
            <sequenceFlow id="flow5" sourceRef="task2" targetRef="end1"/>
            <endEvent id="end1"/>
          </process>
        EOT
      end
    )
  end

  it "creates a process with a while statement with one task in it" do
    xml = XmlGenerator.new(Runner.parse(<<-EOT).ast)
      process :p1 do 
        while 1 == 2 do
          task :task1 
        end
      end
    EOT

    expect_xml_match(xml.generate,
      expected_definition_xml do <<-EOT
          <process id="p1" name="process name">
            <startEvent id="start"/>
            <sequenceFlow id="flow1" sourceRef="start" targetRef="gateway1"/>
            <exclusiveGateway id="gateway1"/>
            <sequenceFlow id="flow2" sourceRef="gateway1" targetRef="task1">
              <conditionalExpression xsi:type="tFormalExpression">${1 == 2}</conditionalExpression>
            </sequenceFlow>
            <userTask id="task1"/>
            <sequenceFlow id="flow3" sourceRef="task1" targetRef="gateway1"/>
            <sequenceFlow id="flow4" sourceRef="gateway1" targetRef="end1">
              <conditionalExpression xsi:type="tFormalExpression">${!(1 == 2)}</conditionalExpression>
            </sequenceFlow>
            <endEvent id="end1"/>
          </process>
        EOT
      end
    )
  end

  it "creates a process with a while statement with two tasks in it" do
    xml = XmlGenerator.new(Runner.parse(<<-EOT).ast)
      process :p1 do 
        while 1 == 2 do
          task :task1 
          task :task2 
        end
      end
    EOT

    expect_xml_match(xml.generate,
      expected_definition_xml do <<-EOT
          <process id="p1" name="process name">
            <startEvent id="start"/>
            <sequenceFlow id="flow1" sourceRef="start" targetRef="gateway1"/>
            <exclusiveGateway id="gateway1"/>
            <sequenceFlow id="flow2" sourceRef="gateway1" targetRef="task1">
              <conditionalExpression xsi:type="tFormalExpression">${1 == 2}</conditionalExpression>
            </sequenceFlow>
            <userTask id="task1"/>
            <sequenceFlow id="flow3" sourceRef="task1" targetRef="task2"/>
            <userTask id="task2"/>
            <sequenceFlow id="flow4" sourceRef="task2" targetRef="gateway1"/>
            <sequenceFlow id="flow5" sourceRef="gateway1" targetRef="end1">
              <conditionalExpression xsi:type="tFormalExpression">${!(1 == 2)}</conditionalExpression>
            </sequenceFlow>
            <endEvent id="end1"/>
          </process>
        EOT
      end
    )
  end

  it "creates a process with nested while statements" do
    xml = XmlGenerator.new(Runner.parse(<<-EOT).ast)
      process :p1 do 
        while 1 == 2 do
          task :task1 
          task :task2 
          while 3 == 4 do
            task :task3
          end
        end
      end
    EOT

    expect_xml_match(xml.generate,
      expected_definition_xml do <<-EOT
          <process id="p1" name="process name">
            <startEvent id="start"/>
            <sequenceFlow id="flow1" sourceRef="start" targetRef="gateway1"/>
            <exclusiveGateway id="gateway1"/>
            <sequenceFlow id="flow2" sourceRef="gateway1" targetRef="task1">
              <conditionalExpression xsi:type="tFormalExpression">${1 == 2}</conditionalExpression>
            </sequenceFlow>
            <userTask id="task1"/>
            <sequenceFlow id="flow3" sourceRef="task1" targetRef="task2"/>
            <userTask id="task2"/>
            <sequenceFlow id="flow4" sourceRef="task2" targetRef="gateway2"/>
            <exclusiveGateway id="gateway2"/>
            <sequenceFlow id="flow5" sourceRef="gateway2" targetRef="task3">
              <conditionalExpression xsi:type="tFormalExpression">${3 == 4}</conditionalExpression>
            </sequenceFlow>
            <userTask id="task3"/>
            <sequenceFlow id="flow6" sourceRef="task3" targetRef="gateway2"/>
            <sequenceFlow id="flow7" sourceRef="gateway2" targetRef="gateway1">
              <conditionalExpression xsi:type="tFormalExpression">${!(3 == 4)}</conditionalExpression>
            </sequenceFlow>
            <sequenceFlow id="flow8" sourceRef="gateway1" targetRef="end1">
              <conditionalExpression xsi:type="tFormalExpression">${!(1 == 2)}</conditionalExpression>
            </sequenceFlow>
            <endEvent id="end1"/>
          </process>
        EOT
      end
    )
  end

  it "creates a process with while statements that have optional statements" do
    xml = XmlGenerator.new(Runner.parse(<<-EOT).ast)
      process :p1 do 
        while {task :task1 } 1 == 2 do
          task :task2 
        end
      end
    EOT

    expect_xml_match(xml.generate,
      expected_definition_xml do <<-EOT
          <process id="p1" name="process name">
            <startEvent id="start"/>
            <sequenceFlow id="flow1" sourceRef="start" targetRef="task1"/>
            <userTask id="task1"/>
            <sequenceFlow id="flow2" sourceRef="task1" targetRef="gateway1"/>
            <exclusiveGateway id="gateway1"/>
            <sequenceFlow id="flow3" sourceRef="gateway1" targetRef="task2">
              <conditionalExpression xsi:type="tFormalExpression">${1 == 2}</conditionalExpression>
            </sequenceFlow>
            <userTask id="task2"/>
            <sequenceFlow id="flow4" sourceRef="task2" targetRef="task1"/>
            <sequenceFlow id="flow5" sourceRef="gateway1" targetRef="end1">
              <conditionalExpression xsi:type="tFormalExpression">${!(1 == 2)}</conditionalExpression>
            </sequenceFlow>
            <endEvent id="end1"/>
          </process>
        EOT
      end
    )
  end
end
