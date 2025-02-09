import javax.swing.*;
import java.awt.*;
import backend.models.Competitor;
import backend.models.CompetitorList;
import backend.db.DB_API;
import frontend.WordGame;
import java.io.File;
import javax.imageio.ImageIO;
import java.util.List;

public class Manager {
    private final String ADMIN_PASSWORD = "admin123";
    private DB_API database;

    public void createAndShowGUI() {
        this.database = new DB_API("jdbc:mysql://localhost:3306/JavaAssessment", "wizard", "Banana4President");
        JFrame frame = new JFrame("Manager");
        frame.setSize(500, 600); // Adjusted for image and buttons
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLayout(new BorderLayout(10, 10));

        // Add image at the top
        try {
            Image spaceshipImage = ImageIO.read(new File("./frontend/logo.png"));
            ImageIcon spaceshipIcon = new ImageIcon(spaceshipImage);
            JLabel imageLabel = new JLabel(spaceshipIcon);
            frame.add(imageLabel, BorderLayout.NORTH);
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Button panel with padding
        JPanel buttonPanel = new JPanel(new GridLayout(4, 1, 10, 10));
        buttonPanel.setBorder(BorderFactory.createEmptyBorder(10, 20, 10, 20)); // Padding around buttons

        JButton playGameButton = new JButton("Play Game");
        JButton viewScoresButton = new JButton("View Scores");
        JButton adminViewButton = new JButton("Admin View");
        JButton quitButton = new JButton("Quit");

        // Add action listeners
        playGameButton.addActionListener(e -> showGameInputDialog(frame));
        viewScoresButton.addActionListener(e -> showScores(frame));
        adminViewButton.addActionListener(e -> showAdminView(frame));
        quitButton.addActionListener(e -> frame.dispose());

        // Add buttons to the panel
        buttonPanel.add(playGameButton);
        buttonPanel.add(viewScoresButton);
        buttonPanel.add(adminViewButton);
        buttonPanel.add(quitButton);

        // Add button panel to the center
        frame.add(buttonPanel, BorderLayout.CENTER);

        frame.setLocationRelativeTo(null); // Center the frame
        frame.setVisible(true);
    }




    private void showAdminView(JFrame parent) {
        // Create main panel with a GridBagLayout for better control over component placement
        JPanel panel = new JPanel();
        panel.setLayout(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(10, 10, 10, 10);  // Add padding between components

        // Create text fields and set their preferred size
        JTextField idField = new JTextField();
        JTextField nameField = new JTextField();
        JTextField levelField = new JTextField();
        JTextField ageField = new JTextField();
        JTextField scoreField = new JTextField();

        // Set preferred size for better visibility
        idField.setPreferredSize(new Dimension(200, 30));
        nameField.setPreferredSize(new Dimension(200, 30));
        levelField.setPreferredSize(new Dimension(200, 30));
        ageField.setPreferredSize(new Dimension(200, 30));
        scoreField.setPreferredSize(new Dimension(200, 30));

        // Add ID field
        gbc.gridx = 0;
        gbc.gridy = 0;
        panel.add(new JLabel("ID:"), gbc);
        gbc.gridx = 1;
        panel.add(idField, gbc);

        // Add Name field
        gbc.gridx = 0;
        gbc.gridy = 1;
        panel.add(new JLabel("Name:"), gbc);
        gbc.gridx = 1;
        panel.add(nameField, gbc);

        // Add Level field
        gbc.gridx = 0;
        gbc.gridy = 2;
        panel.add(new JLabel("Level:"), gbc);
        gbc.gridx = 1;
        panel.add(levelField, gbc);

        // Add Age field
        gbc.gridx = 0;
        gbc.gridy = 3;
        panel.add(new JLabel("Age:"), gbc);
        gbc.gridx = 1;
        panel.add(ageField, gbc);

        // Add Scores field
        gbc.gridx = 0;
        gbc.gridy = 4;
        panel.add(new JLabel("Scores (comma separated):"), gbc);
        gbc.gridx = 1;
        panel.add(scoreField, gbc);

        // Create button panel for alignment of buttons
        JPanel buttonPanel = new JPanel();
        buttonPanel.setLayout(new FlowLayout(FlowLayout.CENTER, 20, 10));  // Buttons centered with spacing

        // Create, Update, and Delete buttons
        JButton createButton = new JButton("Create");
        createButton.addActionListener(e -> createCompetitor(idField, nameField, levelField, ageField, scoreField));

        JButton updateButton = new JButton("Update");
        updateButton.addActionListener(e -> updateCompetitor(idField, nameField, levelField, ageField, scoreField));

        JButton deleteButton = new JButton("Delete");
        deleteButton.addActionListener(e -> deleteCompetitor(idField));

        // Add buttons to the button panel
        buttonPanel.add(createButton);
        buttonPanel.add(updateButton);
        buttonPanel.add(deleteButton);

        // Add button panel to main panel
        gbc.gridx = 0;
        gbc.gridy = 5;
        gbc.gridwidth = 2; // Make buttons span the entire width
        panel.add(buttonPanel, gbc);

        // Show the dialog
        int result = JOptionPane.showConfirmDialog(null, panel, "Admin View - Manage Competitors", JOptionPane.OK_CANCEL_OPTION);

        if (result == JOptionPane.OK_OPTION) {
            // You can add further validation or actions here
        }
    }

    private void createCompetitor(JTextField idField, JTextField nameField, JTextField levelField, JTextField ageField, JTextField scoreField) {
        try {
            int id = Integer.parseInt(idField.getText());
            String name = nameField.getText();
            String level = levelField.getText();
            int age = Integer.parseInt(ageField.getText());
            String[] scoreStrings = scoreField.getText().split(",");
            int[] scores = new int[5];
            for (int i = 0; i < scoreStrings.length; i++) {
                scores[i] = Integer.parseInt(scoreStrings[i].trim());
            }

            Competitor comp = new Competitor(name, id, level, age, scores);
            database.store(comp);
            JOptionPane.showMessageDialog(null, "Competitor Created Successfully!");
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(null, "Error creating competitor: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void updateCompetitor(JTextField idField, JTextField nameField, JTextField levelField, JTextField ageField, JTextField scoreField) {
        try {
            int id = Integer.parseInt(idField.getText());
            String name = nameField.getText();
            String level = levelField.getText();
            int age = Integer.parseInt(ageField.getText());
            String[] scoreStrings = scoreField.getText().split(",");
            int[] scores = new int[5];
            for (int i = 0; i < scoreStrings.length; i++) {
                scores[i] = Integer.parseInt(scoreStrings[i].trim());
            }

            Competitor comp = new Competitor(name, id, level, age, scores);
            database.updateAdminView(comp); // Store will update if the ID exists
            JOptionPane.showMessageDialog(null, "Competitor Updated Successfully!");
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(null, "Error updating competitor: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }


    private void deleteCompetitor(JTextField idField) {
        try {
            int id = Integer.parseInt(idField.getText());
            database.deleteCompetitor(id);  // Using the DB_API delete method
            JOptionPane.showMessageDialog(null, "Competitor Deleted Successfully!");
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(null, "Error deleting competitor: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }


    private void showGameInputDialog(JFrame parentFrame) {
        // Create main panel with a GridBagLayout for better control
        JPanel panel = new JPanel();
        panel.setLayout(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(10, 10, 10, 10);  // Add padding between components

        // Create text fields and set preferred size
        JTextField idField = new JTextField();
        JTextField nameField = new JTextField();
        JTextField levelField = new JTextField();
        JTextField ageField = new JTextField();

        // Set preferred size for better visibility
        idField.setPreferredSize(new Dimension(200, 30));
        nameField.setPreferredSize(new Dimension(200, 30));
        levelField.setPreferredSize(new Dimension(200, 30));
        ageField.setPreferredSize(new Dimension(200, 30));

        // Add ID field
        gbc.gridx = 0;
        gbc.gridy = 0;
        panel.add(new JLabel("ID:"), gbc);
        gbc.gridx = 1;
        panel.add(idField, gbc);

        // Add Name field
        gbc.gridx = 0;
        gbc.gridy = 1;
        panel.add(new JLabel("Name:"), gbc);
        gbc.gridx = 1;
        panel.add(nameField, gbc);

        // Add Level field
        gbc.gridx = 0;
        gbc.gridy = 2;
        panel.add(new JLabel("Level:"), gbc);
        gbc.gridx = 1;
        panel.add(levelField, gbc);

        // Add Age field
        gbc.gridx = 0;
        gbc.gridy = 3;
        panel.add(new JLabel("Age:"), gbc);
        gbc.gridx = 1;
        panel.add(ageField, gbc);

        // Create a panel for score options with a more spaced-out layout
        JPanel scorePanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 10)); // Space between radio buttons
        ButtonGroup scoreGroup = new ButtonGroup();

        JRadioButton s1 = new JRadioButton("S1");
        JRadioButton s2 = new JRadioButton("S2");
        JRadioButton s3 = new JRadioButton("S3");
        JRadioButton s4 = new JRadioButton("S4");
        JRadioButton s5 = new JRadioButton("S5");

        scoreGroup.add(s1);
        scoreGroup.add(s2);
        scoreGroup.add(s3);
        scoreGroup.add(s4);
        scoreGroup.add(s5);

        // Add radio buttons to scorePanel
        scorePanel.add(s1);
        scorePanel.add(s2);
        scorePanel.add(s3);
        scorePanel.add(s4);
        scorePanel.add(s5);

        // Add score selection to the panel
        gbc.gridx = 0;
        gbc.gridy = 4;
        panel.add(new JLabel("Select Score Round:"), gbc);
        gbc.gridx = 1;
        panel.add(scorePanel, gbc);

        // Show the dialog
        int result = JOptionPane.showConfirmDialog(null, panel, "Enter Game Details", JOptionPane.OK_CANCEL_OPTION);

        if (result == JOptionPane.OK_OPTION) {
            String id = idField.getText();
            String name = nameField.getText();
            String level = levelField.getText();
            String age = ageField.getText();

            String selectedScore = "None";
            if (s1.isSelected()) selectedScore = "S1";
            if (s2.isSelected()) selectedScore = "S2";
            if (s3.isSelected()) selectedScore = "S3";
            if (s4.isSelected()) selectedScore = "S4";
            if (s5.isSelected()) selectedScore = "S5";

            // Create a Competitor object and start the game
            Competitor comp = new Competitor(name, Integer.parseInt(id), level, Integer.parseInt(age), new int[5]);
            startWordGame(parentFrame, comp, selectedScore);
        }
    }

    private void startWordGame(JFrame parentFrame, Competitor comp, String selectedScore) {
        JDialog gameDialog = new JDialog(parentFrame, "Word Game - Meteor Strike", false);
        WordGame game = new WordGame(comp, selectedScore);
        gameDialog.setLayout(new BorderLayout());
        gameDialog.add(game, BorderLayout.CENTER);
        gameDialog.pack();
        gameDialog.setLocationRelativeTo(parentFrame);
        gameDialog.setVisible(true);
    }

    private void showScores(JFrame parent) {
        CompetitorList competitorsList = new CompetitorList();
        database.getAllCompetitors(competitorsList);

        List<Competitor> competitors = competitorsList.getAllCompetitors();
        Object[][] data = new Object[competitors.size()][9];

        for (int i = 0; i < competitors.size(); i++) {
            Competitor competitor = competitors.get(i);
            data[i][0] = competitor.getCompetitorID();
            data[i][1] = competitor.getName().getFullName();
            data[i][2] = competitor.getLevel();
            data[i][3] = competitor.getAge();

            for (int j = 0; j < 5; j++) {
                int score = competitor.getScores()[j];
                data[i][j + 4] = (score == -69) ? "-" : score;
            }
        }

        String[] columnNames = {"CompetitorID", "Name", "Level", "Age", "Score1", "Score2", "Score3", "Score4", "Score5"};
        JTable table = new JTable(data, columnNames);
        table.setEnabled(false);

        // Increase the row height
        table.setRowHeight(40);

        // Add padding between cells
        table.setIntercellSpacing(new java.awt.Dimension(20, 20));

        // Adjust column width (to avoid squishing)
        table.getColumnModel().getColumn(0).setPreferredWidth(100);  // CompetitorID column
        table.getColumnModel().getColumn(1).setPreferredWidth(200);  // Name column
        table.getColumnModel().getColumn(2).setPreferredWidth(100);  // Level column
        table.getColumnModel().getColumn(3).setPreferredWidth(100);  // Age column
        for (int i = 4; i < 9; i++) {
            table.getColumnModel().getColumn(i).setPreferredWidth(70);  // Score columns
        }

        // Create a JPanel to hold the JTable and add padding around it
        JPanel tablePanel = new JPanel();
        tablePanel.setLayout(new BorderLayout(10, 10)); // Added padding here
        JScrollPane scrollPane = new JScrollPane(table);
        scrollPane.setPreferredSize(new Dimension(900, 300));
        tablePanel.add(scrollPane, BorderLayout.CENTER);

        // Create a JPanel for displaying competitor details with padding
        JPanel detailsPanel = new JPanel();
        detailsPanel.setLayout(new BoxLayout(detailsPanel, BoxLayout.Y_AXIS));
        detailsPanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10)); // Padding for the details panel

        // Add the full details for each competitor with padding between labels
        for (Competitor competitor : competitors) {
            JLabel detailsLabel = new JLabel(competitor.getFullDetails());
            detailsLabel.setBorder(BorderFactory.createEmptyBorder(5, 0, 5, 0)); // Space between details labels
            detailsPanel.add(detailsLabel);
        }

        // Create the scores window
        JFrame scoresFrame = new JFrame("Scores");
        scoresFrame.setSize(1000, 500); // Increased window size
        scoresFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        scoresFrame.setLayout(new BorderLayout(20, 20)); // Added more space between components

        // Add margin around the window by setting a border for the main panel
        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new BorderLayout(20, 20)); // Adding space inside the frame
        mainPanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10)); // Padding around the entire window

        mainPanel.add(tablePanel, BorderLayout.CENTER);  // Add table panel with padding
        mainPanel.add(detailsPanel, BorderLayout.SOUTH); // Add details panel beneath the table

        // Set padding around the window
        scoresFrame.setContentPane(mainPanel);
        scoresFrame.setLocationRelativeTo(parent);
        scoresFrame.setVisible(true);
    }
}
