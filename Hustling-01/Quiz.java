import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.List;
import javax.swing.*;
import java.sql.*;

/**
 * Represents a simple quiz game using a dialog window.
 */
public class Quiz extends JDialog {
    private List<Question> questions;
    private int currentQuestionIndex = 0;
    private int score = 0;
    private JLabel questionLabel;
    private JRadioButton[] optionButtons;
    private ButtonGroup group;
    private JButton nextButton;

    /**
     * Constructs a Quiz dialog with a list of questions.
     * 
     * @param questions The {@link Questions} object containing the quiz questions.
     */
    public Quiz(Questions questions) {
        this.questions = questions.getQuestions();
        
        setTitle("Quiz Game");
        setSize(500, 300);
        setModal(true); // This makes the quiz block execution until it closes
        setLayout(new BorderLayout());
        
        questionLabel = new JLabel("", SwingConstants.CENTER);
        add(questionLabel, BorderLayout.NORTH);
        
        JPanel optionsPanel = new JPanel();
        optionsPanel.setLayout(new GridLayout(4, 1));
        optionButtons = new JRadioButton[4];
        group = new ButtonGroup();
        
        for (int i = 0; i < 4; i++) {
            optionButtons[i] = new JRadioButton();
            group.add(optionButtons[i]);
            optionsPanel.add(optionButtons[i]);
        }
        add(optionsPanel, BorderLayout.CENTER);
        
        nextButton = new JButton("Next");

        nextButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                checkAnswer();
                currentQuestionIndex++;
                if (currentQuestionIndex < questions.getQuestions().size()) {
                    loadQuestion();
                } else {
                    JOptionPane.showMessageDialog(null, "Quiz Over! Your score: " + score);
                    dispose(); // Close the quiz properly
                }
            }
        });
        add(nextButton, BorderLayout.SOUTH);
        
        loadQuestion();
        setVisible(true);
    }

    /**
     * Loads the current question and its answer choices into the UI.
     */
    private void loadQuestion() {
        Question q = questions.get(currentQuestionIndex);
        questionLabel.setText(q.question);
        String[] options = q.options.split(",");
        for (int i = 0; i < 4; i++) {
            optionButtons[i].setText(options[i]);
            optionButtons[i].setSelected(false);
        }
    }

    /**
     * Checks the selected answer against the correct answer and updates the score.
     */
    private void checkAnswer() {
        if (currentQuestionIndex >= questions.size()) return;
        String correctAnswer = questions.get(currentQuestionIndex).correctAnswer;
        char correctOption = correctAnswer.charAt(0);
        if (optionButtons[correctOption - 'a'].isSelected()) {
            score++;
        }
    }

    /**
     * Gets the final score after the quiz is completed.
     * 
     * @return The final score of the quiz.
     */
    public int getFinalScore() {
        return score;
    }
}
