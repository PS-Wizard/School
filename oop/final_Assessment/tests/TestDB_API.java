package tests;

import backend.db.DB_API;
import backend.models.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.sql.*;

public class TestDB_API {
    private DB_API dbApi = new DB_API("jdbc:mysql://localhost:3306/TestJavaAssessment", "wizard", "Banana4President");

    @BeforeEach
    public void setUp() {
        dbApi.clearCompetitorTable();
    }

    @Test
    public void testStoreCompetitor() {
        int[] scores = {85, 90, 92, 80, 78};
        Competitor newCompetitor = new Competitor("Mark Spencer", 4, "Expert", 28, scores);

        dbApi.store(newCompetitor);

        CompetitorList competitorList = new CompetitorList();
        dbApi.getAllCompetitors(competitorList);

        boolean competitorFound = competitorList.getAllCompetitors().stream()
                .anyMatch(c -> c.getCompetitorID() == 4 && c.getName().getFullName().equals("Mark Spencer"));

        assertTrue(competitorFound, "Competitor not found in the database after storing.");
    }

    @Test
    public void testGetAllCompetitors() {
        int[] scores = {85, 90, 92, 80, 78};
        Competitor newCompetitor = new Competitor("John Smith", 1, "Beginner", 30, scores);
        dbApi.store(newCompetitor);

        CompetitorList competitorList = new CompetitorList();
        dbApi.getAllCompetitors(competitorList);

        assertTrue(competitorList.getAllCompetitors().size() > 0, "No competitors retrieved from the database.");
    }

    @Test
    public void testDeleteCompetitor() {
        int[] scores = {85, 90, 92, 80, 78};
        Competitor newCompetitor = new Competitor("Tom Brown", 6, "Intermediate", 24, scores);

        dbApi.store(newCompetitor);
        dbApi.deleteCompetitor(6);

        Competitor deletedCompetitor = dbApi.getCompetitorById(6);

        assertNull(deletedCompetitor, "Competitor should not be found after deletion.");
    }

    @Test
    public void testGetCompetitorById() {
        int[] scores = {85, 90, 92, 80, 78};
        Competitor newCompetitor = new Competitor("Emily Davis", 7, "Beginner", 22, scores);

        dbApi.store(newCompetitor);

        Competitor retrievedCompetitor = dbApi.getCompetitorById(7);

        assertNotNull(retrievedCompetitor, "Competitor should be retrieved by ID.");
        assertEquals("Emily Davis", retrievedCompetitor.getName().getFullName(), "Incorrect name for the retrieved competitor.");
        assertEquals(22, retrievedCompetitor.getAge(), "Incorrect age for the retrieved competitor.");
        assertEquals("Beginner", retrievedCompetitor.getLevel(), "Incorrect level for the retrieved competitor.");
        assertArrayEquals(scores, retrievedCompetitor.getScores(), "Incorrect scores for the retrieved competitor.");
    }

    @Test
    public void testAddCompetitorFromResultSet() {
        String query = "INSERT INTO Competitors (CompetitorID, name, level, age, score1, score2, score3, score4, score5) VALUES (1, 'John Doe', 'Intermediate', 25, 85, 90, 92, 88, 79)";
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/TestJavaAssessment", "wizard", "Banana4President");
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(query);  
        } catch (SQLException e) {
            e.printStackTrace();
            fail("SQL exception during test.");
        }

        String selectQuery = "SELECT * FROM Competitors WHERE CompetitorID = 1";
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/TestJavaAssessment", "wizard", "Banana4President");
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
