require_relative "java_magnet_emitter.rb"

class MagnetEmitterGenerator
  def self.generate language = "Java"
    if language == "Java"
      return JavaMagnetEmitter
    end
  end
end
