require_relative "./magnet.rb"

module Magnetizer
  module MagnetEmitterBase
    attr_reader :preambleMagnets
    attr_reader :classMagnets
    attr_reader :methodMagnets
    attr_reader :statementMagnets

    def initialize tokens
      super()
      @preambleMagnets = []
      @classMagnets = []
      @methodMagnets = []
      @statementMagnets = []

      #@magnetStack = []
      @exclusionIntervalsStack = []

      if self.class.allow_file_statements
        @exclusionIntervalsStack << []
      end

      @tokens = tokens

      self.create_extra_magnets
    end

    def allMagnets
      return @preambleMagnets + @classMagnets + @methodMagnets + @statementMagnets
    end

    ###########################################
    # Helpers
    ##########################################

    # Check the directive channel for any commands to create extra magnets.
    def create_extra_magnets
      num_tokens = @tokens.size
      prev_i = -1
      i = @tokens.nextTokenOnChannel(0, 2)
      while i < num_tokens - 1 && prev_i != i do
        t = @tokens.get(i)
        d = strip_directive t
        if d.command == "EXTRAMAG"
          m = Magnet.new
          m.contents << Magnet::Text.new(d.arg)
          @statementMagnets << m
        end

        prev_i = i
        i = @tokens.nextTokenOnChannel(prev_i + 1, 2)
      end
    end

    # Get all directives that affect this context. This is defined as any
    # directives (things on channel 2) since the last thing on the parser
    # channel (channel 0)
    def get_directives ctx
      directives = []
      this_starting_tok = ctx.getSourceInterval.a

      i = this_starting_tok - 1
      curr_tok = i > 0 ? @tokens.get(i) : nil
      while curr_tok && curr_tok.channel != 0
        if curr_tok.channel == 2
          directives << curr_tok
        end

        i -= 1
        curr_tok = i > 0 ? @tokens.get(i) : nil
      end

      return directives
    end

    def ctxHasChildType ctx, type, depth = 1
      if depth == 0
        return false
      end
      
      num_children = ctx.getChildCount

      num_children.times do |i|
        child = ctx.getChild(i)

        if child.is_a?(type)
          return true
        elsif ctxHasChildType(child, type, depth - 1)
          return true
        end
      end
      
      return false
    end

    def createMagnetContent interval, excludedIntervals = []
      contents = [[]]

      # Assumes excluded intervals are all disjoint and in order
      # TODO: Handle magnets beginning with drop zone
      startIndex = interval.a
      endIndex = excludedIntervals.empty? ? interval.b : (excludedIntervals.first.a - 1)

      texts = getAllTexts(startIndex .. endIndex)
      additional_contents = []
      texts.each_with_index do |text, i| 
        contents.each do |content|
          # Duplicate the content unless this is the last text, which
          # can update the original
          unless i == texts.size - 1
            content = Array.new(content)
            additional_contents << content
          end

          content << Magnet::Text.new(text)
        end
      end

      contents += additional_contents
        

      until excludedIntervals.empty?
        contents.each do |c|
          c << Magnet::DropZone.instance
        end

        exInt = excludedIntervals.shift

        startIndex = exInt.b + 1
        endIndex = excludedIntervals.empty? ? interval.b : (excludedIntervals.first.a - 1)

        # TODO: fix this duplication
        texts = getAllTexts(startIndex .. endIndex)
        additional_contents = []
        texts.each_with_index do |text, i| 
          contents.each do |content|
            # Duplicate the content unless this is the last text, which
            # can update the original
            unless i == texts.size - 1
              content = Array.new(content)
              additional_contents << content
            end

            content << Magnet::Text.new(text)
          end
        end
      end

      return contents
    end

    # Gets the text and whitespace for a given interval range
    # Returns an array. The first element in the array is the 
    # text in the code, the others come from any ALT directives
    # given. ALT directives 
    # TODO: Remove indentation up to the level that the first line is at
    def getAllTexts intervalRange
      texts = [[]]
      curr_alts = []
      # Go through the interval token by token. It is indexed by token, 
      # not by character
      intervalRange.each  do |j|
        tok =  @tokens.get(j)

        # If the text is parsed code or whitespace
        if (tok.channel == 0 || tok.channel == 1)
          texts.each do |text|
            text << tok.getText
          end

        # Get directives
        elsif (tok.channel == 2)
          d = strip_directive(tok)
          # TODO make sure combinations of alts are handled
          case d.command
          when"ALT"
            # Trigger creation of alternative magnet
            curr_alts << []
            texts.each do |text|
              curr_alt = Array.new(text)
              curr_alt << d.arg
              curr_alts.last << curr_alt
            end
          when "ENDALT"
            texts << curr_alts.pop
          end
        end
      end

      ret = texts.map {|t| t.join}
      # puts "Ret"
      # pp ret
      return ret
    end
  end
end
