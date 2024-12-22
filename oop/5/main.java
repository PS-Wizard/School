interface Drawable {
    void draw();
}

class Circle implements Drawable{
    public void draw(){
        System.out.println("Drawing circle");
    }
}
class Rectangle implements Drawable{
    public void draw(){
        System.out.println("Drawing Rectangle");
    }

}

class Triangle implements Drawable{
    public void draw(){
        System.out.println("Drawing Triangle");
    }
}

public class main{
    public static void main(String[] args) {
        new Circle().draw();
        new Rectangle().draw();
        new Triangle().draw();
    }
}
