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
    xml = XmlGenerator.new(Runner.parse("process :p1 do end"))
    expect_xml_match(xml.generate,
      expected_definition_xml do <<-EOT
          <process id="p1" name="process name"/>
        EOT
      end
    )
  end

  it "creates a process with one task in it" do
    xml = XmlGenerator.new(Runner.parse("process :p1 do task :task1 end"))
    expect_xml_match(xml.generate,
      expected_definition_xml do <<-EOT
          <process id="p1" name="process name">
            <startEvent id="start"/>
            <userTask id="task1"/>
            <endEvent id="end1"/>
          </process>
        EOT
      end
    )

  end
end
