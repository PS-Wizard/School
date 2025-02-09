package tests;

import backend.db.DB_API;
import backend.models.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.sql.*;

public class TestDB_API {
    private DB_API dbApi = new DB_API("jdbc:mysql://localhost:3306/TestJavaAssesment", "wizard", "Banana4President");

    @BeforeEach
    public void setUp() {
        // Clear the competitors table before each test
        dbApi.clearCompetitorTable();
    }

    @Test
    public void testStoreCompetitor() {
        // Create a competitor object
        int[] scores = {85, 90, 92, 80, 78};
        Competitor newCompetitor = new Competitor("Mark Spencer", 4, "Expert", 28, scores);

        // Store the competitor in the database
        dbApi.store(newCompetitor);

        // Verify the competitor is stored (by retrieving)
        CompetitorList competitorList = new CompetitorList();
        dbApi.getAllCompetitors(competitorList);

        // Check if the competitor is in the list
        boolean competitorFound = competitorList.getAllCompetitors().stream()
                .anyMatch(c -> c.getCompetitorID() == 4 && c.getName().getFullName().equals("Mark Spencer"));

        assertTrue(competitorFound, "Competitor not found in the database after storing.");
    }

    @Test
    public void testGetAllCompetitors() {
        // Manually insert a competitor to check retrieval
        int[] scores = {85, 90, 92, 80, 78};
        Competitor newCompetitor = new Competitor("John Smith", 1, "Beginner", 30, scores);
        dbApi.store(newCompetitor);

        // Retrieve all competitors from the database
        CompetitorList competitorList = new CompetitorList();
        dbApi.getAllCompetitors(competitorList);

        // Verify that at least 1 competitor is returned
        assertTrue(competitorList.getAllCompetitors().size() > 0, "No competitors retrieved from the database.");
    }

    @Test
    public void testAddCompetitorFromResultSet() {
        // Manually insert a competitor to check the result set
        String query = "INSERT INTO Competitors (CompetitorID, name, level, age, score1, score2, score3, score4, score5) VALUES (1, 'John Doe', 'Intermediate', 25, 85, 90, 92, 88, 79)";
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/TestJavaAssesment", "wizard", "Banana4President");
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(query);  // Insert the competitor
        } catch (SQLException e) {
            e.printStackTrace();
            fail("SQL exception during test.");
        }

        // Now test adding the competitor from the result set
        String selectQuery = "SELECT * FROM Competitors WHERE CompetitorID = 1";
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/TestJavaAssesment", "wizard", "Banana4President");
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(selectQuery)) {

            CompetitorList competitorList = new CompetitorList();
            while (rs.next()) {
                competitorList.addCompetitor(rs);
            }

            assertEquals(1, competitorList.getAllCompetitors().size(), "Competitor not added from ResultSet.");
            Competitor comp = competitorList.getAllCompetitors().get(0);
            assertEquals("John Doe", comp.getName().getFullName(), "Incorrect competitor name.");
            assertEquals(25, comp.getAge(), "Incorrect competitor age.");
            assertEquals("Intermediate", comp.getLevel(), "Incorrect competitor level.");

        } catch (SQLException e) {
            e.printStackTrace();
            fail("SQL exception during test.");
        }
    }
}
