require 'java'
require "etc/antlr-4.5.1-complete.jar"
require 'cgi'


# Importing entire packages
module Antlr
  include_package "org.antlr.v4.runtime"
  include_package "org.antlr.v4.runtime.tree"
  include_package "org.antlr.v4.gui"
end

module Swing
  include_package "javax.swing"
end

require_relative "magnetizer/magnet_emitter.rb"

## Uncomment the following code to put all the Antlr classes in the main
## namespace
# class Object
#   class << self
#     alias :const_missing_old :const_missing
#     def const_missing c
#       Antlr.const_get c
#     end
#   end
# end
# include Antlr


# Importing the needed classes individually
# java_import org.antlr.v4.runtime.ANTLRInputStream
# java_import org.antlr.v4.runtime.CommonTokenStream

class Magnetizer
  def initialize file
    input = Antlr::ANTLRInputStream.new(java.io.FileInputStream.new(file))
    lexer = Java::JavaLexer.new(input)
    @tokens = Antlr::CommonTokenStream.new(lexer)
    @parser = Java::JavaParser.new(@tokens)
    
    @tree = @parser.compilationUnit
  end

  def print_magnets
    walker = Antlr::ParseTreeWalker.new()
    emitter = MagnetEmitter.new @tokens
    walker.walk(emitter, @tree)

    puts "Class Magnets:"
    puts emitter.classMagnets

    puts "Method Magnets:"
    puts emitter.methodMagnets


    puts "Statement Magnets:"
    puts emitter.statementMagnets
  end

  def print_tree
    java.lang.System.out.println(@tree.toStringTree(@parser))
  end

  def show_gui_tree
    frame = Swing::JFrame.new("Antlr AST")
    panel = Swing::JPanel.new
    scrollPane = Swing::JScrollPane.new panel
    viewr = Antlr::TreeViewer.new(java.util.Arrays.asList(@parser.getRuleNames()), @tree)

    #viewr.setScale(2)
    panel.add(viewr)
    frame.add(scrollPane)
    frame.setDefaultCloseOperation(Swing::JFrame::EXIT_ON_CLOSE)
    frame.pack
    frame.setVisible(true)

  end

end
