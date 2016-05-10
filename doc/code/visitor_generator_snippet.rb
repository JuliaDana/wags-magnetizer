# Dynamically get the (ANTLR-generated) class that 
# we need to subclass.
parent_class = eval "Java::#{language.downcase}_parser.#{language}BaseVisitor"
# Dynamically get the ANTLR-generated parser we will
# be using.
parser_class = eval  "Java::#{language.downcase}_parser.#{language}Parser"

# Dynamically create the name of the class we will 
# be creating.
generating_class_name = "Generated#{language}MagnetEmitterVisitor"

# Dynamically create our new class that subclasses the 
# ANTLR-generated class
generated_class = Class.new(parent_class) do

  # Reference to the configuration for this language 
  # from the YAML file
  language_info = LOADED_LANGUAGES[language]
  magnet_types = language_info.magnet_nodes

  # Omitted - creating methods with names that do 
  # not change based on the configuration.

  # Create the visit methods for each of the types of
  # nodes that trigger the creation of a magnet
  magnet_types.each do |node|
    define_method "visit#{node.name}" do |ctx|
      # Omitted - the body of the visit methods
    end
  end
end

# Connect the class we just created to the name 
# we want it to have.
Object.const_set generating_class_name, emitter_class
