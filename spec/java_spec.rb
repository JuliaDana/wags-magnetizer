require "spec/main_spec.rb"

describe "The magnetizer on Java files" do

  context "for file Hello.java" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/java_hello/Hello.java"}
      let(:language) {"Java"}

      let(:magnet_output) {<<'ENDOUT'
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

      let(:json_output) {<<'ENDJSON'.rstrip
[
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "public class Hello {"
          }
        },
        {
          "json_class": "MagnetDropZone"
        },
        {
          "json_class": "MagnetText",
          "data": {
            "text": "}"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "public String helloWorld() {"
          }
        },
        {
          "json_class": "MagnetDropZone"
        },
        {
          "json_class": "MagnetText",
          "data": {
            "text": "}"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "public static void main(String[] args) {"
          }
        },
        {
          "json_class": "MagnetDropZone"
        },
        {
          "json_class": "MagnetText",
          "data": {
            "text": "}"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "return \"Hello World\";"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "System.out.println(\"Hello\");"
          }
        }
      ]
    }
  }
]
ENDJSON
}

      let(:yaml_output) {<<'ENDYAML'
---
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: public class Hello {
  - &1 !ruby/object:MagnetDropZone {}
  - !ruby/object:MagnetText
    text: '}'
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: public String helloWorld() {
  - *1
  - !ruby/object:MagnetText
    text: '}'
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: public static void main(String[] args) {
  - *1
  - !ruby/object:MagnetText
    text: '}'
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: return "Hello World";
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: System.out.println("Hello");
ENDYAML
}
    end
  end

  context "for file Student.java that is palindrome" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/java_palindrome/Student.java"}
      let(:language) {"Java"}
    
      let(:magnet_output) {<<'ENDOUT'
Preamble Magnets:

Class Magnets:
public class Student { <br><!-- panel --><br> }
Method Magnets:
public boolean palindrome(String str) { <br><!-- panel --><br> }
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

      let(:json_output) {<<'ENDJSON'.rstrip
[
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "public class Student {"
          }
        },
        {
          "json_class": "MagnetDropZone"
        },
        {
          "json_class": "MagnetText",
          "data": {
            "text": "}"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "public boolean palindrome(String str) {"
          }
        },
        {
          "json_class": "MagnetDropZone"
        },
        {
          "json_class": "MagnetText",
          "data": {
            "text": "}"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "boolean isPalindrome = true;"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "isPalindrome &= (str.charAt(i) == str.charAt(str.length() - (i + 1)));"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "for (int i = 0; i < str.length() / 2; i++) {"
          }
        },
        {
          "json_class": "MagnetDropZone"
        },
        {
          "json_class": "MagnetText",
          "data": {
            "text": "}"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "return isPalindrome;"
          }
        }
      ]
    }
  }
]
ENDJSON
}

      let(:yaml_output) {<<'ENDYAML'
---
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: public class Student {
  - &1 !ruby/object:MagnetDropZone {}
  - !ruby/object:MagnetText
    text: '}'
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: public boolean palindrome(String str) {
  - *1
  - !ruby/object:MagnetText
    text: '}'
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: boolean isPalindrome = true;
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: isPalindrome &= (str.charAt(i) == str.charAt(str.length() - (i + 1)));
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: for (int i = 0; i < str.length() / 2; i++) {
  - *1
  - !ruby/object:MagnetText
    text: '}'
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: return isPalindrome;
ENDYAML
}
    end
  end

  context "for file Preamble.java that has package and imports" do
    it_should_behave_like "a correct magnetizer" do
      let(:file) {"spec/java_preamble/mypackage/Preamble.java"}
      let(:language) {"Java"}

      let(:magnet_output) {<<'ENDOUT'
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
private String theField;
ENDOUT
}
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

      let(:json_output) {<<'ENDJSON'.rstrip
[
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "package mypackage;"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "import java.util.ArrayList;"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "import java.util.List;"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "public class Preamble {"
          }
        },
        {
          "json_class": "MagnetDropZone"
        },
        {
          "json_class": "MagnetText",
          "data": {
            "text": "}"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "public void theMethod() {\n\n  }"
          }
        }
      ]
    }
  },
  {
    "json_class": "Magnet",
    "data": {
      "contents": [
        {
          "json_class": "MagnetText",
          "data": {
            "text": "private String theField;"
          }
        }
      ]
    }
  }
]
ENDJSON
}

      let(:yaml_output) {<<'ENDYAML'
---
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: package mypackage;
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: import java.util.ArrayList;
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: import java.util.List;
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: public class Preamble {
  - !ruby/object:MagnetDropZone {}
  - !ruby/object:MagnetText
    text: '}'
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: |-
      public void theMethod() {

        }
- !ruby/object:Magnet
  contents:
  - !ruby/object:MagnetText
    text: private String theField;
ENDYAML
}
    end
  end
end


