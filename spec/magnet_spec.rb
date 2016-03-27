require "lib/magnet.rb"

describe "A magnet" do

  context "when coalescing" do
    it "should join adjacent MagnetText pieces"

    #TODO: Define what handling the whitespace means
    it "should handle whitespace at the ends of MagnetText sections"

    it "should join join adjacent MagnetDropZone pieces"

    it "should not join other type of MagnetContent"

  end


  context "when serializing to json" do
    it "should serialize" do
      m = Magnet.new
      m_json = m.to_json
      expect {JSON.parse(m_json)}.not_to raise_error
    end

    it "should deserialize as a Magnet" do
      m = Magnet.new
      deserialized_m = JSON.parse(m.to_json, :create_additions => true)
      deserialized_m = JSON.load(m.to_json)
      expect(deserialized_m).to be_a(Magnet)
    end

    it "should deserialize with data" do
      m = Magnet.new([MagnetChoices.new("public", "private", "protected"),
        MagnetText.new("class Test {"),
        MagnetDropZone.instance,
        MagnetText.new("}")
      ])
      deserialized_m = JSON.load(m.to_json)

      expect(deserialized_m).to eq(m)
    end
  end
end

