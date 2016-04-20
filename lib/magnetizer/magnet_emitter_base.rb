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
  end

  def allMagnets
    return @preambleMagnets + @classMagnets + @methodMagnets + @statementMagnets
  end

  ###########################################
  # Helpers
  ##########################################
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
        directives << strip_directive(curr_tok)
        puts "DIRECTIVE #{directives.last}"
      end

      i -= 1
      curr_tok = i > 0 ? @tokens.get(i) : nil
    end

    return directives
  end

  def createMagnetContent ctx, excludedIntervals = []
    interval = ctx.getSourceInterval
    content = []
    alt_contents = []

    # Assumes excluded intervals are all disjoint and in order
    # TODO: Handle magnets beginning with drop zone
    startIndex = interval.a
    endIndex = excludedIntervals.empty? ? interval.b : (excludedIntervals.first.a - 1)
    # TODO: fix this ugliness
    t = getAllText(startIndex .. endIndex)
    if t. is_a? Array
      # TODO: I don't think this will handle combinations of alt texts
      t.each do |text|
        alt_contents << Array.new(content)
        alt_contents.last << MagnetText.new(text)
      end

      content << MagnetText.new(t.first)
    else
      content << MagnetText.new(t)
    end
      

    until excludedIntervals.empty?
      content << MagnetDropZone.instance
      alt_contents.each do |a_c|
        a_c << MagnetDropZone.instance
      end

      exInt = excludedIntervals.shift

      startIndex = exInt.b + 1
      endIndex = excludedIntervals.empty? ? interval.b : (excludedIntervals.first.a - 1)
      # TODO: fix this duplication
      t = getAllText(startIndex .. endIndex)
      if t. is_a? Array
        # TODO: I don't think this will handle combinations of alt texts
        t.each do |text|
          if alt_contents.empty?
            alt_contents << Array.new(content)
            alt_contents.last << MagnetText.new(text)
          else
            alt_contents.each do |a_c|
              alt_contents << Array.new(a_c)
              alt_contents.last << MagnetText.new(text)
            end
          end
        end

        content << MagnetText.new(t.first)
      else
        content << MagnetText.new(t)
        alt_contents.each do |a_c|
          a_c << MagnetText.new(t)
        end
      end
    end

    return alt_contents.empty? ? content : alt_contents

  end

  # TODO: Remove indentation up to the level that the first line is at
  def getAllText intervalRange
    text = []
    curr_alt = []
    alt_texts = []
    # Go through the interval token by token. It is indexed by token, 
    # not by character
    intervalRange.each  do |j|
      tok =  @tokens.get(j)

      if (tok.channel == 0 || tok.channel == 1)
        text << tok.getText
        alt_texts.each do |alt_text|
          alt_text << tok.getText
        end

      # Get directives
      # TODO Cannot handle alttext specified before first token in rule
      elsif (tok.channel == 2)
        command, info = strip_directive(tok).split(' ', 2)
        # TODO handle combinations of alt texts
        case command
        when"ALT"
          puts "Found alt text: #{info}"
          # Trigger creation of alternative magnet
          curr_alt = Array.new(text)
          curr_alt << info
        when "ENDALT"
          alt_texts << curr_alt
        end
      end
    end

    if alt_texts.empty?
      return text.join
    else
      ret = [text.join] + alt_texts.map {|t| t.join}
      puts "Returning multiple texts"
      pp ret
      return ret
    end
  end
end

