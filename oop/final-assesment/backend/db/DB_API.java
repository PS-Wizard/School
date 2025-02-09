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

    /**
     * Constructor for DB_API class.
     *
     * @param url The database URL.
     * @param user The username to connect to the database.
     * @param password The password to connect to the database.
     */
    public DB_API(String url, String user, String password){
        this.URL = url;
        this.USER = user;
        this.password = password;
    }

    /**
     * Clears all rows in the competitors table.
     */
    public void clearCompetitorTable() {
        String sql = "DELETE FROM Competitors";
        try (Connection conn = DriverManager.getConnection(URL, USER, password);
                Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    /**
     * Stores a Competitor's data in the database.
     *
     * @param comp The Competitor object to store.
     */
    public void store(Competitor comp){
        String name = comp.getName().getFullName();
        String level = comp.getLevel();
        int[] scores = comp.getScores();
        int age = comp.getAge();
        int id = comp.getCompetitorID();

        int[] filledScores = new int[5];

        // Fill the scores, use -69 for missing values
        for (int i = 0; i < scores.length && i < 5; i++) {
            // Only replace missing values with -69, leave valid ones as is
            filledScores[i] = (scores[i] != 0) ? scores[i] : -69;
        }

        System.out.println("DB_API: Storing");
        System.out.println(String.format("%s %s %d %d ", name, level, age, id));
        System.out.println(scores);

        // SQL Insert or Update Query
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

        // Connect to the database and insert/update the competitor data
        try (Connection conn = DriverManager.getConnection(URL, USER, password);
                PreparedStatement ps = conn.prepareStatement(sql)) {

            // Set parameters in the PreparedStatement
            ps.setInt(1, id);                    // Set ID
            ps.setString(2, name);                // Set Name
            ps.setString(3, level);               // Set Level
            ps.setInt(4, age);                    // Set Age
            ps.setInt(5, filledScores[0]);        // Set Score 1
            ps.setInt(6, filledScores[1]);        // Set Score 2
            ps.setInt(7, filledScores[2]);        // Set Score 3
            ps.setInt(8, filledScores[3]);        // Set Score 4
            ps.setInt(9, filledScores[4]);        // Set Score 5

            // Execute the update (insert or update)
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Retrieves all competitors from the database and adds them to the provided CompetitorList.
     *
     * @param competitorList The CompetitorList to which competitors will be added.
     */
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
