import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class CalculatorTest {
    private static Calculator calculator;

    @BeforeAll
    public static void beforeclass() {
        System.out.println("Some thing to run only once");
    }

    @AfterAll
    public static void afterclass() {
        calculator = null; 
        System.out.println("something to clean up after each class");
    }

    @BeforeEach
    public void bef() { calculator = new Calculator(); }

    @AfterEach
    public void after() { System.out.println("Runned once"); }

    @Test
    public void testadd() { assertEquals(5, calculator.add(2, 3)); }

    @Test
    public void testsub() { assertEquals(1, calculator.subtract(3, 2)); }

    @Test
    public void testmul() { assertEquals(6, calculator.multiply(2, 3)); }
    @Test
    public void testdiv() { assertEquals(2, calculator.divide(6, 3)); }
}

class Calculator {
    public int add(int a, int b) { return a + b; }

    public int subtract(int a, int b) { return a - b; }

    public int multiply(int a, int b) { return a * b; }

    public int divide(int a, int b) { return a / b; }
}
