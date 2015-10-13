class MagnetEmitter < Java::JavaBaseListener
  def enterClassDeclaration ctx
    puts "Class Magnets"
    puts ctx.getText
  end

  def enterBlock ctx
    puts "<br><!-- panel --><br>"
    ctx.getText
  end

  def enterMethodDeclaration ctx
    puts "Method Magnets"
    puts ctx.getText
  end

  def enterStatement ctx
    puts "Statement: " + ctx.getText
  end
end
