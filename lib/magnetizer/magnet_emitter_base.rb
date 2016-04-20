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
  end

  def createMagnetContent ctx, excludedIntervals = []
    interval = ctx.getSourceInterval
    content = []

    # Assumes excluded intervals are all disjoint and in order
    # TODO: Handle magnets beginning with drop zone
    startIndex = interval.a
    endIndex = excludedIntervals.empty? ? interval.b : (excludedIntervals.first.a - 1)
    content << MagnetText.new(getAllText(startIndex .. endIndex))

    until excludedIntervals.empty?
      content << MagnetDropZone.instance

      exInt = excludedIntervals.shift

      startIndex = exInt.b + 1
      endIndex = excludedIntervals.empty? ? interval.b : (excludedIntervals.first.a - 1)
      content << MagnetText.new(getAllText(startIndex .. endIndex))
    end

    return content

  end

  # TODO: Remove indentation up to the level that the first line is at
  def getAllText intervalRange
    toks = []
    # Go through the interval token by token. It is indexed by token, 
    # not by character
    intervalRange.each  do |j|
      tok =  @tokens.get(j)

      if (tok.channel == 0 || tok.channel == 1)
        toks << tok.getText
      end
    end

    return toks.join
  end
end

