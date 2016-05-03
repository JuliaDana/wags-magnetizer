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
    /*# NODROP */
    while (true) {
      System.out.println("Hello");
    }

    /*# NODROP */
    // Singleline
    /*# ALT while(false) */
    while (true) /*# ENDALT */ {
      System.out.println("Hello again");
    }
    
    for (int i = /*# ALT 1 */ 0 /*# ENDALT*/; i < 10; i++) {
      /*# EXTRAMAG return "not in code" */
      System.out.println("Thing " + i);
    }
  }
}
