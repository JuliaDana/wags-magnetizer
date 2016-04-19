/**
 * Javadoc
 * @author Julia
 */
public class Hello {
  public String helloWorld() {
    return "Hello World";
  }

  /* Multiline. */
  public static void main(String[] args) {
    /*# NODROP a */
    while (true) {
      System.out.println("Hello");
    }

    /*# NODROP b*/
    // Singleline
    /*# ALT while(false) */
    while (true) /*# ENDALT 1*/ {
      System.out.println("Hello");
    }
    
    for (int i = /*# ALTTEXT 1 */ 0 /*# ENDALT 2*/; i < 10; i++) {
      System.out.println("Thing " + i);
    }
  }
}
