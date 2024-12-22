import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class TestMultiply {
    @Test
    public void testmul() {
        assertEquals(6, Multiply.mul(2,3));
    }
}

class Multiply {
    public static int mul(int a, int b) {
        return a * b; 
    }
}
