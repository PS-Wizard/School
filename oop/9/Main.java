import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.sql.*;

public class Main {
    static final String URL = "jdbc:mysql://localhost:3306/jdbc"; 
    static final String USERNAME = "wizard";
    static final String PASSWORD = "godly123";
    
    static Connection connection = null;

    public static void main(String[] args) {
        JFrame frame = new JFrame("CRUD Operations");
        frame.setLayout(new FlowLayout());
        frame.setSize(400, 400);

        
        JLabel idLabel = new JLabel("ID");
        JTextField idField = new JTextField(20);
        JLabel nameLabel = new JLabel("Name");
        JTextField nameField = new JTextField(20);
        JLabel ageLabel = new JLabel("Age");
        JTextField ageField = new JTextField(20);
        JLabel phoneLabel = new JLabel("Phone");
        JTextField phoneField = new JTextField(20);
        JLabel emailLabel = new JLabel("Email");
        JTextField emailField = new JTextField(20);

        
        JButton createButton = new JButton("Create");
        JButton deleteButton = new JButton("Delete");
        JButton readButton = new JButton("Read");

        
        frame.add(idLabel);
        frame.add(idField);
        frame.add(nameLabel);
        frame.add(nameField);
        frame.add(ageLabel);
        frame.add(ageField);
        frame.add(phoneLabel);
        frame.add(phoneField);
        frame.add(emailLabel);
        frame.add(emailField);
        frame.add(createButton);
        frame.add(deleteButton);
        frame.add(readButton);

        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);

        
        try {
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("Connected to the database!");

            
            createButton.addActionListener(e -> {
                String name = nameField.getText();
                int age = Integer.parseInt(ageField.getText());
                String phone = phoneField.getText();
                String email = emailField.getText();

                String query = "INSERT INTO users (name, age, phone, email) VALUES (?, ?, ?, ?)";

                try (PreparedStatement stmt = connection.prepareStatement(query)) {
                    stmt.setString(1, name);
                    stmt.setInt(2, age);
                    stmt.setString(3, phone);
                    stmt.setString(4, email);
                    stmt.executeUpdate();
                    JOptionPane.showMessageDialog(frame, "Record Created!");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            });

            
            deleteButton.addActionListener(e -> {
                String id = idField.getText();
                String query = "DELETE FROM users WHERE id = ?";

                try (PreparedStatement stmt = connection.prepareStatement(query)) {
                    stmt.setString(1, id);
                    stmt.executeUpdate();
                    JOptionPane.showMessageDialog(frame, "Record Deleted!");
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            });

            readButton.addActionListener(e -> {
                String id = idField.getText();
                String query = "SELECT * FROM users WHERE id = ?";

                try (PreparedStatement stmt = connection.prepareStatement(query)) {
                    stmt.setString(1, id);
                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        System.out.println("ID: " + rs.getInt("id"));
                        System.out.println("Name: " + rs.getString("name"));
                        System.out.println("Age: " + rs.getInt("age"));
                        System.out.println("Phone: " + rs.getString("phone"));
                        System.out.println("Email: " + rs.getString("email"));
                    } else {
                        System.out.println("No record found with that ID.");
                    }
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            });

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
