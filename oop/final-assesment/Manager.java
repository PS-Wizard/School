import javax.swing.*;
import java.awt.*;
import backend.models.Competitor;
import backend.models.CompetitorList;
import backend.db.DB_API;
import frontend.WordGame;
import java.util.List;

public class Manager {
    private final String ADMIN_PASSWORD = "admin123";
    private DB_API database;

    public void createAndShowGUI() {
        this.database = new DB_API("jdbc:mysql://localhost:3306/JavaAssessment", "wizard", "Banana4President");
        JFrame frame = new JFrame("Manager");
        frame.setSize(500, 500);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setLayout(new GridLayout(4, 1, 10, 10));

        JButton playGameButton = new JButton("Play Game");
        JButton viewScoresButton = new JButton("View Scores");
        JButton adminViewButton = new JButton("Admin View");
        JButton quitButton = new JButton("Quit");

        playGameButton.addActionListener(e -> showGameInputDialog(frame));
        viewScoresButton.addActionListener(e -> showScores(frame));
        adminViewButton.addActionListener(e -> showAdminView(frame));
        quitButton.addActionListener(e -> frame.dispose());

        frame.add(playGameButton);
        frame.add(viewScoresButton);
        frame.add(adminViewButton);
        frame.add(quitButton);

        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
    }


    private void showAdminView(JFrame parent) {
        JPanel panel = new JPanel(new GridLayout(0, 2));

        JTextField idField = new JTextField();
        JTextField nameField = new JTextField();
        JTextField levelField = new JTextField();  // This field for Level
        JTextField ageField = new JTextField();
        JTextField scoreField = new JTextField();

        panel.add(new JLabel("ID:"));
        panel.add(idField);
        panel.add(new JLabel("Name:"));
        panel.add(nameField);
        panel.add(new JLabel("Level:"));  // Label for Level
        panel.add(levelField);  // Added the levelField
        panel.add(new JLabel("Age:"));
        panel.add(ageField);
        panel.add(new JLabel("Scores (comma separated):"));
        panel.add(scoreField);

        JButton createButton = new JButton("Create");
        createButton.addActionListener(e -> createCompetitor(idField, nameField, levelField, ageField, scoreField));

        JButton updateButton = new JButton("Update");
        updateButton.addActionListener(e -> updateCompetitor(idField, nameField, levelField, ageField, scoreField));

        JButton deleteButton = new JButton("Delete");
        deleteButton.addActionListener(e -> deleteCompetitor(idField));

        panel.add(createButton);
        panel.add(updateButton);
        panel.add(deleteButton);

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
        JPanel panel = new JPanel(new GridLayout(6, 2));

        JTextField idField = new JTextField();
        JTextField nameField = new JTextField();
        JTextField levelField = new JTextField();
        JTextField ageField = new JTextField();

        panel.add(new JLabel("ID:"));
        panel.add(idField);
        panel.add(new JLabel("Name:"));
        panel.add(nameField);
        panel.add(new JLabel("Level:"));
        panel.add(levelField);
        panel.add(new JLabel("Age:"));
        panel.add(ageField);

        ButtonGroup scoreGroup = new ButtonGroup();
        JPanel scorePanel = new JPanel(new GridLayout(1, 5));
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

        scorePanel.add(s1);
        scorePanel.add(s2);
        scorePanel.add(s3);
        scorePanel.add(s4);
        scorePanel.add(s5);

        panel.add(new JLabel("Select Score Round:"));
        panel.add(scorePanel);

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
        JScrollPane scrollPane = new JScrollPane(table);

        JFrame scoresFrame = new JFrame("Scores");
        scoresFrame.setSize(600, 400);
        scoresFrame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        scoresFrame.add(scrollPane, BorderLayout.CENTER);
        scoresFrame.setLocationRelativeTo(parent);
        scoresFrame.setVisible(true);
    }
}
