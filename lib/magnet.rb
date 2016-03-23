require 'singleton'

class Magnet
  attr_accessor :contents
  
  def initialize contents = []
    @contents = contents
  end

  def import_json

  end

  def import_xml

  end

  def serialize_json

  end

  def serialize_xml

  end

  def add magnet
    @contents += magnet.contents
  end

  def coalesce
    new_contents = []

    @contents.each do |content|
      case content
      when MagnetText
        if (new_contents.last.is_a?(MagnetText))
          new_contents.last.text << content.text
        else
          content.text.lstrip!
          new_contents << content unless content.text == ""
        end
      when MagnetDropZone
        unless (new_contents.last.is_a?(MagnetDropZone))
          if new_contents.last.is_a?(MagnetText)
            new_contents.last.text.rstrip!
          end
          new_contents << content
        end
      when MagnetContent
        new_contents << content
      else
        raise "Magnet content array cannot contain type #{content.class}"
      end
    end

    @contents = new_contents

    return self
  end

  def == other
    return other.is_a?(self.class) && other.contents == self.contents
  end
end

class MagnetContent
end

class MagnetText < MagnetContent
  attr_accessor :text

  def initialize text
    @text = text
  end

  def == other
    return other.is_a?(self.class) && self.text == other.text
  end
end

class MagnetDropZone < MagnetContent
  include Singleton
end

class MagnetChoices < MagnetContent
  attr_accessor :choices

  def initialize
    @choices = []
  end

  def == other
    return other.is_a?(self.class) && self.choices == other.choices
  end
end
