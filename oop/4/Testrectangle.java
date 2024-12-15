import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class Testrectangle {

    @Test
    public void testRectangle() {
        Rectangle rectangle = new Rectangle(5, 3);
        assertEquals(15, rectangle.area());
        assertEquals(16, rectangle.perimeter());
    }
}

class Rectangle {
    private double length;
    private double width;

    public Rectangle(double length, double width) {
        this.length = length;
        this.width = width;
    }

    public double area() { return length * width; }

    public double perimeter() { return 2 * (length + width); }
}

