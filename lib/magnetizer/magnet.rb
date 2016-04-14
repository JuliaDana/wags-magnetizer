require 'singleton'
require 'json'

class Magnet
  attr_accessor :contents
  
  def initialize *contents
    @contents = contents
  end


  def import_xml

  end

  def to_json *a
    {
      "json_class" => self.class.name,
      "data" => {"contents" => @contents}
    }.to_json(*a)
  end

  def self.json_create o
    self.new(*o["data"]["contents"])
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

    if new_contents.last.is_a? MagnetText
      new_contents.last.text.rstrip!
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
  
  def to_json *a
    {
      "json_class" => self.class.name,
      "data" => {"text" => @text}
    }.to_json(*a)
  end

  def self.json_create o
    self.new(o["data"]["text"])
  end
end

class MagnetDropZone < MagnetContent
  include Singleton
  
  def to_json *a
    {
      "json_class" => self.class.name,
      #"data" => {}
    }.to_json(*a)
  end

  def self.json_create o
    self.instance
  end
end

class MagnetChoices < MagnetContent
  attr_accessor :choices

  def initialize *choices
    @choices = choices
  end

  def to_json *a
    {
      "json_class" => self.class.name,
      "data" => {"choices" => @choices}
    }.to_json(*a)
  end

  def self.json_create o
    self.new(*o["data"]["choices"])
  end

  def == other
    return other.is_a?(self.class) && self.choices == other.choices
  end
end
