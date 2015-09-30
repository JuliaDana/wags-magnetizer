begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  # no rspec available
end

task :compile do
  puts `cd java; mkdir bin; javac -d bin src/*.java`
end

task :clean do
  `cd java; rm -rf  bin`
end
