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

    @blockIntervals = []

    @tokens = tokens
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
    @classMagnets << Magnet.new 
  end

  def exitTypeDeclaration ctx
  end

  def exitClassOrInterfaceModifier ctx
    if ctx.parent.is_a?(Java::JavaParser::TypeDeclarationContext)
      @classMagnets.last.contents += getTextWithWhitespace(ctx)
    elsif ctx.parent.is_a?(Java::JavaParser::MethodDeclarationContext)
      @methodMagnets.last.contents += getTextWithWhitespace(ctx)
    end
  end

  def exitClassDeclaration ctx
    num_children = ctx.getChildCount

    num_children.times do |i|
      c = ctx.getChild(i)
      p = getTextWithWhitespace c

      if c.is_a?(Antlr::TerminalNodeImpl)
        @classMagnets.last.contents += p
      else
        @classMagnets.last.contents <<  MagnetText.new("{ ")
        @classMagnets.last.contents <<  MagnetDropZone.instance
        @classMagnets.last.contents <<  MagnetText.new(" }")
      end
    end
  end

  def enterClassBodyDeclaration ctx
    @methodMagnets << Magnet.new 
  end

  def exitMethodDeclaration ctx
    num_children = ctx.getChildCount

    num_children.times do |i|
      c = ctx.getChild(i)
      p = getTextWithWhitespace c

      if c.is_a?(Java::JavaParser::MethodBodyContext)
        @methodMagnets.last.contents <<  MagnetText.new("{ ")
        @methodMagnets.last.contents <<  MagnetDropZone.instance
        @methodMagnets.last.contents <<  MagnetText.new(" }")
      else
        @methodMagnets.last.contents += p
      end
    end
  end

  def exitClassBodyDeclaration ctx
  end

  def enterBlock ctx
  end

  def exitBlock ctx
    @blockIntervals << ctx.getSourceInterval
  end

  def enterBlockStatement ctx
  end

  def exitBlockStatement ctx
    text = getTextWithWhitespace ctx
    @statementMagnets << Magnet.new()
    @statementMagnets.last.contents += text
  end

  def getTextWithWhitespace ctx
    interval = ctx.getSourceInterval

    blocksInInterval = []

    @blockIntervals.each do |blockInterval|
      if (interval.properlyContains(blockInterval))
        blocksInInterval << blockInterval
      end
    end

    toks = []
    (interval.a .. interval.b).each  do |j|
      tok =  @tokens.get(j)

      startsBlockInterval = false
      inBlockInterval = false

      blocksInInterval.each do |block|
        if (block.a == j)
          startsBlockInterval = true
        end

        if (block.a < j && block.b >=j)
          inBlockInterval = true
        end
      end

      if inBlockInterval
        # do nothing

      elsif startsBlockInterval
        toks << MagnetText.new("{ ")
        toks << MagnetDropZone.instance
        toks << MagnetText.new(" }")
      
      elsif (tok.channel == 0 || tok.channel == 1)
        toks << MagnetText.new(tok.getText)
      end
    end

    toks << MagnetText.new(" ")
    return toks
  end
end
