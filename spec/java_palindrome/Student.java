public class Student {

  public boolean palindrome(String str) {
    // boolean isPalendrom = false;
    boolean isPalindrome = true;

    // for (int i = 1; i < str.length() / 2; i++) {
    for (int i = 0; i < str.length() / 2; i++) {
      // isPalindrome &= (str.charAt(i) == str.charAt(str.length() - i));
      isPalindrome &= (str.charAt(i) == str.charAt(str.length() - (i + 1)));
    }

    // return true;
    // return false;
    return isPalindrome;
  }
}
