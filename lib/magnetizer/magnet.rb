require 'singleton'
require 'json'

require_relative 'magnet/content.rb'
require_relative 'magnet/text.rb'
require_relative 'magnet/drop_zone.rb'
require_relative 'magnet/choices.rb'

module Magnetizer
  class Magnet
    attr_accessor :contents
    
    def initialize *contents
      @contents = contents
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

    def add content
      @contents += magnet.contents
    end

    def coalesce
      new_contents = []

      @contents.each do |content|
        case content
        when Magnet::Text
          if (new_contents.last.is_a?(Magnet::Text))
            new_contents.last.text << content.text
          else
            content.text.lstrip!
            new_contents << content unless content.text == ""
          end
        when Magnet::DropZone
          unless (new_contents.last.is_a?(Magnet::DropZone))
            if new_contents.last.is_a?(Magnet::Text)
              new_contents.last.text.rstrip!
            end
            new_contents << content
          end
        when Magnet::Content
          new_contents << content
        else
          raise "Magnet content array cannot contain type #{content.class}"
        end
      end

      if new_contents.last.is_a? Magnet::Text
        new_contents.last.text.rstrip!
      end

      @contents = new_contents

      return self
    end

    def == other
      return other.is_a?(self.class) && other.contents == self.contents
    end
  end
end
