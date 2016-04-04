require_relative "magnet_emitter_base.rb"

class MagnetEmitterGenerator
  def self.generate language = "Java"
    parent_class = eval "Java::#{language.downcase}_parser.#{language}BaseListener"
    generating_class_name = "Generated#{language}MagnetEmitter"

    languages = ["Java", "Python3"]
    unless languages.include? language
        raise UnsupportedLanguageError, "#{language} not supported by this #{self.name}"
    end

    unless const_defined? generating_class_name
      emitter_class = Class.new(parent_class) do
        include MagnetEmitterBase
      end

      case language
      when "Java"
        emitter_class.class_eval do
          type1 = ["PackageDeclaration", "ImportDeclaration"]

          type2 = ["TypeDeclaration"]

          type3 = ["ClassBodyDeclaration"]

          type4 = ["BlockStatement"]

          type2_and_3_and_4 = type1 + type2 + type3 + type4

          type2_and_3_and_4.each do |node|
            define_method "enter#{node}" do |ctx|
              # TODO: not really needed for simple statements
              if type4.include?(node) || type3.include?(node)
                @exclusionIntervalsStack.last << ctx.getSourceInterval
              end

              @exclusionIntervalsStack << []
            end

            define_method "exit#{node}" do |ctx|
              m = Magnet.new
              # This get text should exclude text from any intervals covered 
              # by other magnets. There should be drop zones at all excluded intervals.
              m.contents += getTextWithWhitespace ctx, @exclusionIntervalsStack.last

              if type2.include? node
                @classMagnets << m
              elsif type3.include? node
                if ctxHasChildType(ctx, Java::java_parser.JavaParser::MethodDeclarationContext, 2)
                  @methodMagnets << m
                else
                  #raise "ClassBodyDeclaration node found that is not a method"
                  @statementMagnets << m
                end
              elsif type1.include? node
                @preambleMagnets << m
              elsif type4.include? node
                @statementMagnets << m
              end
              @exclusionIntervalsStack.pop
            end
          end
        end

      when "Python3"
        emitter_class.class_eval do
          type1 = ["Simple_stmt"]

          type2 = []

          type3 = ["Compound_stmt"]

          type4 = ["Suite"]

          type2_and_3_and_4 = type1 + type2 + type3 + type4

          type2_and_3_and_4.each do |node|
            define_method "enter#{node}" do |ctx|
              # TODO: not really needed for simple statements
              if type4.include? node
                @exclusionIntervalsStack.last << ctx.getSourceInterval
              end

              @exclusionIntervalsStack << []
            end

            define_method "exit#{node}" do |ctx|
              m = Magnet.new
              # This get text should exclude text from any intervals covered 
              # by other magnets. There should be drop zones at all excluded intervals.
              m.contents += getTextWithWhitespace ctx, @exclusionIntervalsStack.last

              if type2.include? node
                @classMagnets << m
              elsif type3.include? node
                if ctxHasChildType(ctx, Java::python3_parser.Python3Parser::ClassdefContext, 1)
                  #@exclusionIntervalsStack.last << ctx.getSourceInterval
                  @classMagnets << m
                elsif ctxHasChildType(ctx, Java::python3_parser.Python3Parser::FuncdefContext, 1)
                  @methodMagnets << m
                else
                  raise "compound statement node found that is not a method"
                  #@exclusionIntervalsStack.last << ctx.getSourceInterval
                  #@statementMagnets << m
                end
              elsif type1.include? node
                @statementMagnets << m
              end
              @exclusionIntervalsStack.pop
            end
          end
        end
      end
      
      Object.const_set generating_class_name, emitter_class

    end
      
    ret = Object.const_get generating_class_name
    return ret
  end
end
