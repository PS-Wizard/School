package backend.models.competitor.tests;
//Junit
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import backend.models.competitor.Competitor;

// To Test:
public class TestCompetitor {

    @Test
    public void testCompetitorConstructor() {
        Competitor competitor = new Competitor(1, "John Doe", 25, 2);
        
        // Test Competitor ID
        assertCompetitorID(competitor);

        // Test Names
        assertCompetitorNames(competitor);

        // Test Full Details
        assertFullDetails(competitor);

        // Test Short Details
        assertShortDetails(competitor);

        // Test Level
        assertCompetitorLevel(competitor);
    }
   
    @Test
    public void testGetOverallScore() {
        Competitor competitor = new Competitor(1, "John Doe", 25, 1);
        assertEquals(5, competitor.getOverallScore());
    }

    // Helper functions to split up the tests:
    private void assertCompetitorID(Competitor competitor) {
        assertEquals(1, competitor.getCompetitorID());
    }

    private void assertCompetitorNames(Competitor competitor) {
        assertEquals("John", competitor.getCompetitorName(0));
        assertEquals("Doe", competitor.getCompetitorName(1));
        assertEquals("J. D.", competitor.getCompetitorName(2));
        assertEquals("John Doe", competitor.getCompetitorName(3));
    }

    private void assertFullDetails(Competitor competitor) {
        String expected = String.format(
            "Competitor number: %d, Name: %s\n%s is a %s aged %d and has an overall score of %d", 
            1, 
            "John Doe", 
            "J. D.", 
            "Expert", 
            25, 
            5
        );
        assertEquals(expected, competitor.getFullDetails());
    }

    private void assertShortDetails(Competitor competitor) {
        String short_expected = String.format(
            "CN %d (%s) has overall score of %d", 
            1, 
            "J. D.", 
            5
        );
        assertEquals(short_expected, competitor.getShortDetails());
    }

    private void assertCompetitorLevel(Competitor competitor) {
        assertEquals("Expert", competitor.getCompetitorLevel());
    }
}
