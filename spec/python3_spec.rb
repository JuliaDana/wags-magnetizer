require "spec/main_spec.rb"

describe "The magnetizer on Python3 files" do
  context "basic python3 file" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/python3_hello/hello.py"}
      let(:language) {"Python3"}

      #TODO: Handle script areas outside of the class
      let(:magnet_output) {File.read("spec/python3_hello/hello.mag")}

      let(:data_structure) {[
        Magnet.new(MagnetText.new("class HelloWorld(object):"),
          MagnetDropZone.instance,
        ),
        Magnet.new(MagnetText.new("def say_hello(self):"),
          MagnetDropZone.instance,
        ),
        Magnet.new(MagnetText.new('print("Hello, World")')),
        Magnet.new(MagnetText.new("h = HelloWorld()")),
        Magnet.new(MagnetText.new("h.say_hello()"))
      ]}

      let(:json_output) {File.read("spec/python3_hello/hello.json").rstrip}

      let(:yaml_output) {File.read("spec/python3_hello/hello.yaml")}
    end
  end
end
