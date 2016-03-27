require "spec/main_spec.rb"

describe "The magnetizer on Ruby files" do
  context "basic ruby file" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/ruby_hello/hello.rb"}

      #TODO: Handle script areas outside of the class
      let(:magnet_output) {<<'ENDOUT'
Preamble Magnets:

Class Magnets:
class HelloWorld <br><!-- panel --><br> end
Method Magnets:
def say_hello <br><!-- panel --><br> end
StatementMagnets:
puts &quot;Hello, World&quot;
.:|:.
h = HelloWorld.new
.:|:.
h.say_hello
ENDOUT
      }

      let(:data_structure) {[
        Magnet.new(MagnetText.new("class HelloWorld"),
          MagnetDropZone.instance,
          MagnetText.new("end")
        ),
        Magnet.new(MagnetText.new("def say_hello"),
          MagnetDropZone.instance,
          MagnetText.new("end")
        ),
        Magnet.new(MagnetText.new('puts "Hello, World"')),
        Magnet.new(MagnetText.new("HelloWorld.new")),
        Magnet.new(MagnetText.new("h.say_hello"))
      ]}

      let(:json_output) {}
      let(:xml_output) {}
    end
  end
end
