package backend.models.manager.db;

import backend.models.competitor.CompetitorList;
import backend.models.competitor.Competitor;
import java.sql.*;

public class DB_API {
    private String URL;
    private String USER;
    private String PASSWORD;

    public DB_API(String url, String user, String password){
        this.URL = url;
        this.USER = user;
        this.PASSWORD = password;
    }

    // Store competitor in the database
    public void store(Competitor competitor) {
        // Get values from the Competitor object
        String name = competitor.getCompetitorName(3);
        String level = competitor.getCompetitorLevel();
        int[] scores = competitor.getScoreArray();
        int age = competitor.getAge();

        // Ensure there are 5 scores to insert
        int score1 = scores.length > 0 ? scores[0] : 0;
        int score2 = scores.length > 1 ? scores[1] : 0;
        int score3 = scores.length > 2 ? scores[2] : 0;
        int score4 = scores.length > 3 ? scores[3] : 0;
        int score5 = scores.length > 4 ? scores[4] : 0;

        // Prepare the SQL query
        String query = String.format(
                "INSERT INTO Competitors (Name, Level, Score1, Score2, Score3, Score4, Score5, Age) VALUES ('%s', '%s', %d, %d, %d, %d, %d, %d)",
                name, level, score1, score2, score3, score4, score5, age);

        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
                Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(query);
            System.out.println("Competitor stored successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Retrieve all competitors and add them to the CompetitorList
    public void getAllCompetitors(CompetitorList competitorList) {
        String query = "SELECT * FROM Competitors";
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
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
