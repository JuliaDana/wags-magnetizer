require 'yaml'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  # no rspec available
end

# TODO: Only compile files that have been updated.
task :compile do
  Dir.mkdir "java/bin" unless File.directory? "java/bin"
  system "cd java; javac -d bin -cp ../etc/antlr-4.5.1-complete.jar:$CLASSPATH src/**/*.java"
end

task :clean do
  system "cd java; rm -rf  bin"
end

languages_info = YAML.load_file("data/languages.yaml")

task :generate do
  write_empty_tasks
  if ARGV.empty?
    languages = languages_info.keys
  else
    languages = ARG
  end

  languages.each do |language|
    package = "#{language.downcase}_parser"
    system "cd data; java -cp ../etc/antlr-4.5.1-complete.jar:$CLASSPATH org.antlr.v4.Tool -no-visitor -o ../java/src/#{package} -package #{package} #{language}.g4"
  end
end

task :antlr do
  write_empty_tasks
  system "java -cp etc/antlr-4.5.1-complete.jar:java/bin:$CLASSPATH org.antlr.v4.Tool #{ARGV.join(" ")}"
end

task :grun do
  write_empty_tasks
  
  if File.exists? ARGV.first
    language = 'Java'
  else
    language = ARGV.shift
  end
  language_info = languages_info[language]
  input_filenames = ARGV.join(" ")
  package = "#{language.downcase}_parser"
  
  system "java -cp etc/antlr-4.5.1-complete.jar:java/bin:$CLASSPATH org.antlr.v4.gui.TestRig #{package}.#{language} #{language_info['start_rule']} #{input_filenames}"
end

task :tree do
  write_empty_tasks

  if File.exists? ARGV.first
    language = 'Java'
  else
    language = ARGV.shift
  end
  language_info = languages_info[language]
  input_filenames = ARGV.join(" ")
  package = "#{language.downcase}_parser"

  system "java -cp etc/antlr-4.5.1-complete.jar:java/bin:$CLASSPATH org.antlr.v4.gui.TestRig #{package}.#{language} #{language_info['start_rule']} -gui #{input_filenames}"
end

# Needed in order to use extra command line arguments as input to tasks
def write_empty_tasks
  puts ARGV.join "\n"
  ARGV.shift
  ARGV.each {|a| task a.to_sym do ; end}
end
