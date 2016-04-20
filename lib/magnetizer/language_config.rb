require 'pp'

LOADED_LANGUAGES = {}

class LanguageConfig
  attr_accessor :name
  attr_accessor :start_rule
  attr_accessor :magnet_nodes
  attr_accessor :allow_file_statements
  attr_accessor :directive_start
  attr_accessor :directive_end
   

  def initialize name, start_rule
    if LOADED_LANGUAGES.key? name
      raise "Language '#{name}' already loaded"
    end

    @name = name
    @start_rule = start_rule
    @magnet_nodes = []

    LOADED_LANGUAGES[@name] = self
  end

  class NodeConfig
    attr_accessor :name
    attr_accessor :list
    attr_accessor :overrides

    def initialize name, list = nil
      @name = name
      @list = list
      @overrides = []
    end

    def add_override child_name, child_level, list
      overrides << [child_name, child_level, list]
    end
  end

  ###### Methods for custom YAML serialization ######

  YAML_TYPE = "!customObject/LanguageConfig"

  # Define the tag for this type of object
  def to_yaml_type 
    YAML_TYPE
  end

  # Define how to encode this class to YAML
  #
  # + coder + - A Psych::Coder data structure that needs to be 
  #   loaded with the data to be emitted
  def encode_with coder
    coder['name'] = @name
    coder['start_rule'] = @start_rule
    coder['directives'] = {}
    coder['directives']['start'] = @directive_start
    coder['directives']['end'] = @directive_end

    overrides = []

    h = Hash.new {|hash, key| hash[key] = []}
    @magnet_nodes.each do |node|
      h[node.list] << node.name

      node.overrides.each do |o|
        overrides << {'name' => node.name,
          'child_node_type' => o[0],
          'child_level' => o[1],
          'location' => o[2]}
      end
    end

    h.each do |k, v|
      coder[k] = v
    end

    coder['overrides'] = overrides
  end

  # Define how to load this class from YAML. This is similar to an
  # initialize method in that we start with an empty object.
  #
  # + coder + - A Psych::Coder data structure that holds the data
  #   coming in from YAML
  def init_with coder
    data = coder.map
    @name = data.delete('name')
    if LOADED_LANGUAGES.key? @name
      raise "Language '#{@name}' already loaded"
    end
    @start_rule = data.delete('start_rule')
    @allow_file_statements = data.delete('allow_file_statements') || false
    @directive_start = data['directives']['start']
    @directive_end = data.delete('directives')['end']

    overrides = data.delete('overrides') || []

    # At this point, all that is left in the map is the list entries.
    @magnet_nodes = []
    data.each do |k, v|
      list = k
      v.each do |node_name|
        node = NodeConfig.new(node_name, list)
        overrides.each do |o|
          if node.name == o["name"]
            node.add_override o["child_node_type"], o["child_level"], 
              o["location"]
          end
        end
        @magnet_nodes << node
      end
    end

    LOADED_LANGUAGES[@name] = self
  end
end

# Connect the tag for this type of object to YAML
YAML::add_tag LanguageConfig::YAML_TYPE, LanguageConfig
