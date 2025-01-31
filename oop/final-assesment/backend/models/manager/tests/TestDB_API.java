package backend.models.manager.tests;

import backend.models.manager.db.DB_API;
import backend.models.competitor.CompetitorList;
import backend.models.competitor.Competitor;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class TestDB_API {

    @Test
    public void testGetAllCompetitors() {
        // Create an instance of DB_API using the TestCompetitorDB
        DB_API dbApi = new DB_API("jdbc:mysql://localhost:3306/TestCompetitionDB", "wizard", "Banana4President");
        CompetitorList competitorList = new CompetitorList();
        
        // Fetch all competitors from the DB and add them to the competitorList
        dbApi.getAllCompetitors(competitorList);
        
        // Retrieve the competitors from the list and check if they match the expected data
        Competitor c1 = competitorList.getAllCompetitors().get(0);
        Competitor c2 = competitorList.getAllCompetitors().get(1);
        Competitor c3 = competitorList.getAllCompetitors().get(2);
        Competitor c4 = competitorList.getAllCompetitors().get(3);
        Competitor c5 = competitorList.getAllCompetitors().get(4);
        
        // Check their details (name, level, score, etc.)
        assertEquals("John Doe", c1.getCompetitorName(3));  // Initials of John Doe
        assertEquals("Expert", c1.getCompetitorLevel());
        assertEquals(25, c1.getAge());
        assertEquals(30.0, c1.getOverallScore(), 0.01);
        
        assertEquals("Jane Smith", c2.getCompetitorName(3));  // Initials of Jane Smith
        assertEquals("Intermediate", c2.getCompetitorLevel());
        assertEquals(28, c2.getAge());
        assertEquals(35.0, c2.getOverallScore(), 0.01);
        
        assertEquals("Bob Johnson", c3.getCompetitorName(3));  // Initials of Bob Johnson
        assertEquals("Beginner", c3.getCompetitorLevel());
        assertEquals(22, c3.getAge());
        assertEquals(15.0, c3.getOverallScore(), 0.01);
        
        assertEquals("Alice Brown", c4.getCompetitorName(3));  // Initials of Alice Brown
        assertEquals("Expert", c4.getCompetitorLevel());
        assertEquals(30, c4.getAge());
        assertEquals(70.0, c4.getOverallScore(), 0.01);
        
        assertEquals("Charlie White", c5.getCompetitorName(3));  // Initials of Charlie White
        assertEquals("Intermediate", c5.getCompetitorLevel());
        assertEquals(26, c5.getAge());
        assertEquals(40.0, c5.getOverallScore(), 0.01);
    }
}
