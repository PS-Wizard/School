import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class TestFactorial {

    @Test
    public void testFactorial() {
        assertEquals(120, Factorial.calculateFactorial(5));  
        assertEquals(24, Factorial.calculateFactorial(4));  
    }
}

class Factorial {
    public static int calculateFactorial(int n) {
        int result = 1;
        for (int i = 1; i <= n; i++) {
            result *= i;  
        }
        return result;
    }
}

