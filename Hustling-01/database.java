import java.sql.*;

public class database {
    private Connection connectCompetitors() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/CompetitorDB", "wizard", "Banana4President");
    }
    private Connection connectQuiz() throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost:3306/QuizDB", "wizard", "Banana4President");
    }

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
}
