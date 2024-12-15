import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class  StringTest {
    @Test
    public void testString() {
        assertAll(
            () -> assertEquals("tac", Stringmethods.reverse("cat")),
            () -> assertEquals("HELLO", Stringmethods.toUpperCase("hello")),
            () -> assertTrue(Stringmethods.isPalindrome("racecar")),
            () -> assertEquals(4, Stringmethods.countVowels("someone"))
        );
    }
}

class Stringmethods {
    public static String reverse(String input) {
        StringBuilder reverser = new StringBuilder(input);
        return reverser.reverse().toString();
    }

    public static String toUpperCase(String input) { return input.toUpperCase(); }

    public static boolean isPalindrome(String input) {
        String reversed = reverse(input);
        return input.equals(reversed);
    }

    public static int countVowels(String input) {
        int count = 0;
        for (char c : input.toLowerCase().toCharArray()) {
            if ("aeiou".indexOf(c) != -1) count++;
        }
        return count;
    }
}
