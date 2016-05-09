require_relative "./main_spec.rb"

describe "The magnetizer on Python3 files" do
  context "basic python3 file" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/python3_hello/hello.py"}
      let(:language) {"Python3"}

      #TODO: Handle script areas outside of the class
      let(:magnet_output) {File.read("spec/python3_hello/hello.mag")}

      let(:data_structure) {[
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("class HelloWorld(object):"),
          Magnetizer::Magnet::DropZone.instance,
        ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("def say_hello(self):"),
          Magnetizer::Magnet::DropZone.instance,
        ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new('print("Hello, World")')),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("h = HelloWorld()")),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("h.say_hello()"))
      ]}

      let(:json_output) {File.read("spec/python3_hello/hello.json").rstrip}

      let(:yaml_output) {File.read("spec/python3_hello/hello.yaml")}
    end
  end

  context "basic python3 file with directives" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/python3_directives/hello.py"}
      let(:language) {"Python3"}

      #TODO: Handle script areas outside of the class
      let(:magnet_output) {File.read("spec/python3_directives/hello.mag")}

      let(:data_structure) {}

      let(:json_output) {
        #File.read("spec/python3_directives/hello.json").rstrip
      }

      let(:yaml_output) {
        #File.read("spec/python3_directives/hello.yaml");
      }
    end
  end
end
