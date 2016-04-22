require "spec/main_spec.rb"

describe "The magnetizer on Java files" do

  context "for file Hello.java" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/java_hello/Hello.java"}
      let(:language) {"Java"}

      let(:magnet_output) {File.read("spec/java_hello/hello.mag")}

      let(:data_structure) {[
        Magnet.new(MagnetText.new("public class Hello {"),
          MagnetDropZone.instance,
          MagnetText.new("}")
          ),
        Magnet.new(MagnetText.new("public String helloWorld() {"),
          MagnetDropZone.instance,
          MagnetText.new("}")
          ),
        Magnet.new(MagnetText.new("public static void main(String[] args) {"),
          MagnetDropZone.instance,
          MagnetText.new("}"),
          ),
        Magnet.new(MagnetText.new('return "Hello World";')
          ),
        Magnet.new(MagnetText.new('System.out.println("Hello");')
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
        Magnet.new(MagnetText.new("public class Student {"),
          MagnetDropZone.instance,
          MagnetText.new("}")
          ),
        Magnet.new(MagnetText.new("public boolean palindrome(String str) {"),
          MagnetDropZone.instance,
          MagnetText.new("}")
          ),
        Magnet.new(MagnetText.new("boolean isPalindrome = true;")
          ),
        Magnet.new(MagnetText.new('isPalindrome &= (str.charAt(i) == str.charAt(str.length() - (i + 1)));')
          ),
        Magnet.new(MagnetText.new("for (int i = 0; i < str.length() / 2; i++) {"),
          MagnetDropZone.instance,
          MagnetText.new("}"),
          ),
        Magnet.new(MagnetText.new('return isPalindrome;')
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
        Magnet.new(MagnetText.new('package mypackage;')
          ),
        Magnet.new(MagnetText.new('import java.util.ArrayList;')
          ),
        Magnet.new(MagnetText.new('import java.util.List;')
          ),
        Magnet.new(MagnetText.new("public class Preamble {"),
          MagnetDropZone.instance,
          MagnetText.new("}")
          ),
        #TODO: Should there be a drop zone in the empty method? 
        Magnet.new(MagnetText.new("public void theMethod() {\n\n  }")
          ),
        Magnet.new(MagnetText.new("private String theField;")
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

