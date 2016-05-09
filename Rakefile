require 'yaml'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  # no rspec available
  puts "RSpec tasks not available. Please install RSpec to get these tasks."
end

begin
  require "bundler/gem_tasks"
rescue LoadError
  # no bundler available
  puts "Gem tasks not available. Please install Bundler to get these tasks."
end

begin
  require 'warbler'
  Warbler::Task.new
rescue LoadError
  puts "JAR packaging tasks not available. Please install Warbler to get these tasks."
end

# TODO: Only compile files that have been updated.
task :compile do
  Dir.mkdir "java/bin" unless File.directory? "java/bin"
  system "cd java; javac -d bin -cp ../etc/antlr-4.5.1-complete.jar:$CLASSPATH src/**/*.java"
  system "cd java/bin; jar cf parsers.jar *; mv parsers.jar .."
end

task :clean do
  system "cd java; rm -rf  bin"
  system "cd java; rm parser.java"
end

languages_info = YAML.load_file("data/languages.yaml")

task :generate do
  write_empty_tasks
  if ARGV.empty?
    languages = languages_info.map {|l| l["name"]}
  else
    languages = ARGV
  end

  languages.each do |language|
    package = "#{language.downcase}_parser"
    system "cd data; java -cp ../etc/antlr-4.5.1-complete.jar:$CLASSPATH org.antlr.v4.Tool -listener -visitor -o ../java/src/#{package} -package #{package} #{language}.g4"
  end
end

task :tokens do
  write_empty_tasks
  
  if File.exists? ARGV.first
    language = 'Java'
  else
    language = ARGV.shift
  end

  language_info = nil
  languages_info.each do |l|
    if l['name'] == language
      language_info = l
    end
  end
  input_filenames = ARGV.join(" ")
  package = "#{language.downcase}_parser"
  
  system "java -cp etc/antlr-4.5.1-complete.jar:java/bin:$CLASSPATH org.antlr.v4.gui.TestRig #{package}.#{language} #{language_info['start_rule']} -tokens #{input_filenames}"
end

task :tree do
  write_empty_tasks

  if File.exists? ARGV.first
    language = 'Java'
  else
    language = ARGV.shift
  end
  language_info = nil
  languages_info.each do |l|
    if l['name'] == language
      language_info = l
    end
  end
  input_filenames = ARGV.join(" ")
  package = "#{language.downcase}_parser"

  system "java -cp etc/antlr-4.5.1-complete.jar:java/bin:$CLASSPATH org.antlr.v4.gui.TestRig #{package}.#{language} #{language_info['start_rule']} -gui #{input_filenames}"
end

# Needed in order to use extra command line arguments as input to tasks
def write_empty_tasks
  ARGV.shift
  ARGV.each {|a| task a.to_sym do ; end}
end
