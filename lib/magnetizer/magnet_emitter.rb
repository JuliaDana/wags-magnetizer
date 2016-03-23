require_relative "../magnet.rb"

class MagnetEmitter < Java::JavaBaseListener
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

  #------------------------------------
  # Visitor Methods
  #------------------------------------

  def enterPackageDeclaration ctx
    @preambleMagnets << Magnet.new
    text = getTextWithWhitespace(ctx)
    @preambleMagnets.last.contents += text;
  end

  def enterImportDeclaration ctx
    @preambleMagnets << Magnet.new
    text = getTextWithWhitespace(ctx)
    @preambleMagnets.last.contents += text;
  end

  def enterTypeDeclaration ctx
    m = Magnet.new
    @magnetStack << m
    @exclusionIntervalsStack << []
    @classMagnets << m
  end

  def exitTypeDeclaration ctx
    m = @magnetStack.last
    # This get text should exclude text from any intervals covered 
    # by other magnets. There should be drop zones at all excluded intervals.
    m.contents += getTextWithWhitespace ctx, @exclusionIntervalsStack.last
    @magnetStack.pop
    @exclusionIntervalsStack.pop
  end

  def enterClassBodyDeclaration ctx
    m = Magnet.new

    if ctxHasChildType(ctx, Java::JavaParser::MethodDeclarationContext, 2)
      @methodMagnets << m
    end

    @exclusionIntervalsStack.last << ctx.getSourceInterval
    @magnetStack << m
    @exclusionIntervalsStack << []
  end

  def exitClassBodyDeclaration ctx
    m = @magnetStack.last
    # This get text should exclude text from any intervals covered 
    # by other magnets. There should be drop zones at all excluded intervals.
    m.contents += getTextWithWhitespace ctx, @exclusionIntervalsStack.last
    @magnetStack.pop
    @exclusionIntervalsStack.pop
  end

  def enterBlockStatement ctx
    m = Magnet.new
    
    @statementMagnets << m

    @exclusionIntervalsStack.last << ctx.getSourceInterval
    @magnetStack << m
    @exclusionIntervalsStack << []
  end

  def exitBlockStatement ctx
    m = @magnetStack.last
    # This get text should exclude text from any intervals covered 
    # by other magnets. There should be drop zones at all excluded intervals.
    m.contents += getTextWithWhitespace ctx, @exclusionIntervalsStack.last
    @magnetStack.pop
    @exclusionIntervalsStack.pop
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
