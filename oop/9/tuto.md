## CRUD OPERATIONS:
```java
~

import java.sql.*;

public class MySQLExample{
    public static void main(String[] args) {
        String url = "jdbc:mysql://localhost:3306/db";
        String user = "wizard"; 
        String password = "letmelogin123";

        try (Connection conn = DriverManager.getConnection(url, user, password);
             Statement stmt = conn.createStatement()) {

            // CREATE
            stmt.executeUpdate("INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com')");
            System.out.println("Inserted a new user.");

            // READ
            ResultSet rs = stmt.executeQuery("SELECT * FROM users");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("id") + ", Name: " + rs.getString("name") + ", Email: " + rs.getString("email"));
            }

            // UPDATE
            stmt.executeUpdate("UPDATE users SET email = 'john.doe@example.com' WHERE name = 'John Doe'");
            System.out.println("Updated user email.");

            // DELETE
            stmt.executeUpdate("DELETE FROM users WHERE name = 'John Doe'");
            System.out.println("Deleted the user.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```
```bash
~

[wizard@archlinux 9]$ java-run-db MySQLExample
Inserted a new user.
ID: 1, Name: Alice, Email: alice@example.com
ID: 2, Name: Bob, Email: bob@example.com
ID: 3, Name: Charlie, Email: charlie@example.com
ID: 4, Name: John Doe, Email: john@example.com
Updated user email.
Deleted the user.
[wizard@archlinux 9]$

```
>

