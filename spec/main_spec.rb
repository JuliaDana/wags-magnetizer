$CLASSPATH << "java/bin/"
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

    it "prints the magnets" do
      magnetizer = Magnetizer.new(file)
      expect{magnetizer.print_magnets}.not_to raise_error
      expect{magnetizer.print_magnets}.to output(magnet_output).to_stdout
    end
  end

  context "for file Hello.java" do
    let(:file) {"spec/hello_java/Hello.java"}
    let(:magnet_output) {<<ENDOUT
Class Magnets:
public class Hello {  <br><!-- panel --><br>  }
Method Magnets:
String helloWorld () {  <br><!-- panel --><br>  }
.:|:.
void main (String[] args) {  <br><!-- panel --><br>  }
Statement Magnets:
return &quot;Hello World&quot;;
.:|:.
System.out.println(&quot;Hello&quot;);
ENDOUT
}

    it_should_behave_like "a correct magnetizer"
  end

  context "for file Student.java that is palindrome" do
    let(:file) {"spec/palindrome_java/Student.java"}
    
    let(:magnet_output) {<<ENDOUT
Class Magnets:
public class Student {  <br><!-- panel --><br>  }
Method Magnets:
boolean palindrome (String str) {  <br><!-- panel --><br>  }
Statement Magnets:
boolean isPalindrome = true;
.:|:.
isPalindrome &amp;= (str.charAt(i) == str.charAt(str.length() - (i + 1)));
.:|:.
for (int i = 0; i &lt; str.length() / 2; i++) { <br><!-- panel --><br> }
.:|:.
return isPalindrome;
ENDOUT
}

    it_should_behave_like "a correct magnetizer"
  end

  context "for file Preamble.java that has package and imports" do
    let(:file) {"spec/preamble_java/mypackage/Preamble.java"}

    let(:magnet_output) {""}

    it_should_behave_like "a correct magnetizer"
  end
end
