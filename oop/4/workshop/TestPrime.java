import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class TestPrime {

    @Test
    public void test() {
        assertTrue(Primecheck.isPrime(5));  
        
        assertFalse(Primecheck.isPrime(10));  
    }
}

class Primecheck {
    public static boolean isPrime(int n) {
        for (int i = 2; i <= Math.sqrt(n); i++) {  
            if (n % i == 0) {
                return false;  
            }
        }
        return true;  
    }
}

