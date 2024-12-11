import org.junit.Before;
import org.junit.After;
import org.junit.Test;

public class DatabaseConnectionTest {

    private DatabaseConnection ms;

    @Before
    public void testConnection() {
        ms = new DatabaseConnection();
    }

    @Test
    public void testConnectToDatabase() {
        ms.connectToDatabase(); // This would call the method you're testing
    }

    @After
    public void closeConnection() {
        System.out.println("Closed Connection");
    }
}

class DatabaseConnection {
    public void connectToDatabase() {
        System.out.println("Established connection");
    }
}

