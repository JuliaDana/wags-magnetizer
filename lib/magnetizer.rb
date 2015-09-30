require 'java'
require "etc/antlr-4.5.1-complete.jar"

# Importing entire packages
module Antlr
  include_package "org.antlr.v4.runtime"
  include_package "org.antlr.v4.runtime.tree"
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

puts "#{Antlr::ANTLRInputStream.inspect}"
# input = ANTLRInputStream.new(java.lang.System.in)
# 
# lexer = Java::ArrayInitLexer.new(input)
# tokens = CommonTokenStream.new(lexer)
# parser = Java::ArrayInitParser.new(tokens)
# 
# tree = parser.init
# 
# java.lang.System.out.println(tree.toStringTree(parser))

