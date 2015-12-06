require 'java'
require "etc/antlr-4.5.1-complete.jar"
require 'cgi'


# Importing entire packages to Antlr namespace
module Antlr
  include_package "org.antlr.v4.runtime"
  include_package "org.antlr.v4.runtime.tree"
  include_package "org.antlr.v4.gui"
end

# Importing entire packages to Swing namespace
module Swing
  include_package "javax.swing"
end

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

require_relative "magnetizer/magnet_emitter.rb"
require_relative "magnet_translator.rb"

class Magnetizer

  def initialize file
    begin
      input = Antlr::ANTLRInputStream.new(java.io.FileInputStream.new(file))
      lexer = Java::JavaLexer.new(input)
      @tokens = Antlr::CommonTokenStream.new(lexer)
      @parser = Java::JavaParser.new(@tokens)
      
      @tree = @parser.compilationUnit
    rescue java.io.FileNotFoundException => e
      raise "Unable to load file #{file}"
    end
  end

  def print_magnets
    walker = Antlr::ParseTreeWalker.new()
    emitter = MagnetEmitter.new @tokens
    walker.walk(emitter, @tree)
    trans = MagnetTranslator.new

    puts "Preamble Magnets:"
    puts trans.translate_to_wags_magnets(emitter.preambleMagnets)

    puts "Class Magnets:"
    puts trans.translate_to_wags_magnets(emitter.classMagnets)

    puts "Method Magnets:"
    puts trans.translate_to_wags_magnets(emitter.methodMagnets)


    puts "Statement Magnets:"
    puts trans.translate_to_wags_magnets(emitter.statementMagnets)
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
