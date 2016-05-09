require "spec/main_spec.rb"

describe "The magnetizer on Java files" do

  context "for file Hello.java" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/java_hello/Hello.java"}
      let(:language) {"Java"}

      let(:magnet_output) {File.read("spec/java_hello/hello.mag")}

      let(:data_structure) {[
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("public class Hello {"),
          Magnetizer::Magnet::DropZone.instance,
          Magnetizer::Magnet::Text.new("}")
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("public String helloWorld() {"),
          Magnetizer::Magnet::DropZone.instance,
          Magnetizer::Magnet::Text.new("}")
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("public static void main(String[] args) {"),
          Magnetizer::Magnet::DropZone.instance,
          Magnetizer::Magnet::Text.new("}"),
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new('return "Hello World";')
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new('System.out.println("Hello");')
          )
        ]}

      let(:json_output) {File.read("spec/java_hello/hello.json").rstrip}

      let(:yaml_output) {File.read("spec/java_hello/hello.yaml")}
    end
  end

  context "for file Student.java that is palindrome" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/java_palindrome/Student.java"}
      let(:language) {"Java"}
    
      let(:magnet_output) {File.read("spec/java_palindrome/palindrome.mag")}

      let(:data_structure) {[
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("public class Student {"),
          Magnetizer::Magnet::DropZone.instance,
          Magnetizer::Magnet::Text.new("}")
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("public boolean palindrome(String str) {"),
          Magnetizer::Magnet::DropZone.instance,
          Magnetizer::Magnet::Text.new("}")
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("boolean isPalindrome = true;")
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new('isPalindrome &= (str.charAt(i) == str.charAt(str.length() - (i + 1)));')
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("for (int i = 0; i < str.length() / 2; i++) {"),
          Magnetizer::Magnet::DropZone.instance,
          Magnetizer::Magnet::Text.new("}"),
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new('return isPalindrome;')
          )
        ]}

      let(:json_output) {File.read("spec/java_palindrome/palindrome.json").rstrip}

      let(:yaml_output) {File.read("spec/java_palindrome/palindrome.yaml")}
    end
  end

  context "for file Preamble.java that has package and imports" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/java_preamble/mypackage/Preamble.java"}
      let(:language) {"Java"}

      let(:magnet_output) {File.read("spec/java_preamble/preamble.mag")}

      let(:data_structure) {[
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new('package mypackage;')
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new('import java.util.ArrayList;')
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new('import java.util.List;')
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("public class Preamble {"),
          Magnetizer::Magnet::DropZone.instance,
          Magnetizer::Magnet::Text.new("}")
          ),
        #TODO: Should there be a drop zone in the empty method? 
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("public void theMethod() {\n\n  }")
          ),
        Magnetizer::Magnet.new(Magnetizer::Magnet::Text.new("private String theField;")
          ),
        ]}

      let(:json_output) {File.read("spec/java_preamble/preamble.json").rstrip}

      let(:yaml_output) {File.read("spec/java_preamble/preamble.yaml")}
    end
  end
  
  context "for file Hello.java with directives" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/java_directives/Hello.java"}
      let(:language) {"Java"}

      let(:magnet_output) {File.read("spec/java_directives/hello.mag")}

      let(:data_structure) {}

      let(:json_output) {File.read("spec/java_directives/hello.json").rstrip}

      let(:yaml_output) {File.read("spec/java_directives/hello.yaml")}
    end
  end
end

