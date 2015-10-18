class MagnetEmitter < Java::JavaBaseListener

  PANEL_STRING = "<br><!-- panel --><br>"
  MAGNET_SEPARATOR = ".:|:."

  def initialize tokens
    super()
    @classMagnets = []
    @methodMagnets = []
    @statementMagnets = []

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
      p = getTextWithWhitespace @tokens, c

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
      p = getTextWithWhitespace @tokens, c

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

  def exitStatement ctx
    text = getTextWithWhitespace @tokens, ctx

    @statementMagnets << text.strip;
  end

  def getTextWithWhitespace stream, ctx
    interval = ctx.getSourceInterval

    toks = []
    (interval.a .. interval.b).each  do |j|
      toks << stream.get(j).getText
      ws =  stream.getHiddenTokensToRight(j, 1)
      ws.each do |w|
       toks << w.getText 
      end if ws
    end

    toks.join("")
  end
end
