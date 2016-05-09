require "spec/main_spec.rb"

describe "The magnetizer on Ruby files" do
  xcontext "basic ruby file" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/ruby_hello/hello.rb"}
      let(:language) {"Ruby"}

      #TODO: Handle script areas outside of the class
      let(:magnet_output) {<<'ENDOUT'
Preamble Magnetizer::Magnets:

Class Magnetizer::Magnets:
class HelloWorld <br><!-- panel --><br> end
Method Magnetizer::Magnets:
def say_hello <br><!-- panel --><br> end
StatementMagnetizer::Magnets:
puts &quot;Hello, World&quot;
.:|:.
h = HelloWorld.new
.:|:.
h.say_hello
ENDOUT
      }

      let(:data_structure) {[
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("class HelloWorld"),
          Magnetizer::Magnet::DropZone.instance,
          Magnetizer::Magnet::Text.new("end")
        ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("def say_hello"),
          Magnetizer::Magnet::DropZone.instance,
          Magnetizer::Magnet::Text.new("end")
        ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new('puts "Hello, World"')),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("HelloWorld.new")),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("h.say_hello"))
      ]}

      let(:json_output) {}
    end
  end
end
