import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class MathUtilsTest {

    @Test
    public void testAdd() {
        MathUtils ms = new MathUtils();
        assertEquals(5, ms.add(2, 3));  // test the `add` method
    }
}

