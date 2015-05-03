module Target
  class Base
    def ==(other)
      other.class == self.class
    end
  end

  class NextInstruction < Base
    def resolved?
      false
    end
  end

  class NextSubInstruction < Base
    def resolved?
      false
    end
  end

  class NextSuperInstruction < Base
    def resolved?
      false
    end
  end

  class PrevSubInstruction < Base
    def resolved?
      false
    end
  end

  class ById
    attr_reader :id
    def initialize(id)
      @id = id
    end

    def resolved?
      true
    end

    def to_s
      "Target:#{@id}"
    end

    def ==(other)
      other.class == self.class && other.id == self.id
    end

    def dup
      self.class.new(self.id)
    end
  end

  class Label
    attr_reader :id, :name
    def initialize(name)
      @name = name
    end

    def id=(id)
      @id = id
    end

    def resolved?
      false
    end

    def to_s
      "Target:#{@name}:#{@id}"
    end

    def ==(other)
      other.class == self.class && other.name == self.name
    end
  end
end
