package backend.db;

import backend.models.*;
import java.sql.*;

/**
 * Handles database operations related to competitors and questions.
 */
public class DB_API {
    private String URL;
    private String USER;
    private String password;

    public DB_API(String url, String user, String password) {
        this.URL = url;
        this.USER = user;
        this.password = password;
    }
    // To Clear Competitor Only For Test
    public void clearCompetitorTable() {
        String sql = "DELETE FROM Competitors";
        try (Connection conn = DriverManager.getConnection(URL, USER, password);
                Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateAdminView(Competitor comp) {
        String name = comp.getName().getFullName();
        String level = comp.getLevel();
        int[] scores = comp.getScores();
        int age = comp.getAge();
        int id = comp.getCompetitorID();

        int[] filledScores = new int[5];
        for (int i = 0; i < scores.length && i < 5; i++) {
            filledScores[i] = (scores[i] != 0) ? scores[i] : -69;
        }

        String sql = "INSERT INTO Competitors (CompetitorID, name, level, age, score1, score2, score3, score4, score5) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) " +
            "ON DUPLICATE KEY UPDATE " +
            "name = VALUES(name), " +
            "level = VALUES(level), " +
            "age = VALUES(age), " +
            "score1 = VALUES(score1)," +
            "score2 = VALUES(score2)," +
            "score3 = VALUES(score3)," +
            "score4 = VALUES(score4)," +
            "score5 = VALUES(score5)";

        try (Connection conn = DriverManager.getConnection(URL, USER, password);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setString(2, name);
            ps.setString(3, level);
            ps.setInt(4, age);
            ps.setInt(5, filledScores[0]);
            ps.setInt(6, filledScores[1]);
            ps.setInt(7, filledScores[2]);
            ps.setInt(8, filledScores[3]);
            ps.setInt(9, filledScores[4]);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Create or Update Competitor
    public void store(Competitor comp) {
        String name = comp.getName().getFullName();
        String level = comp.getLevel();
        int[] scores = comp.getScores();
        int age = comp.getAge();
        int id = comp.getCompetitorID();

        int[] filledScores = new int[5];
        for (int i = 0; i < scores.length && i < 5; i++) {
            filledScores[i] = (scores[i] != 0) ? scores[i] : -69;
        }

        String sql = "INSERT INTO Competitors (CompetitorID, name, level, age, score1, score2, score3, score4, score5) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) " +
            "ON DUPLICATE KEY UPDATE " +
            "name = VALUES(name), " +
            "level = VALUES(level), " +
            "age = VALUES(age), " +
            "score1 = CASE WHEN score1 = -69 THEN VALUES(score1) ELSE score1 END, " +
            "score2 = CASE WHEN score2 = -69 THEN VALUES(score2) ELSE score2 END, " +
            "score3 = CASE WHEN score3 = -69 THEN VALUES(score3) ELSE score3 END, " +
            "score4 = CASE WHEN score4 = -69 THEN VALUES(score4) ELSE score4 END, " +
            "score5 = CASE WHEN score5 = -69 THEN VALUES(score5) ELSE score5 END";

        try (Connection conn = DriverManager.getConnection(URL, USER, password);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.setString(2, name);
            ps.setString(3, level);
            ps.setInt(4, age);
            ps.setInt(5, filledScores[0]);
            ps.setInt(6, filledScores[1]);
            ps.setInt(7, filledScores[2]);
            ps.setInt(8, filledScores[3]);
            ps.setInt(9, filledScores[4]);

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Delete Competitor by ID
    public void deleteCompetitor(int competitorID) {
        String sql = "DELETE FROM Competitors WHERE CompetitorID = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, password);
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, competitorID);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get Competitor by ID (for Update)
    public Competitor getCompetitorById(int competitorID) {
        Competitor comp = null;
        String sql = "SELECT * FROM Competitors WHERE CompetitorID = ?";

        try (Connection conn = DriverManager.getConnection(URL, USER, password);
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, competitorID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Populate the Competitor object
                comp = new Competitor(
                    rs.getString("name"),
                    rs.getInt("CompetitorID"),
                    rs.getString("level"),
                    rs.getInt("age"),
                    new int[] {
                        rs.getInt("score1"),
                        rs.getInt("score2"),
                        rs.getInt("score3"),
                        rs.getInt("score4"),
                        rs.getInt("score5")
                    }
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return comp;
    }

    // Get all competitors
    public void getAllCompetitors(CompetitorList competitorList) {
        String query = "SELECT * FROM Competitors";

        try (Connection conn = DriverManager.getConnection(URL, USER, password);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                competitorList.addCompetitor(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

