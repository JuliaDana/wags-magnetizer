$CLASSPATH << "java/bin/"
require 'java'
require "etc/antlr-4.5.1-complete.jar"
require 'cgi'
require 'yaml'

LANGUAGES = YAML.load_file("data/languages.yaml")

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

require_relative "magnetizer/magnet_emitter_generator.rb"
require_relative "magnet_translator.rb"

class UnsupportedLanguageError < StandardError; end;

class Magnetizer

  def initialize file, language = "Java"
    unless LANGUAGES.keys.include? language
      raise UnsupportedLanguageError
    end
    
    lexer_class = eval "Java::#{language.downcase}_parser.#{language}Lexer"
    parser_class = eval "Java::#{language.downcase}_parser.#{language}Parser"

    begin
      input = Antlr::ANTLRInputStream.new(java.io.FileInputStream.new(file))
      lexer = lexer_class.new(input)
      tokens = Antlr::CommonTokenStream.new(lexer)
      @parser = parser_class.new(tokens)
      
      @tree = @parser.send(LANGUAGES[language]["start_rule"])
      walker = Antlr::ParseTreeWalker.new()
      @emitter = MagnetEmitterGenerator.generate(language).new(tokens)
      walker.walk(@emitter, @tree)
    rescue java.io.FileNotFoundException => e
      raise "Unable to load file #{file}"
    end
  end

  def get_magnets
    return @emitter.allMagnets.map {|m| m.coalesce}
  end

  def print_magnets
    trans = MagnetTranslator.new

    puts "Preamble Magnets:"
    puts trans.translate_to_wags_magnets(@emitter.preambleMagnets)

    puts "Class Magnets:"
    puts trans.translate_to_wags_magnets(@emitter.classMagnets)

    puts "Method Magnets:"
    puts trans.translate_to_wags_magnets(@emitter.methodMagnets)


    puts "Statement Magnets:"
    puts trans.translate_to_wags_magnets(@emitter.statementMagnets)
  end

  def print_json
    puts JSON.pretty_generate(self.get_magnets)
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
