require_relative "magnet_emitter_base.rb"

class MagnetVisitorGenerator
  def self.generate language = "Java"
    unless LOADED_LANGUAGES.keys.include? language
        raise UnsupportedLanguageError, "#{language} not supported by this #{self.name}"
    end

    parent_class = eval "Java::#{language.downcase}_parser.#{language}BaseVisitor"
    parser_class = eval  "Java::#{language.downcase}_parser.#{language}Parser"
    generating_class_name = "Generated#{language}MagnetVisitor"


    unless const_defined? generating_class_name
      
      emitter_class = Class.new(parent_class) do
        # TODO: Check for effeciency from using this in closures
        language_info = LOADED_LANGUAGES[language]

        include MagnetEmitterBase

        @language_info = language_info

        self.class.class_eval do
          define_method("allow_file_statements") do
            language_info.allow_file_statements
          end

        end

        define_method :strip_directive do |tok|
          # Using sub to get rid of the beginning assumes that the language config
          # correctly matches what is defined in the grammar
          return tok.getText.chomp(language_info.directive_end).sub(language_info.directive_start, '')
        end

        all_types = language_info.magnet_nodes

        all_types.each do |node|
          # TODO create more specific method bodies
          define_method "visit#{node.name}" do |ctx|
            directives = get_directives ctx
            no_drop = false
            alt_at_beginning = nil

            directives.each do |d|
              command, info = d.split(' ', 2)
              puts "COMMAND: #{command}"
              puts "INFO: #{info}"

              case command
              when "NODROP"
                no_drop = true
              # TODO make sure EXTRAMAG works when not immediately before a new magnet
              when "EXTRAMAG"
                extra_mag = Magnet.new
                extra_mag.contents << MagnetText.new(info)
                @statementMagnets << extra_mag
              when "ALT"
                alt_at_beginning = info
              when "ENDALT"
                raise "This shouldn't happen"
              end
            end

            # TODO handle directives

            if node.list == "in_block_type"
              @exclusionIntervalsStack.last << ctx.getSourceInterval
            end

            @exclusionIntervalsStack << []
            unless no_drop
              visitChildren(ctx)
            end

            m = Magnet.new
            alt_ms = []
            # This get text should exclude text from any intervals covered 
            # by other magnets. There should be drop zones at all excluded intervals.
            c = createMagnetContent ctx, @exclusionIntervalsStack.last
            first_c = true
            if c.first.is_a? Array
              c.each do |content|
                alt_m = Magnet.new
                if alt_at_beginning && !first_c
                  content.unshift MagnetText.new(alt_at_beginning) 
                end
                alt_m.contents += content
                alt_ms << alt_m
                first_c = false
              end
            else
              m.contents += c
            end


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
              if alt_ms.empty?
                @statementMagnets << m
              else
                @statementMagnets += alt_ms
              end
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
