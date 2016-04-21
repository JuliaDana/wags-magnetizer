class MagnetDropZone < MagnetContent
  include Singleton
  
  def to_json *a
    {
      "json_class" => self.class.name,
      #"data" => {}
    }.to_json(*a)
  end

  def self.json_create o
    self.instance
  end
end
