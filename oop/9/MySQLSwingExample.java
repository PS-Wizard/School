import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class MySQLSwingExample extends JFrame {
    private JTextArea outputArea;

    public MySQLSwingExample() {
        // GUI setup
        setTitle("MySQL CRUD Example");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new FlowLayout());

        JButton addButton = new JButton("Add User");
        JButton displayButton = new JButton("Display Users");

        outputArea = new JTextArea(10, 30);
        outputArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(outputArea);

        add(addButton);
        add(displayButton);
        add(scrollPane);

        // Database connection details
        String url = "jdbc:mysql://localhost:3306/db";
        String user = "wizard"; 
        String password = "letmelogin123";

        // Add button action
        addButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try (Connection conn = DriverManager.getConnection(url, user, password);
                     Statement stmt = conn.createStatement()) {

                    stmt.executeUpdate("INSERT INTO users (name, email) VALUES ('Jane Doe', 'jane@example.com')");
                    outputArea.setText("Added new user: Jane Doe");

                } catch (Exception ex) {
                    outputArea.setText("Error: " + ex.getMessage());
                }
            }
        });

        // Display button action
        displayButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                try (Connection conn = DriverManager.getConnection(url, user, password);
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT * FROM users")) {

                    StringBuilder result = new StringBuilder("Users:\n");
                    while (rs.next()) {
                        result.append("ID: ").append(rs.getInt("id"))
                              .append(", Name: ").append(rs.getString("name"))
                              .append(", Email: ").append(rs.getString("email"))
                              .append("\n");
                    }
                    outputArea.setText(result.toString());

                } catch (Exception ex) {
                    outputArea.setText("Error: " + ex.getMessage());
                }
            }
        });
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            MySQLSwingExample frame = new MySQLSwingExample();
            frame.setVisible(true);
        });
    }
}
