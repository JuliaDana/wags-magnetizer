class Magnet
  attr_accessor :token
  attr_accessor :text

  def initialize token
    @text = ""
    @token = token
  end
end

class MagnetEmitter < Java::JavaBaseListener

  PANEL_STRING = "<br><!-- panel --><br>"
  MAGNET_SEPARATOR = "\n.:|:.\n"

  def initialize tokens
    super()
    @classMagnets = []
    @methodMagnets = []
    @statementMagnets = []

    @blockIntervals = []

    @tokens = tokens
  end

  def classMagnets
    return outputMagnets @classMagnets
  end

  def methodMagnets
    return outputMagnets @methodMagnets

  end

  def statementMagnets
    return @statementMagnets.map {|m|  
        escaped = CGI.escapeHTML(m)
        escapedPanel = Regexp.new(Regexp.quote(CGI.escapeHTML(PANEL_STRING)))
        escaped.gsub(escapedPanel, PANEL_STRING)
      }.join(MAGNET_SEPARATOR)
  end

  def outputMagnets magnetArray
    return magnetArray.map {|ma| ma.map {|m|  m == PANEL_STRING ? m : CGI.escapeHTML(m)}; ma.join(" ")}.join(MAGNET_SEPARATOR)
  end

  def enterTypeDeclaration ctx
    @classMagnets << [] 
  end

  def exitClassOrInterfaceModifier ctx
    if ctx.parent.is_a?(Java::JavaParser::TypeDeclarationContext)
      @classMagnets.last << ctx.getText
    elsif ctx.parent.is_a?(Java::JavaParser::MethodDeclarationContext)
      @methodMagnets.last << ctx.getText
    end
  end

  def exitClassDeclaration ctx
    num_children = ctx.getChildCount

    num_children.times do |i|
      c = ctx.getChild(i)
      p = getTextWithWhitespace c

      if c.is_a?(Antlr::TerminalNodeImpl)
        @classMagnets.last << p
      else
        @classMagnets.last <<  "{ "
        @classMagnets.last <<  PANEL_STRING
        @classMagnets.last <<  " }"
      end
    end
  end

  def exitTypeDeclaration ctx
  end

  def enterClassBodyDeclaration ctx
    @methodMagnets << []
  end

  def exitMethodDeclaration ctx
    num_children = ctx.getChildCount

    num_children.times do |i|
      c = ctx.getChild(i)
      p = getTextWithWhitespace c

      if c.is_a?(Java::JavaParser::MethodBodyContext)
        @methodMagnets.last <<  "{ "
        @methodMagnets.last <<  PANEL_STRING
        @methodMagnets.last <<  " }"
      else
        @methodMagnets.last << p
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
    @statementMagnets << text.strip
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
        toks << "{ #{PANEL_STRING} }"
      
      elsif (tok.channel == 0 || tok.channel == 1)
        toks << tok.getText
      end
    end

    toks.join("")
  end
end
