unless defined? JRUBY_VERSION
  raise "This application must be run under JRuby"
end

require 'optparse'
require_relative "../magnetizer.rb"

module Magnetizer
  class CLI
    DEFAULT_OPTS = {:wags => true, :language => "Java"}

    def initialize
      @options = DEFAULT_OPTS

      @parser = OptionParser.new do |opts|
        opts.banner = "Usage: magnetizer [options] file"

        opts.on("-l", "--language LANGUAGE",
            "Specify a language (default: Java, other: Python3)") do |language|
          @options[:language] = language
        end

        opts.on("--json", "Print the JSON output") do
          @options[:json] = true
        end

        opts.on("--yaml", "Print the YAML output") do
          @options[:yaml] = true
        end

        opts.on("--[no-]wags", "Print the output as WAGS magnets (default)") do |wags|
          @options[:wags] = wags
        end

        # opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
        #   options[:verbose] = v
        # end

        opts.on("-o", "--output-file BASE_FILENAME", "Output to a file") do |filename|
          @options[:output] = filename
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end
    end
   
    def parse argv
      argv = Array.new argv
      @parser.parse!

      @options[:file] = argv.first

      if @options[:file].nil? || @options[:file].empty? 
        puts "No file specified"
        puts @parser
        exit
      end

      puts "Running the magnetizer on #{@options[:file]}"
    end

    def run
      self.create_magnetizer
      self.output
    end

    def create_magnetizer
      @magnetizer = Magnetizer.new(@options[:file], @options[:language])
    end

    def output
      print_to = @options[:output] ? File.new(@options[:output], "w") : STDOUT

      if @options[:wags]
        if @options[:output]
          File.new("#{@options[:output]}.wags", "w") do |print_to|
            @magnetizer.print_magnets print_to
          end
        else
          @magnetizer.print_magnets
        end
      end

      if @options[:json]
        if @options[:output]
          File.new("#{@options[:output]}.json", "w") do |print_to|
            @magnetizer.print_json print_to
          end
        else
          @magnetizer.print_json print_to
        end
      end

      if @options[:yaml]
        if @options[:output]
          File.new("#{@options[:output]}.yaml", "w") do |print_to|
            @magnetizer.print_yaml print_to
          end
        else
          @magnetizer.print_yaml print_to
        end
      end
    end
  end
end
