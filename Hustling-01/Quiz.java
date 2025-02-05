import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;

public class Quiz extends JFrame {
    private List<Question> questions;
    private ButtonGroup[] answerGroups; 
    private JRadioButton[][] radioButtons; 
    private int currentQuestionIndex = 0;
    private int score = 0; 

    public Quiz() {
        setTitle("Quiz");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(400, 300);
        setLocationRelativeTo(null); 
        setLayout(new BorderLayout());

        database database = new database();
        Questions questionsObj = database.getAllQuestions();
        questions = questionsObj.getQuestions();

        JPanel questionPanel = new JPanel();
        questionPanel.setLayout(new BoxLayout(questionPanel, BoxLayout.Y_AXIS));

        radioButtons = new JRadioButton[questions.size()][4];
        answerGroups = new ButtonGroup[questions.size()];

        for (int i = 0; i < questions.size(); i++) {
            Question question = questions.get(i);
            JPanel questionContainer = new JPanel();
            questionContainer.setLayout(new GridLayout(6, 1));  // Increase to 6 to fit the options

            questionContainer.add(new JLabel(question.question));

            ButtonGroup group = new ButtonGroup();
            answerGroups[i] = group;

            // Split the options string by commas to get the individual options
            String[] options = question.options.split(",");

            // Create a JRadioButton for each option (a, b, c, d)
            for (int j = 0; j < options.length; j++) {
                radioButtons[i][j] = new JRadioButton(options[j]);  // Just show the options without "(Correct)"
                group.add(radioButtons[i][j]);
                questionContainer.add(radioButtons[i][j]);
            }

            questionPanel.add(questionContainer);
        }

        JScrollPane scrollPane = new JScrollPane(questionPanel);
        add(scrollPane, BorderLayout.CENTER);

        JButton submitButton = new JButton("Submit");
        submitButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                score = 0; // Reset score before calculation
                for (int i = 0; i < questions.size(); i++) {
                    // Split options again for comparison
                    String[] options = questions.get(i).options.split(",");

                    // Compare selected answer with the correct one by index
                    for (int j = 0; j < options.length; j++) {
                        if (radioButtons[i][j].isSelected() && options[j].equals(questions.get(i).correctAnswer)) {
                            score++;  // Increment score for the correct answer
                        }
                    }
                }
                JOptionPane.showMessageDialog(Quiz.this, "You scored " + score + " out of " + questions.size());
                // Close the quiz window
                dispose();
            }
        });
        add(submitButton, BorderLayout.SOUTH);

        setVisible(true);
    }

    public int getScore() {
        return score; // Return the score after the quiz is submitted
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(new Runnable() {
            @Override
            public void run() {
                new Quiz();
            }
        });
    }
}
