package backend.db;

import backend.models.*;
import java.sql.*;

/**
 * Handles database operations related to competitors.
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
    public void clearTable() {
        String sql = "DELETE FROM competitors"; // SQL DELETE query to clear the table

        try (Connection conn = DriverManager.getConnection(URL, USER, password);
                Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);  // Execute the DELETE statement to remove all records
            System.out.println("All competitors have been removed.");
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
            filledScores[i] = (scores[i] != 0) ? scores[i] : -69; // Only assign valid scores
        }

        // SQL Insert Query
        String sql = "INSERT INTO competitors (CompetitorID, name, level, age, score1, score2, score3, score4, score5) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        // Connect to the database and insert the competitor data
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

            // Execute the update (insert)
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
        String query = "SELECT * FROM competitors";

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
