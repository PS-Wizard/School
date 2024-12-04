interface Shape {
    void calculateArea(int radius); 
    void calculatePerimeter(int radius); 
    
    void calculateArea(int length, int breadth); 
    void calculatePerimeter(int length, int breadth); 
}

class Circle implements Shape{
    public static final double PI = 3.141592653; 

    public void calculateArea(int radius) {
        System.out.println("Area of Circle: " + PI * radius * radius);
    }

    public void calculatePerimeter(int radius) {
        System.out.println("Perimeter of Circle: " + 2 * PI * radius);
    }

    public void calculatePerimeter(int l,int b){}
    public void calculateArea(int l,int b){}

}

class Rectangle implements Shape{
    public void calculateArea(int length, int breadth) {
        System.out.println("Area of Rectangle: " + length * breadth);
    }

    public void calculatePerimeter(int length, int breadth) {
        System.out.println("Perimeter of Rectangle: " + 2 * (length + breadth));
    }
    public void calculatePerimeter(int r){}
    public void calculateArea(int r){}
}

public class main {
    public static void main(String[] args) {
        Circle obj1 = new Circle();
        Rectangle obj2 = new Rectangle();
        
        obj1.calculatePerimeter(5); 
        obj1.calculateArea(5); 
        
        obj2.calculatePerimeter(5, 5);
        obj2.calculateArea(5, 5); 
    }
}

