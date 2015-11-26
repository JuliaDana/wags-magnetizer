module Magnet
  class Magnet
    attr_accessor :contents

    def initialize
      @contents = []
    end

    def import_json

    end

    def import_xml

    end

    def serialize_json

    end

    def serialize_xml

    end
  end

  class MagnetContent

  end

  class MagnetText < MagnetContent
    attr_accessor :text

    def initialize text
      @text = text
    end
  end

  class MagnetDropZone < MagnetContent

  end

  class MagnetChoices < MagnetContent
    attr_accessor :choices

    def initialize
      @choices = []
    end
  end
end
