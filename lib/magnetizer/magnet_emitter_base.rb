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

    @magnetStack = []
    @exclusionIntervalsStack = []

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

  # TODO: Remove indentation up to the level that the first line is at
  def getTextWithWhitespace ctx, excludedIntervals = []
    interval = ctx.getSourceInterval

    toks = []
    (interval.a .. interval.b).each  do |j|
      tok =  @tokens.get(j)

      startingExcludedInterval = false
      inExcludedInterval = false

      excludedIntervals.each do |excludedInterval|
        if (excludedInterval.a == j)
          startingExcludedInterval = true
        end

        if (excludedInterval.a < j && excludedInterval.b >=j)
          inExcludedInterval = true
        end
      end

      if inExcludedInterval
        # do nothing

      elsif startingExcludedInterval
        toks << MagnetDropZone.instance
      
      elsif (tok.channel == 0 || tok.channel == 1)
        toks << MagnetText.new(tok.getText)
      end
    end

    return toks
  end
end

