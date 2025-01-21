import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class MySQLExample {
    public static void main(String[] args) {
        // MySQL database URL, username, and password
        String url = "jdbc:mysql://localhost:3306/db"; // Replace with your database name
        String user = "wizard"; // Username (use 'root' in your case)
        String password = "letmelogin123"; // Use the root password (your system password)

        // SQL query to fetch data
        String query = "SELECT * FROM users";

        // Establish the connection
        try (Connection connection = DriverManager.getConnection(url, user, password);
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(query)) {

            // Process the result set
            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String name = resultSet.getString("name");
                String email = resultSet.getString("email");

                System.out.println("ID: " + id + ", Name: " + name + ", Email: " + email);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
