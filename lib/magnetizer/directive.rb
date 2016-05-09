module Magnetizer
  class Directive
    attr_accessor :command
    attr_accessor :arg

    def initialize command, arg = ""
      @command = command
      @arg = arg
    end

    def to_s
      "#{@command} #{@arg}"
    end
  end
end
