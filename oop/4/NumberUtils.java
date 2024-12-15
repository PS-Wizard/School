import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import java.util.ArrayList;
import java.util.List;

public class NumberUtils {
    public static int[] getEvenNumbers(int[] numbers) {
        List<Integer> evens = new ArrayList<>();
        for (int number : numbers) {
            if (number % 2 == 0) {
                evens.add(number);
            }
        }
        int[] result = new int[evens.size()];
        for (int i = 0; i < evens.size(); i++) {
            result[i] = evens.get(i);
        }
        return result;
    }

    @Test
    public void testGetEvenNumbers() {
        int[] input = {1, 2, 3, 4, 5, 6};
        int[] expected = {2, 4, 6};
        assertArrayEquals(expected, getEvenNumbers(input), "evens");
    }
}
