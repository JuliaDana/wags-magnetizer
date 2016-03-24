require "lib/magnet.rb"

describe "A magnet" do
  context "when serializing to json" do
    it "should serialize" do
      m = Magnet.new
      expected_json = "{}"
      expect(m.to_json).to eq(expected_json)
    end

    it "should deserialize as a Magnet" do
      m = Magnet.new
      deserialized_m = JSON.parse(m.to_json)
      expect(deserialized_m).to be_a(Magnet)
    end

    it "should deserialize with data"
  end
end

