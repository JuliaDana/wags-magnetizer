require_relative "magnet_emitter_base.rb"

class MagnetEmitterGenerator
  def self.generate language = "Java"
    unless LOADED_LANGUAGES.keys.include? language
        raise UnsupportedLanguageError, "#{language} not supported by this #{self.name}"
    end

    parent_class = eval "Java::#{language.downcase}_parser.#{language}BaseListener"
    parser_class = eval  "Java::#{language.downcase}_parser.#{language}Parser"
    generating_class_name = "Generated#{language}MagnetEmitter"


    unless const_defined? generating_class_name
      
      emitter_class = Class.new(parent_class) do
        # TODO: Check for effeciency from using this in closures
        language_info = LOADED_LANGUAGES[language]

        self.class.class_eval do
          define_method("allow_file_statements") do
            language_info.allow_file_statements
          end
        end

        include MagnetEmitterBase

        all_types = language_info.magnet_nodes

        all_types.each do |node|
          # TODO create more specific method bodies
          define_method "enter#{node.name}" do |ctx|
            if node.list == "in_block_type"
              @exclusionIntervalsStack.last << ctx.getSourceInterval
            end

            @exclusionIntervalsStack << []
          end

          # TODO create more specific method bodies
          define_method "exit#{node.name}" do |ctx|
            m = Magnet.new
            # This get text should exclude text from any intervals covered 
            # by other magnets. There should be drop zones at all excluded intervals.
            m.contents += createMagnetContent ctx, @exclusionIntervalsStack.last

            used_override = false
            node.overrides.each do |override|
              if ctxHasChildType(ctx,
                  eval("#{parser_class}::#{override[0]}Context"),
                  override[1])
                instance_variable_get("@#{override[2]}Magnets") << m
                used_override = true
              end
            end
            if used_override
              # Do nothing
            elsif node.list == "class_type"
              @classMagnets << m
            elsif node.list == "preamble_type"
              @preambleMagnets << m
            elsif node.list == "in_block_type"
              @statementMagnets << m
            end
            @exclusionIntervalsStack.pop
          end
        end
      end
      
      Object.const_set generating_class_name, emitter_class

    end
      
    ret = Object.const_get generating_class_name
    return ret
  end
end
