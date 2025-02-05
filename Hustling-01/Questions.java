import java.sql.*;
import java.util.*;

class Question {
    public String question;
    public String correctAnswer; 
    public String category;
    public String options;

    public Question(String question, String correctAnswer, String category,String options) {
        this.question = question;
        this.correctAnswer = correctAnswer;
        this.category = category;
        this.options = options;
    }
}

public class Questions {
    private List<Question> questions;

    public Questions(ResultSet rs) throws SQLException {
        questions = new ArrayList<>();
        while (rs.next()) {
            String questionText = rs.getString("Question");
            String correctAnswer = rs.getString("CorrectAnswer");
            String category = rs.getString("Category");
            String options = rs.getString("Options");
            questions.add(new Question(questionText, correctAnswer, category,options));
        }
    }

    public List<Question> getQuestions() {
        return questions;
    }
}

