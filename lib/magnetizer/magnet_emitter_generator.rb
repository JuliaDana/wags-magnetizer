require_relative "magnet_emitter_base.rb"

class MagnetEmitterGenerator
  def self.generate language = "Java"
    if language == "Java"
      parent_class = eval "Java::#{language.downcase}_parser.#{language}BaseListener"
      unless defined? GeneratedJavaMagnetEmitter
        emitter_class = Class.new(parent_class) do
          include MagnetEmitterBase

          type1 = ["PackageDeclaration", "ImportDeclaration"]

          type1.each do |node|
            define_method "enter#{node}" do |ctx|
              @preambleMagnets << Magnet.new
              text = getTextWithWhitespace(ctx)
              @preambleMagnets.last.contents += text;
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

            define_method "exit#{node}" do |ctx|
              m = @magnetStack.last
              # This get text should exclude text from any intervals covered 
              # by other magnets. There should be drop zones at all excluded intervals.
              m.contents += getTextWithWhitespace ctx, @exclusionIntervalsStack.last
              @magnetStack.pop
              @exclusionIntervalsStack.pop
            end
          end

          type3 = ["ClassBodyDeclaration"]

          type3.each do |node|
            define_method "enter#{node}" do |ctx|
              m = Magnet.new

              if ctxHasChildType(ctx, Java::java_parser.JavaParser::MethodDeclarationContext, 2)
                @methodMagnets << m
              end

              @exclusionIntervalsStack.last << ctx.getSourceInterval
              @magnetStack << m
              @exclusionIntervalsStack << []
            end
          end

          type4 = ["BlockStatement"]

          type4.each do |node|
            define_method "enter#{node}" do |ctx|
              m = Magnet.new
              
              @statementMagnets << m

              @exclusionIntervalsStack.last << ctx.getSourceInterval
              @magnetStack << m
              @exclusionIntervalsStack << []
            end
          end

          type3_and_4 = type3 + type4

          type3_and_4.each do |node|
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
    end

    return ret
  end
end
