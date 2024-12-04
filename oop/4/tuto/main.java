interface LivingBeing {
    void specialFeature(); 
}

class Fish implements LivingBeing{
    @Override
    public void specialFeature(){
        System.out.println("Fish can swim");
    }
}

class Bird implements LivingBeing{
    @Override
    public void specialFeature(){
        System.out.println("Bird can fly");
    }
}

public class main {
    public static void main(String[] args) {
    }
}
