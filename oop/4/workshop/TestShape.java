import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class TestShape {
    @Test
    public void testShape() {
        Shape circle = new Circle(5);
        assertEquals(Math.PI * 5 * 5, circle.area());
        Shape rectangle = new Rectangle(4, 6);
        assertEquals(24, rectangle.area());
    }
}

class Shape {
    public double area() { return 0; }
}

class Circle extends Shape {
    private double radius;

    public Circle(double radius) { this.radius = radius; }

    @Override
    public double area() { return Math.PI * radius * radius; } 
}

class Rectangle extends Shape {
    private double length;
    private double width;

    public Rectangle(double length, double width) {
        this.length = length;
        this.width = width;
    }

    @Override
    public double area() { return length * width; }
}

