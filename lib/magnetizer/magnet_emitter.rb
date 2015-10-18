class MagnetEmitter < Java::JavaBaseListener

  PANEL_STRING = "<br><!-- panel --><br>"
  MAGNET_SEPARATOR = ".:|:."

  def initialize tokens
    super()
    @classMagnets = []
    @methodMagnets = []
    @statementMagnets = []

    @statementLevel = 0

    @tokens = tokens
  end

  def classMagnets
    return outputMagnets @classMagnets
  end

  def methodMagnets
    return outputMagnets @methodMagnets

  end

  def statementMagnets
    return @statementMagnets.map {|m|  m == PANEL_STRING ? m : CGI.escapeHTML(m)}.join(MAGNET_SEPARATOR)
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

  def enterBlockStatement ctx

    @statementLevel += 1
  end

  def exitBlockStatement ctx
    @statementLevel -= 1

    puts ctx.getText

    if (@statementLevel == 0)
      text = getTextWithWhitespace ctx
      @statementMagnets << text.strip
    end
  end

  def getTextWithWhitespace ctx
    interval = ctx.getSourceInterval

    toks = []
    (interval.a .. interval.b).each  do |j|
      tok =  @tokens.get(j)
      toks << tok.getText if (tok.channel == 0 || tok.channel == 1)
    end

    toks.join("")
  end
end
