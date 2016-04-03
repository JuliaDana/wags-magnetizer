require_relative "magnet_emitter_base.rb"

class MagnetEmitterGenerator
  def self.generate language = "Java"
    case language
    when "Java"
      parent_class = eval "Java::#{language.downcase}_parser.#{language}BaseListener"
      unless defined? GeneratedJavaMagnetEmitter
        emitter_class = Class.new(parent_class) do
          include MagnetEmitterBase

          type1 = ["PackageDeclaration", "ImportDeclaration"]

          type1.each do |node|
            define_method "enter#{node}" do |ctx|
              m = Magnet.new
              text = getTextWithWhitespace(ctx)
              m.contents += text;

              @preambleMagnets << m
            end
          end


          type2 = ["TypeDeclaration"]

          type2.each do |node|
            define_method "enter#{node}" do |ctx|
              m = Magnet.new
              @magnetStack << m
              @exclusionIntervalsStack << []

              @classMagnets << m
            end
          end

          type3 = ["ClassBodyDeclaration"]

          type3.each do |node|
            define_method "enter#{node}" do |ctx|
              m = Magnet.new

              @exclusionIntervalsStack.last << ctx.getSourceInterval
              @magnetStack << m
              @exclusionIntervalsStack << []

              if ctxHasChildType(ctx, Java::java_parser.JavaParser::MethodDeclarationContext, 2)
                @methodMagnets << m
              else
                #raise "ClassBodyDeclaration node found that is not a method"
                @statementMagnets << m
              end
            end
          end

          type4 = ["BlockStatement"]

          type4.each do |node|
            define_method "enter#{node}" do |ctx|
              m = Magnet.new

              @exclusionIntervalsStack.last << ctx.getSourceInterval
              @magnetStack << m
              @exclusionIntervalsStack << []

              @statementMagnets << m
            end
          end

          type2_and_3_and_4 = type2 + type3 + type4

          type2_and_3_and_4.each do |node|
            define_method "exit#{node}" do |ctx|
              m = @magnetStack.last
              # This get text should exclude text from any intervals covered 
              # by other magnets. There should be drop zones at all excluded intervals.
              m.contents += getTextWithWhitespace ctx, @exclusionIntervalsStack.last
              @magnetStack.pop
              @exclusionIntervalsStack.pop
            end
          end
        end

        Object.const_set "GeneratedJavaMagnetEmitter", emitter_class
      end

      ret = Object.const_get "GeneratedJavaMagnetEmitter"

    when "Python3"
      parent_class = eval "Java::#{language.downcase}_parser.#{language}BaseListener"
      unless defined? GeneratedPython3MagnetEmitter
        emitter_class = Class.new(parent_class) do
          include MagnetEmitterBase

          type1 = ["Simple_stmt"]

          type1.each do |node|
            define_method "enter#{node}" do |ctx|
              m = Magnet.new
              text = getTextWithWhitespace(ctx)
              m.contents += text;

              @statementMagnets << m
            end
          end


          type2 = []

          type2.each do |node|
            define_method "enter#{node}" do |ctx|
              m = Magnet.new
              @magnetStack << m
              @exclusionIntervalsStack << []

              @classMagnets << m
            end
          end

          type3 = ["Compound_stmt"]

          type3.each do |node|
            define_method "enter#{node}" do |ctx|
              m = Magnet.new

              @magnetStack << m
              @exclusionIntervalsStack << []

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
            end
          end

          type4 = ["Suite"]

          type4.each do |node|
            define_method "enter#{node}" do |ctx|
              m = Magnet.new

              @exclusionIntervalsStack.last << ctx.getSourceInterval
              @magnetStack << m
              @exclusionIntervalsStack << []

              #@statementMagnets << m
            end
          end

          type2_and_3_and_4 = type2 + type3 + type4

          type2_and_3_and_4.each do |node|
            define_method "exit#{node}" do |ctx|
              m = @magnetStack.last
              # This get text should exclude text from any intervals covered 
              # by other magnets. There should be drop zones at all excluded intervals.
              m.contents += getTextWithWhitespace ctx, @exclusionIntervalsStack.last
              @magnetStack.pop
              @exclusionIntervalsStack.pop
            end
          end
        end

        Object.const_set "GeneratedPython3MagnetEmitter", emitter_class
      end

      ret = Object.const_get "GeneratedPython3MagnetEmitter"
    else
      raise UnsupportedLanguageError, "#{language} not supported by this #{self.name}"
    end

    return ret
  end
end
