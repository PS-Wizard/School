import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class TempConversionTest {

    @Test
    public void testCelsiusToFahrenheit() {
        assertEquals(32.0, tmpConversion.celciusToFer(0), 0.01);  
        assertEquals(212.0, tmpConversion.celciusToFer(100), 0.01); 
    }

    @Test
    public void testFahrenheitToCelsius() {
        assertEquals(0.0, tmpConversion.ferToCel(32), 0.01);  
        assertEquals(100.0, tmpConversion.ferToCel(212), 0.01); 
    }
}

class tmpConversion {
    public static double celciusToFer(double celsius) {
        return (celsius * 9/5) + 32;
    }

    public static double ferToCel(double fahrenheit) {
        return (fahrenheit - 32) * 5/9;
    }

}

