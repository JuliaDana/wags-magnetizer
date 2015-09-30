begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  # no rspec available
end

task :compile do
  system "cd java; mkdir bin; javac -d bin -cp ../etc/antlr-4.5.1-complete.jar:$CLASSPATH src/**/*.java"
end

task :clean do
  system "cd java; rm -rf  bin"
end

task :generate do
  system "java -cp etc/antlr-4.5.1-complete.jar:$CLASSPATH org.antlr.v4.Tool -o java/src data/Java.g4"
end
