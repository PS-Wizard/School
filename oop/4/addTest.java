import org.junit.Test;
import static org.junit.Assert.assertEquals;
class add{
    public static int add(int a, int b) {
        return a + b;
    }
    public static void main(String[] args) {
        
    }
}
public class addTest{
    @Test
    public void testAdd() {
        assertEquals(5, add.add(2, 3));  
    }

}
