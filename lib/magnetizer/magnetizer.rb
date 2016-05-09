module Magnetizer
  class Magnetizer
    attr_reader :emitter

    def initialize file, language = "Java"
      unless LOADED_LANGUAGES.keys.include? language
        raise UnsupportedLanguageError
      end
      
      lexer_class = eval "Java::#{language.downcase}_parser.#{language}Lexer"
      parser_class = eval "Java::#{language.downcase}_parser.#{language}Parser"

      begin
        input = Antlr::ANTLRInputStream.new(java.io.FileInputStream.new(file))
        lexer = lexer_class.new(input)
        tokens = Antlr::CommonTokenStream.new(lexer)
        @parser = parser_class.new(tokens)
        
        @tree = @parser.send(LOADED_LANGUAGES[language].start_rule)
        
        # Using the listener method
        # walker = Antlr::ParseTreeWalker.new()
        # @emitter = MagnetEmitterGenerator.generate(language).new(tokens)
        # walker.walk(@emitter, @tree)

        # Using the visitor method
        @emitter = MagnetEmitterVisitorGenerator.generate(language).new(tokens)
        @emitter.visit(@tree)
        
      rescue java.io.FileNotFoundException => e
        raise "Unable to load file #{file}"
      end
    end

    def get_magnets
      return @emitter.allMagnets.map {|m| m.coalesce}
    end

    def print_magnets print_to = $stdout
      trans = WagsMagnetTranslator.new

      print_to.puts "Preamble Magnets:"
      print_to.puts trans.translate_to_wags_magnets(@emitter.preambleMagnets)

      print_to.puts "Class Magnets:"
      print_to.puts trans.translate_to_wags_magnets(@emitter.classMagnets)

      print_to.puts "Method Magnets:"
      print_to.puts trans.translate_to_wags_magnets(@emitter.methodMagnets)


      print_to.puts "Statement Magnets:"
      print_to.puts trans.translate_to_wags_magnets(@emitter.statementMagnets)
    end

    def print_yaml print_to=$stdout
      print_to.puts YAML.dump(self.get_magnets)
    end

    def print_json print_to = $stdout
      print_to.puts JSON.pretty_generate(self.get_magnets)
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
end
