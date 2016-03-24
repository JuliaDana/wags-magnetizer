require "lib/magnet.rb"

describe "A magnet" do
  context "when serializing to json" do
    it "should serialize" do
      m = Magnet.new
      m_json = m.to_json
      puts "JSON is #{m_json}"
      expect {JSON.parse(m_json)}.not_to raise_error
    end

    it "should deserialize as a Magnet" do
      m = Magnet.new
      deserialized_m = JSON.parse(m.to_json, :create_additions => true)
      deserialized_m = JSON.load(m.to_json)
      expect(deserialized_m).to be_a(Magnet)
    end

    it "should deserialize with data"
  end
end

