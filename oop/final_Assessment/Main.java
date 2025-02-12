/**
 * The main class that serves as the entry point for the application.
 * It creates an instance of the Manager class and invokes the method
 * to create and display the GUI.
 */
public class Main{
    public static void main(String[] args) {
        
        Manager manager = new Manager();
        manager.createAndShowGUI();
    }
}
