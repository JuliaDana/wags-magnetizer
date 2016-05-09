unless defined? JRUBY_VERSION
  raise "This application must be run under JRuby"
end

$CLASSPATH << File.expand_path("../../java/bin/", __FILE__)
require 'java'
require_relative "../etc/antlr-4.5.1-complete.jar"
require 'cgi'
require 'yaml'


module Magnetizer
  # Importing entire packages to Antlr namespace
  module Antlr
    include_package "org.antlr.v4.runtime"
    include_package "org.antlr.v4.runtime.tree"
    include_package "org.antlr.v4.gui"
  end

  # Importing entire packages to Swing namespace
  module Swing
    include_package "javax.swing"
  end

  ## Uncomment the following code to put all the Antlr classes in the main
  ## namespace
  # class Object
  #   class << self
  #     alias :const_missing_old :const_missing
  #     def const_missing c
  #       Antlr.const_get c
  #     end
  #   end
  # end
  # include Antlr


  # Importing the needed classes individually
  # java_import org.antlr.v4.runtime.ANTLRInputStream
  # java_import org.antlr.v4.runtime.CommonTokenStream

  #require_relative "magnetizer/magnet_emitter_listener_generator.rb"
  require_relative "magnetizer/magnetizer.rb"
  require_relative "magnetizer/magnet_emitter_visitor_generator.rb"
  require_relative "magnetizer/wags_magnet_translator.rb"
  require_relative "magnetizer/language_config.rb"
  require_relative "magnetizer/directive.rb"
  YAML.load_file(File.expand_path("../../data/languages.yaml", __FILE__))

  class UnsupportedLanguageError < StandardError; end;
end
