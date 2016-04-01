require_relative "java_magnet_emitter.rb"

class MagnetEmitterGenerator
  def self.generate language = "Java"
    if language == "Java"
      # return JavaMagnetEmitter

      parent_class = eval "Java::#{language.downcase}_parser.#{language}BaseListener"
      unless defined? GeneratedJavaMagnetEmitter
        emitter_class = Class.new(parent_class) do
          def initialize tokens
            super()
            #TODO: Finish method
          end
        end

        Object.const_set "GeneratedJavaMagnetEmitter", emitter_class
      end

      ret = Object.const_get "GeneratedJavaMagnetEmitter"
    end

    return ret
  end
end
