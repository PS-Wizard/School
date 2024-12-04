import java.io.*;

public class main{
    public static void main(String[] args) {
        File file = new File("myFile.txt");
        if (new File("myFile.txt").delete()) {
            System.out.println("File deleted successfully.");
        } else {
            System.out.println("Failed to delete the file.");
        }
    }
}

