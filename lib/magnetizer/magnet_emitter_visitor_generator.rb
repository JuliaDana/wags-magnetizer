require_relative "magnet_emitter_base.rb"

class MagnetEmitterVisitorGenerator
  def self.generate language = "Java"
    unless LOADED_LANGUAGES.keys.include? language
        raise UnsupportedLanguageError, "#{language} not supported by this #{self.name}"
    end

    parent_class = eval "Java::#{language.downcase}_parser.#{language}BaseVisitor"
    parser_class = eval  "Java::#{language.downcase}_parser.#{language}Parser"
    generating_class_name = "Generated#{language}MagnetEmitterVisitor"


    # Only run the class generation if it has not been defined. 
    # Return the existing class if it is defined.
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
          # Using sub to get rid of the beginning assumes that the 
          # language config correctly matches what is defined in 
          # the grammar
          text = tok.getText.chomp(language_info.directive_end).sub(language_info.directive_start, '')
          command, arg = text.split(' ', 2)
          return Directive.new(command, arg)
        end

        all_types = language_info.magnet_nodes

        # Create the visit methods for each of the types of nodes
        # that triggers the creation of a magnet
        all_types.each do |node|
          define_method "visit#{node.name}" do |ctx|
            directives = get_directives ctx

            # Default for options that can come from directives
            no_drop = false
            alt_at_beginning = nil

            directives.each do |d|
              case d.command
              when "NODROP"
                no_drop = true
              when "ALT"
                alt_at_beginning = d.arg
              when "ENDALT"
                raise "This shouldn't happen"
              end
            end

            if node.list == "in_block_type"
              # Record that the text that creates this magnet
              # should be excluded from its enclosing magnet.
              @exclusionIntervalsStack.last << ctx.getSourceInterval
            end

            # Set up array to hold intervals that will be excluded
            # from this magnet by its children.
            @exclusionIntervalsStack << []

            # If we have recieved the NODROP directive, do not visit
            # the children, their text should be included in this magnet.
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
