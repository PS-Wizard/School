import java.sql.*;

/**
 * Handles database operations for storing and retrieving competitor data and quiz questions.
 * Provides methods to connect to the competitor and quiz databases, and interact with them.
 */
public class database {

    /**
     * Connects to the Competitor database.
     * 
     * @return A connection to the Competitor database.
     * @throws SQLException if there is an error connecting to the database.
     */
    private Connection connectCompetitors() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/CompetitorDB", "wizard", "Banana4President");
    }

    /**
     * Connects to the Quiz database.
     * 
     * @return A connection to the Quiz database.
     * @throws SQLException if there is an error connecting to the database.
     */
    private Connection connectQuiz() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/QuizDB", "wizard", "Banana4President");
    }

    /**
     * Retrieves all competitor scores from the Competitor database.
     * 
     * @return A CompetitorList object containing all competitors and their scores.
     */
    public CompetitorList getScores() {
        CompetitorList list = new CompetitorList();
        try (Connection conn = connectCompetitors(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery("SELECT * FROM Competitors")) {
            while (rs.next()) {
                list.addCompetitor(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Stores a new competitor's scores and details into the Competitor database.
     * 
     * @param competitor The Competitor object containing the details to be saved.
     */
    public void setScores(Competitor competitor) {
        String sql = "INSERT INTO Competitors (Name, Age, Level, Score1, Score2, Score3, Score4, Score5) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = connectCompetitors(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, competitor.getName().getFirstName() + " " + competitor.getName().getLastName());
            pstmt.setInt(2, competitor.getAge());
            pstmt.setString(3, competitor.getLevel());
            int[] scores = competitor.getScores();
            for (int i = 0; i < scores.length; i++) {
                pstmt.setInt(i + 4, scores[i]);
            }
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Retrieves all quiz questions from the Quiz database.
     * 
     * @return A Questions object containing all quiz questions.
     */
    public Questions getAllQuestions() {
        Questions questions = null;
        try (Connection conn = connectQuiz();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM Questions")) {
            questions = new Questions(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return questions;
    }

    /**
     * Stores a new quiz question into the Quiz database.
     * 
     * @param q The Question object containing the details of the question to be added.
     */
    public void setQuestion(Question q) {
        String sql = "INSERT INTO Questions (Question, CorrectAnswer, Category, Options) VALUES (?, ?, ?, ?)";

        try (Connection conn = connectQuiz(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, q.question);
            pstmt.setString(2, q.correctAnswer);
            pstmt.setString(3, q.category);
            pstmt.setString(4, q.options);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
