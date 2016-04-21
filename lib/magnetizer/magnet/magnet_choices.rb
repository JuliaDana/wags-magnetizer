class MagnetChoices < MagnetContent
  attr_accessor :choices

  def initialize *choices
    @choices = choices
  end

  def to_json *a
    {
      "json_class" => self.class.name,
      "data" => {"choices" => @choices}
    }.to_json(*a)
  end

  def self.json_create o
    self.new(*o["data"]["choices"])
  end

  def == other
    return other.is_a?(self.class) && self.choices == other.choices
  end
end
