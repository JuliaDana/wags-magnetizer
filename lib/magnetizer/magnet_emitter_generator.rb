require_relative "magnet_emitter_base.rb"

class MagnetEmitterGenerator
  def self.generate language = "Java"
    parent_class = eval "Java::#{language.downcase}_parser.#{language}BaseListener"
    parser_class = eval  "Java::#{language.downcase}_parser.#{language}Parser"
    generating_class_name = "Generated#{language}MagnetEmitter"

    unless LANGUAGES.keys.include? language
        raise UnsupportedLanguageError, "#{language} not supported by this #{self.name}"
    end

    unless const_defined? generating_class_name
      emitter_class = Class.new(parent_class) do
        include MagnetEmitterBase
      end

      case language
      when "Java"
        language_info = LANGUAGES["Java"]
        emitter_class.class_eval do
          all_types = language_info["preamble_type"] +
            language_info["class_type"] +
            language_info["in_block_type"]

          all_types.each do |node|
            define_method "enter#{node}" do |ctx|
              # TODO: not really needed for simple statements
              if language_info["in_block_type"].include? node
                @exclusionIntervalsStack.last << ctx.getSourceInterval
              end

              @exclusionIntervalsStack << []
            end

            define_method "exit#{node}" do |ctx|
              m = Magnet.new
              # This get text should exclude text from any intervals covered 
              # by other magnets. There should be drop zones at all excluded intervals.
              m.contents += getTextWithWhitespace ctx, @exclusionIntervalsStack.last

              used_override = false
              if (o = language_info["overrides"]) && !o.empty?
                o.each do |override|
                  if override["name"] == node
                    if ctxHasChildType(ctx,
                        eval("#{parser_class}::#{override["child_node_type"]}Context"),
                        override["child_level"])
                      instance_variable_get("@#{override["location"]}Magnets") << m
                      used_override = true
                    end
                  end
                end
              end
              if used_override
                # Do nothing
              elsif language_info["class_type"].include? node
                @classMagnets << m
              elsif language_info["preamble_type"].include? node
                @preambleMagnets << m
              elsif language_info["in_block_type"].include? node
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
                if ctxHasChildType(ctx, 
                    Java::python3_parser.Python3Parser::ClassdefContext, 1)
                  #@exclusionIntervalsStack.last << ctx.getSourceInterval
                  @classMagnets << m
                elsif ctxHasChildType(ctx, 
                    Java::python3_parser.Python3Parser::FuncdefContext, 1)
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
