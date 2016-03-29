require "spec/main_spec.rb"

describe "The magnetizer on Python3 files" do
  context "basic python3 file" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/python3_hello/hello.py"}

      #TODO: Handle script areas outside of the class
      let(:magnet_output) {<<'ENDOUT'
Preamble Magnets:

Class Magnets:
class HelloWorld(object): <br><!-- panel --><br>
Method Magnets:
def say_hello(self): <br><!-- panel --><br>
StatementMagnets:
print(&quot;Hello, World&quot;)
.:|:.
h = HelloWorld()
.:|:.
h.say_hello()
ENDOUT
      }

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

      let(:json_output) {}
      let(:xml_output) {}
    end
  end
end
