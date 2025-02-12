import javax.swing.*;
import java.awt.*;
import backend.models.Competitor;
import backend.models.CompetitorList;
import backend.db.DB_API;
import frontend.WordGame;
import java.io.File;
import javax.imageio.ImageIO;
import java.util.List;
import java.util.ArrayList;
import java.util.Comparator;

public class Manager {
    private final String ADMIN_PASSWORD = "admin123";
    private DB_API database;

    /**
     * Sets up and displays the main JFrame for the manager interface. 
     * The interface includes buttons for gameplay, viewing scores, admin view, 
     * and quitting the application.
     */
    public void createAndShowGUI() {
        this.database = new DB_API("jdbc:mysql://localhost:3306/JavaAssessment", "wizard", "Banana4President");
        JFrame frame = new JFrame("Manager");
        frame.setSize(500, 600); 
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLayout(new BorderLayout(10, 10));

        try {
            Image spaceshipImage = ImageIO.read(new File("./frontend/logo.png"));
            ImageIcon spaceshipIcon = new ImageIcon(spaceshipImage);
            JLabel imageLabel = new JLabel(spaceshipIcon);
            frame.add(imageLabel, BorderLayout.NORTH);
        } catch (Exception e) {
            e.printStackTrace();
        }

        JPanel buttonPanel = new JPanel(new GridLayout(4, 1, 10, 10));
        buttonPanel.setBorder(BorderFactory.createEmptyBorder(10, 20, 10, 20)); 

        JButton playGameButton = new JButton("Play Game");
        JButton viewScoresButton = new JButton("View Scores");
        JButton adminViewButton = new JButton("Admin View");
        JButton quitButton = new JButton("Quit");

        
        playGameButton.addActionListener(e -> showGameInputDialog(frame));
        viewScoresButton.addActionListener(e -> showScores(frame));
        adminViewButton.addActionListener(e -> showAdminView(frame));
        quitButton.addActionListener(e -> frame.dispose());

        buttonPanel.add(playGameButton);
        buttonPanel.add(viewScoresButton);
        buttonPanel.add(adminViewButton);
        buttonPanel.add(quitButton);

        frame.add(buttonPanel, BorderLayout.CENTER);

        frame.setLocationRelativeTo(null); 
        frame.setVisible(true);
    }


    /**
     * Displays a dialog where the admin can create, update, or delete a competitor's details.
     * The dialog includes input fields for competitor ID, name, level, age, and score.
     * 
     * @param parent The parent JFrame to attach the dialog to.
     */
    private void showAdminView(JFrame parent) {
        // Show a dialog for password input
        String enteredPassword = JOptionPane.showInputDialog(parent, "Enter Admin Password:");

        if (enteredPassword != null && enteredPassword.equals(ADMIN_PASSWORD)) {
            // Proceed to the admin view
            JPanel panel = new JPanel();
            panel.setLayout(new GridBagLayout());
            GridBagConstraints gbc = new GridBagConstraints();
            gbc.insets = new Insets(10, 10, 10, 10);  

            JTextField idField = new JTextField();
            JTextField nameField = new JTextField();
            JTextField levelField = new JTextField();
            JTextField ageField = new JTextField();
            JTextField scoreField = new JTextField();

            idField.setPreferredSize(new Dimension(200, 30));
            nameField.setPreferredSize(new Dimension(200, 30));
            levelField.setPreferredSize(new Dimension(200, 30));
            ageField.setPreferredSize(new Dimension(200, 30));
            scoreField.setPreferredSize(new Dimension(200, 30));

            gbc.gridx = 0;
            gbc.gridy = 0;
            panel.add(new JLabel("ID:"), gbc);
            gbc.gridx = 1;
            panel.add(idField, gbc);

            gbc.gridx = 0;
            gbc.gridy = 1;
            panel.add(new JLabel("Name:"), gbc);
            gbc.gridx = 1;
            panel.add(nameField, gbc);

            gbc.gridx = 0;
            gbc.gridy = 2;
            panel.add(new JLabel("Level:"), gbc);
            gbc.gridx = 1;
            panel.add(levelField, gbc);

            gbc.gridx = 0;
            gbc.gridy = 3;
            panel.add(new JLabel("Age:"), gbc);
            gbc.gridx = 1;
            panel.add(ageField, gbc);

            gbc.gridx = 0;
            gbc.gridy = 4;
            panel.add(new JLabel("Scores (comma separated):"), gbc);
            gbc.gridx = 1;
            panel.add(scoreField, gbc);

            JButton createButton = new JButton("Create Competitor");
            JButton updateButton = new JButton("Update Competitor");
            JButton deleteButton = new JButton("Delete Competitor");

            createButton.addActionListener(e -> createCompetitor(idField, nameField, levelField, ageField, scoreField));
            updateButton.addActionListener(e -> updateCompetitor(idField, nameField, levelField, ageField, scoreField));
            deleteButton.addActionListener(e -> deleteCompetitor(idField));

            JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 10));
            buttonPanel.add(createButton);
            buttonPanel.add(updateButton);
            buttonPanel.add(deleteButton);

            gbc.gridx = 0;
            gbc.gridy = 5;
            gbc.gridwidth = 2;
            panel.add(buttonPanel, gbc);

            JDialog adminDialog = new JDialog(parent, "Admin View", true);
            adminDialog.setLayout(new BorderLayout());
            adminDialog.add(panel, BorderLayout.CENTER);
            adminDialog.pack();
            adminDialog.setLocationRelativeTo(parent);
            adminDialog.setVisible(true);
        } else {
            JOptionPane.showMessageDialog(parent, "Incorrect password. Access denied.", "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    /**
     * Creates a new competitor by gathering input from the provided text fields 
     * and stores the new competitor in the database.
     * 
     * @param idField TextField for entering competitor's ID.
     * @param nameField TextField for entering competitor's name.
     * @param levelField TextField for entering competitor's level.
     * @param ageField TextField for entering competitor's age.
     * @param scoreField TextField for entering competitor's score.
     */
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


    /**
     * Updates the details of an existing competitor in the database using the competitor's ID.
     * 
     * @param idField TextField for entering the competitor's ID.
     * @param nameField TextField for entering the competitor's updated name.
     * @param levelField TextField for entering the competitor's updated level.
     * @param ageField TextField for entering the competitor's updated age.
     * @param scoreField TextField for entering the competitor's updated score.
     */
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


    /**
     * Deletes a competitor from the database based on the entered ID.
     * 
     * @param idField TextField for entering the ID of the competitor to delete.
     */
    private void deleteCompetitor(JTextField idField) {
        try {
            int id = Integer.parseInt(idField.getText());
            database.deleteCompetitor(id);  // Using the DB_API delete method
            JOptionPane.showMessageDialog(null, "Competitor Deleted Successfully!");
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(null, "Error deleting competitor: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }



    /**
     * Displays a dialog for entering game details, including competitor's ID, name, level, age, 
     * and score round, before starting the game.
     * 
     * @param parentFrame The parent JFrame to attach the dialog to.
     * @return A Competitor object with the entered details.
     */
    private void showGameInputDialog(JFrame parentFrame) {
        JPanel panel = new JPanel(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(10, 10, 10, 10);

        JTextField idField = new JTextField();
        JTextField nameField = new JTextField();
        JTextField levelField = new JTextField();
        JTextField ageField = new JTextField();

        idField.setPreferredSize(new Dimension(200, 30));
        nameField.setPreferredSize(new Dimension(200, 30));
        levelField.setPreferredSize(new Dimension(200, 30));
        ageField.setPreferredSize(new Dimension(200, 30));

        gbc.gridx = 0; gbc.gridy = 0;
        panel.add(new JLabel("ID:"), gbc);
        gbc.gridx = 1;
        panel.add(idField, gbc);

        gbc.gridx = 0; gbc.gridy = 1;
        panel.add(new JLabel("Full Name:"), gbc);
        gbc.gridx = 1;
        panel.add(nameField, gbc);

        gbc.gridx = 0; gbc.gridy = 2;
        panel.add(new JLabel("Level (Beginner/Intermediate/Expert):"), gbc);
        gbc.gridx = 1;
        panel.add(levelField, gbc);

        gbc.gridx = 0; gbc.gridy = 3;
        panel.add(new JLabel("Age (10-100):"), gbc);
        gbc.gridx = 1;
        panel.add(ageField, gbc);

        JPanel scorePanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 10));
        ButtonGroup scoreGroup = new ButtonGroup();
        JRadioButton s1 = new JRadioButton("S1");
        JRadioButton s2 = new JRadioButton("S2");
        JRadioButton s3 = new JRadioButton("S3");
        JRadioButton s4 = new JRadioButton("S4");
        JRadioButton s5 = new JRadioButton("S5");

        scoreGroup.add(s1); scoreGroup.add(s2); scoreGroup.add(s3);
        scoreGroup.add(s4); scoreGroup.add(s5);

        scorePanel.add(s1); scorePanel.add(s2); scorePanel.add(s3);
        scorePanel.add(s4); scorePanel.add(s5);

        gbc.gridx = 0; gbc.gridy = 4;
        panel.add(new JLabel("Select Score Round:"), gbc);
        gbc.gridx = 1;
        panel.add(scorePanel, gbc);

        while (true) {
            int result = JOptionPane.showConfirmDialog(null, panel, "Enter Game Details", JOptionPane.OK_CANCEL_OPTION);
            if (result != JOptionPane.OK_OPTION) return; // Exit if cancelled

            String id = idField.getText().trim();
            String name = nameField.getText().trim();
            String level = levelField.getText().trim();
            String ageText = ageField.getText().trim();

            // Full Name Validation
            if (!name.matches("^[A-Za-z]+\\s[A-Za-z]+$")) {
                JOptionPane.showMessageDialog(null, "Enter a valid full name (First Last).", "Input Error", JOptionPane.ERROR_MESSAGE);
                continue;
            }

            // Age Validation
            int age;
            try {
                age = Integer.parseInt(ageText);
                if (age < 10 || age > 100) throw new NumberFormatException();
            } catch (NumberFormatException e) {
                JOptionPane.showMessageDialog(null, "Enter a valid age (10-100).", "Input Error", JOptionPane.ERROR_MESSAGE);
                continue;
            }

            // Level Validation
            if (!level.equalsIgnoreCase("Beginner") && 
                    !level.equalsIgnoreCase("Intermediate") && 
                    !level.equalsIgnoreCase("Expert")) {
                JOptionPane.showMessageDialog(null, "Level must be Beginner, Intermediate, or Expert.", "Input Error", JOptionPane.ERROR_MESSAGE);
                continue;
                    }

            // Score Selection
            String selectedScore = "None";
            if (s1.isSelected()) selectedScore = "S1";
            if (s2.isSelected()) selectedScore = "S2";
            if (s3.isSelected()) selectedScore = "S3";
            if (s4.isSelected()) selectedScore = "S4";
            if (s5.isSelected()) selectedScore = "S5";

            Competitor comp = new Competitor(name, Integer.parseInt(id), level, age, new int[5]);
            startWordGame(parentFrame, comp, selectedScore);
            break;
        }
    }

    /**
     * Starts the word game dialog with the provided competitor and selected score.
     * 
     * @param parentFrame The parent JFrame for the word game dialog.
     * @param comp The Competitor object to start the game with.
     * @param selectedScore The score selected for the game.
     */
    private void startWordGame(JFrame parentFrame, Competitor comp, String selectedScore) {
        JDialog gameDialog = new JDialog(parentFrame, "Word Game - Meteor Strike", false);
        WordGame game = new WordGame(comp, selectedScore);
        gameDialog.setLayout(new BorderLayout());
        gameDialog.add(game, BorderLayout.CENTER);
        gameDialog.pack();
        gameDialog.setLocationRelativeTo(parentFrame);
        gameDialog.setVisible(true);
    }



    /**
     * Retrieves and displays the list of competitors' scores, categorized by their levels 
     * (Beginner, Intermediate, Expert). The scores are sorted in descending order 
     * before being displayed in a JTable.
     * 
     * @param parent The parent JFrame to attach the scores dialog to.
     */
    private void showScores(JFrame parent) {
        CompetitorList competitorsList = new CompetitorList();
        database.getAllCompetitors(competitorsList);

        List<Competitor> competitors = competitorsList.getAllCompetitors();

        // Separate competitors by level
        List<Competitor> beginners = new ArrayList<>();
        List<Competitor> intermediates = new ArrayList<>();
        List<Competitor> experts = new ArrayList<>();

        for (Competitor competitor : competitors) {
            switch (competitor.getLevel()) {
                case "Beginner":
                    beginners.add(competitor);
                    break;
                case "Intermediate":
                    intermediates.add(competitor);
                    break;
                case "Expert":
                    experts.add(competitor);
                    break;
            }
        }

        // Sort each list alphabetically by name
        beginners.sort(Comparator.comparing(c -> c.getName().getFullName()));
        intermediates.sort(Comparator.comparing(c -> c.getName().getFullName()));
        experts.sort(Comparator.comparing(c -> c.getName().getFullName()));

        // Create data for the tables
        Object[][] beginnerData = createTableData(beginners);
        Object[][] intermediateData = createTableData(intermediates);
        Object[][] expertData = createTableData(experts);

        // Column names for the tables
        String[] columnNames = {"CompetitorID", "Name", "Level", "Age", "Score1", "Score2", "Score3", "Score4", "Score5"};

        // Create tables for each level
        JTable beginnerTable = createTable(beginnerData, columnNames);
        JTable intermediateTable = createTable(intermediateData, columnNames);
        JTable expertTable = createTable(expertData, columnNames);

        // Layout for the tables
        JPanel tablePanel = new JPanel();
        tablePanel.setLayout(new BoxLayout(tablePanel, BoxLayout.Y_AXIS));

        JPanel beginnerPanel = createTablePanel("Beginner", beginnerTable);
        JPanel intermediatePanel = createTablePanel("Intermediate", intermediateTable);
        JPanel expertPanel = createTablePanel("Expert", expertTable);

        tablePanel.add(beginnerPanel);
        tablePanel.add(Box.createVerticalStrut(20));  
        tablePanel.add(intermediatePanel);
        tablePanel.add(Box.createVerticalStrut(20));
        tablePanel.add(expertPanel);


        JPanel buttonPanel = new JPanel();
        buttonPanel.setLayout(new FlowLayout(FlowLayout.CENTER, 20, 10));
        JButton fullDetailsButton = new JButton("Get Full Details");
        JButton shortDetailsButton = new JButton("Get Short Details");
        buttonPanel.add(fullDetailsButton);
        buttonPanel.add(shortDetailsButton);
        fullDetailsButton.addActionListener(e -> {
            StringBuilder fullDetails = new StringBuilder();
            for (Competitor competitor : competitors) {
                fullDetails.append(competitor.getFullDetails()).append("\n");
            }
            JOptionPane.showMessageDialog(parent, fullDetails.toString(), "Full Details", JOptionPane.INFORMATION_MESSAGE);
        });

        shortDetailsButton.addActionListener(e -> {
            StringBuilder shortDetails = new StringBuilder();
            for (Competitor competitor : competitors) {
                shortDetails.append(competitor.getShortDetails()).append("\n");
            }
            JOptionPane.showMessageDialog(parent, shortDetails.toString(), "Short Details", JOptionPane.INFORMATION_MESSAGE);
        });

        JFrame scoresFrame = new JFrame("Scores");
        scoresFrame.setSize(1000, 600);
        scoresFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        scoresFrame.setLayout(new BorderLayout(20, 20));

        JPanel mainPanel = new JPanel();
        mainPanel.setLayout(new BorderLayout(20, 20));
        mainPanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        mainPanel.add(tablePanel, BorderLayout.CENTER);
        mainPanel.add(buttonPanel, BorderLayout.SOUTH);

        scoresFrame.setContentPane(mainPanel);
        scoresFrame.setLocationRelativeTo(parent);
        scoresFrame.setVisible(true);
    }

    /**
     * Converts a list of competitors into a 2D array for table display. 
     * This method formats the score for each competitor before returning the data.
     * 
     * @param competitors The list of competitors to display.
     * @return A 2D array of data for JTable display.
     */
    private Object[][] createTableData(List<Competitor> competitors) {
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
        return data;
    }

    /**
     * Creates a JTable using the provided data and column names. 
     * The table is designed to display competitors' scores and other details.
     * 
     * @param data The 2D array of data to display in the table.
     * @param columnNames The column names for the table.
     * @return The JTable for displaying data.
     */
    private JTable createTable(Object[][] data, String[] columnNames) {
        JTable table = new JTable(data, columnNames);
        table.setEnabled(false);
        table.setRowHeight(40);
        table.setIntercellSpacing(new java.awt.Dimension(20, 20));
        table.setPreferredScrollableViewportSize(new java.awt.Dimension(900, 300));
        return table;
    }


    private JPanel createTablePanel(String title, JTable table) {
        JPanel panel = new JPanel();
        panel.setLayout(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createTitledBorder(title));

        JScrollPane scrollPane = new JScrollPane(table);
        panel.add(scrollPane, BorderLayout.CENTER);

        return panel;
    }
}
