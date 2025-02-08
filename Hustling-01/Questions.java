import java.sql.*;
import java.util.*;

/**
 * Represents a single quiz question, including the question text, correct answer,
 * category, and possible answer options.
 */
class Question {
    public String question;
    public String correctAnswer;
    public String category;
    public String options;

    /**
     * Constructs a new Question object.
     * 
     * @param question The text of the question.
     * @param correctAnswer The correct answer for the question.
     * @param category The category to which the question belongs.
     * @param options The available options for the question, as a comma-separated string.
     */
    public Question(String question, String correctAnswer, String category, String options) {
        this.question = question;
        this.correctAnswer = correctAnswer;
        this.category = category;
        this.options = options;
    }
}

/**
 * Holds a list of Question objects, representing all quiz questions loaded from
 * a ResultSet.
 */
public class Questions {
    private List<Question> questions;

    /**
     * Constructs a Questions object by parsing a ResultSet of quiz questions.
     * 
     * @param rs The ResultSet containing quiz question data.
     * @throws SQLException If there is an error accessing the ResultSet.
     */
    public Questions(ResultSet rs) throws SQLException {
        questions = new ArrayList<>();
        while (rs.next()) {
            String questionText = rs.getString("Question");
            String correctAnswer = rs.getString("CorrectAnswer");
            String category = rs.getString("Category");
            String options = rs.getString("Options");
            questions.add(new Question(questionText, correctAnswer, category, options));
        }
    }

    /**
     * Returns the list of questions.
     * 
     * @return A list of Question objects.
     */
    public List<Question> getQuestions() {
        return questions;
    }
}
