import java.io.File;

public class Main {

    public static void main(String[] args) {

        File file = new File("example.txt");

        if (file.isFile()) {

            System.out.println("This is a file");

        } else {

            System.out.println("This is not a file");

        }

    }

}
