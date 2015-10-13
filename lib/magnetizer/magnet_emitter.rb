class MagnetEmitter < Java::JavaBaseListener
  attr_accessor :stream

  PANEL_STRING = "<br><!-- panel --><br>"
  MAGNET_SEPARATOR = ".:|:."

  def initialize
    super
    @classMagnets = []
    @methodMagnets = []
    @statementMagnets = []
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
      p = c.getPayload

      if c.is_a?(Antlr::TerminalNodeImpl)
        @classMagnets.last << c.getText
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
      p = c.getPayload

      if c.is_a?(Java::JavaParser::MethodBodyContext)
        @methodMagnets.last <<  "{ "
        @methodMagnets.last <<  PANEL_STRING
        @methodMagnets.last <<  " }"
      else
        @methodMagnets.last << c.getText
      end
    end
  end

  def exitClassBodyDeclaration ctx
  end

  def exitStatement ctx
    interval = ctx.getSourceInterval
    stmtToks = []
    
    interval.length.times do |i|
      j = i + interval.a
      stmtToks << @stream.get(j).getText
    end

    @statementMagnets << stmtToks.join(" ");
  end
end
