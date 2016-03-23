require "lib/magnetizer.rb"

describe "The magnetizer" do
  context "for a bad file" do
    let(:file) {"notafile"}

    it "should error on loading the magnetizer" do
      expect{Magnetizer.new(file)}.to raise_error(RuntimeError)
    end

  end

  shared_examples "a correct magnetizer" do 
    it "should load the magnetizer" do
      expect(Magnetizer.new(file)).to be_a(Magnetizer)
    end

    it "prints the magnets in the old format" do
      magnetizer = Magnetizer.new(file)
      #expect{magnetizer.print_magnets}.not_to raise_error
      expect{magnetizer.print_magnets}.to output(magnet_output).to_stdout
    end

    it "loads the magnets in the new data structure" do
      magnetizer = Magnetizer.new(file)
      expect(magnetizer.get_magnets).to eq(magnet_data_structure)

    end
  end

  context "for file Hello.java" do
    let(:file) {"spec/hello_java/Hello.java"}
    let(:magnet_output) {<<ENDOUT
Preamble Magnets:

Class Magnets:
public class Hello { <br><!-- panel --><br> }
Method Magnets:
public String helloWorld() { <br><!-- panel --><br> }
.:|:.
public static void main(String[] args) { <br><!-- panel --><br> }
Statement Magnets:
return &quot;Hello World&quot;;
.:|:.
System.out.println(&quot;Hello&quot;);
ENDOUT
}

    let(:magnet_data_structure) {[
      Magnet.new([MagnetText.new("public class Hello {"),
        MagnetDropZone.instance,
        MagnetText.new("}")
        ]),
      Magnet.new([MagnetText.new("public String helloWorld() {"),
        MagnetDropZone.instance,
        MagnetText.new("}")
        ]),
      Magnet.new([MagnetText.new("public static void main(String[] args) {"),
        MagnetDropZone.instance,
        MagnetText.new("}"),
        ]),
      Magnet.new([MagnetText.new('return "Hello World";')
        ]),
      Magnet.new([MagnetText.new('System.out.println("Hello");')
        ])
      ]}

    it_should_behave_like "a correct magnetizer"
  end

  context "for file Student.java that is palindrome" do
    let(:file) {"spec/palindrome_java/Student.java"}
    
    let(:magnet_output) {<<ENDOUT
Preamble Magnets:

Class Magnets:
public class Student { <br><!-- panel --><br> }
Method Magnets:
public boolean palindrome(String str) { <br><!-- panel --><br> }
Statement Magnets:
boolean isPalindrome = true;
.:|:.
for (int i = 0; i &lt; str.length() / 2; i++) { <br><!-- panel --><br> }
.:|:.
isPalindrome &amp;= (str.charAt(i) == str.charAt(str.length() - (i + 1)));
.:|:.
return isPalindrome;
ENDOUT
}
    let(:magnet_data_structure) {[
      Magnet.new([MagnetText.new("public class Student {"),
        MagnetDropZone.instance,
        MagnetText.new("}")
        ]),
      Magnet.new([MagnetText.new("public boolean palindrome(String str) {"),
        MagnetDropZone.instance,
        MagnetText.new("}")
        ]),
      Magnet.new([MagnetText.new("boolean isPalindrome = true;")
        ]),
      Magnet.new([MagnetText.new("for (int i = 0; i < str.length() / 2; i++) {"),
        MagnetDropZone.instance,
        MagnetText.new("}"),
        ]),
      Magnet.new([MagnetText.new('isPalindrome &= (str.charAt(i) == str.charAt(str.length() - (i + 1)));')
        ]),
      Magnet.new([MagnetText.new('return isPalindrome;')
        ])
      ]}

    it_should_behave_like "a correct magnetizer"
  end

  context "for file Preamble.java that has package and imports" do
    let(:file) {"spec/preamble_java/mypackage/Preamble.java"}

    let(:magnet_output) {<<ENDOUT
Preamble Magnets:
package mypackage;
.:|:.
import java.util.ArrayList;
.:|:.
import java.util.List;
Class Magnets:
public class Preamble { <br><!-- panel --><br> }
Method Magnets:
public void theMethod() {

  }
Statement Magnets:

ENDOUT
}
    let(:magnet_data_structure) {[
      Magnet.new([MagnetText.new('package mypackage;')
        ]),
      Magnet.new([MagnetText.new('import java.util.ArrayList;')
        ]),
      Magnet.new([MagnetText.new('import java.util.List;')
        ]),
      Magnet.new([MagnetText.new("public class Preamble {"),
        MagnetDropZone.instance,
        MagnetText.new("}")
        ]),
      Magnet.new([MagnetText.new("public void theMethod() {\n\n  }")
        ]),
      ]}

    it_should_behave_like "a correct magnetizer"
  end
end


