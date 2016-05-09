module Magnetizer
  class Magnet
    class Text < Content
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
  end
end
