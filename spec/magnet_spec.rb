require_relative "../lib/magnetizer/magnet.rb"

include Magnetizer

describe "A magnet" do

  context "when coalescing" do
    it "should join adjacent Magnet::Text pieces"

    #TODO: Define what handling the whitespace means
    it "should handle whitespace at the ends of Magnet::Text sections"

    it "should join join adjacent Magnet::DropZone pieces"

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
      m = Magnet.new([Magnet::Choices.new("public", "private", "protected"),
        Magnet::Text.new("class Test {"),
        Magnet::DropZone.instance,
        Magnet::Text.new("}")
      ])
      deserialized_m = JSON.load(m.to_json)

      expect(deserialized_m).to eq(m)
    end
  end
end

