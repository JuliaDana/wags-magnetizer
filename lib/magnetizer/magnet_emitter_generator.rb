require_relative "magnet_emitter_base.rb"

class MagnetEmitterGenerator
  def self.generate language = "Java"
    if language == "Java"
      parent_class = eval "Java::#{language.downcase}_parser.#{language}BaseListener"
      unless defined? GeneratedJavaMagnetEmitter
        emitter_class = Class.new(parent_class) do
          include MagnetEmitterBase

          #------------------------------------
          # Visitor Methods
          #------------------------------------

          def enterPackageDeclaration ctx
            @preambleMagnets << Magnet.new
            text = getTextWithWhitespace(ctx)
            @preambleMagnets.last.contents += text;
          end

          def enterImportDeclaration ctx
            @preambleMagnets << Magnet.new
            text = getTextWithWhitespace(ctx)
            @preambleMagnets.last.contents += text;
          end

          def enterTypeDeclaration ctx
            m = Magnet.new
            @magnetStack << m
            @exclusionIntervalsStack << []
            @classMagnets << m
          end

          def exitTypeDeclaration ctx
            m = @magnetStack.last
            # This get text should exclude text from any intervals covered 
            # by other magnets. There should be drop zones at all excluded intervals.
            m.contents += getTextWithWhitespace ctx, @exclusionIntervalsStack.last
            @magnetStack.pop
            @exclusionIntervalsStack.pop
          end

          def enterClassBodyDeclaration ctx
            m = Magnet.new

            if ctxHasChildType(ctx, Java::java_parser.JavaParser::MethodDeclarationContext, 2)
              @methodMagnets << m
            end

            @exclusionIntervalsStack.last << ctx.getSourceInterval
            @magnetStack << m
            @exclusionIntervalsStack << []
          end

          def exitClassBodyDeclaration ctx
            m = @magnetStack.last
            # This get text should exclude text from any intervals covered 
            # by other magnets. There should be drop zones at all excluded intervals.
            m.contents += getTextWithWhitespace ctx, @exclusionIntervalsStack.last
            @magnetStack.pop
            @exclusionIntervalsStack.pop
          end

          def enterBlockStatement ctx
            m = Magnet.new
            
            @statementMagnets << m

            @exclusionIntervalsStack.last << ctx.getSourceInterval
            @magnetStack << m
            @exclusionIntervalsStack << []
          end

          def exitBlockStatement ctx
            m = @magnetStack.last
            # This get text should exclude text from any intervals covered 
            # by other magnets. There should be drop zones at all excluded intervals.
            m.contents += getTextWithWhitespace ctx, @exclusionIntervalsStack.last
            @magnetStack.pop
            @exclusionIntervalsStack.pop
          end
        end

        Object.const_set "GeneratedJavaMagnetEmitter", emitter_class
      end

      ret = Object.const_get "GeneratedJavaMagnetEmitter"
    end

    return ret
  end
end
