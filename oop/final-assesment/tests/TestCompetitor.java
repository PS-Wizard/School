package tests;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import backend.models.Competitor;

public class TestCompetitor {

    /**
     * Test the constructor and getters of the Competitor class.
     */
    @Test
    public void testCompetitorConstructorAndGetters() {
        int[] scores = { 80, 85, 90, 95, 100 };
        Competitor comp = new Competitor("John Doe", 1, "Expert", 25, scores);

        assertEquals(1, comp.getCompetitorID());
        assertEquals("Expert", comp.getLevel());
        assertEquals(25, comp.getAge());
        assertArrayEquals(scores, comp.getScores());
    }

    /**
     * Test the overall score calculation of the Competitor class.
     */
    @Test
    public void testGetOverallScore() {
        int[] scores = { 80, 85, 90, 95, 100 };
        Competitor comp = new Competitor("John Doe", 1, "Expert", 25, scores);

        String expectedOverallScore = "90";
        assertEquals(expectedOverallScore, comp.getOverallScore());

        // Test with negative score
        int[] scoresWithNegative = { 80, -1, 90, 95, 100 };
        Competitor compWithNegative = new Competitor("Jane Doe", 2, "Beginner", 30, scoresWithNegative);
        assertEquals("Scores Aren't Fully Filled", compWithNegative.getOverallScore());
    }

    /**
     * Test the full details string of the Competitor class.
     */
    @Test
    public void testGetFullDetails() {
        int[] scores = { 80, 85, 90, 95, 100 };
        Competitor comp = new Competitor("John Doe", 1, "Expert", 25, scores);

        String expectedFullDetails = "ID: 1, John Doe is 25 years old, and is a Expert scoring Score1: 80, Score2: 85, Score3: 90, Score4: 95, Score5: 100 ; With an Overall Score of 90";
        assertEquals(expectedFullDetails, comp.getFullDetails());

        // Test case with a negative score
        int[] scoresWithNegative = { 80, -1, 90, 95, 100 };
        Competitor compWithNegative = new Competitor("Jane Doe", 2, "Beginner", 30, scoresWithNegative);
        String expectedFullDetailsWithNegative = "ID: 2, Jane Doe is 30 years old, and is a Beginner scoring Score1: 80, Score2: -, Score3: 90, Score4: 95, Score5: 100 ; With an Overall Score of Scores Aren't Fully Filled";
        assertEquals(expectedFullDetailsWithNegative, compWithNegative.getFullDetails());
    }

    /**
     * Test the short details string of the Competitor class.
     */
    @Test
    public void testGetShortDetails() {
        int[] scores = { 80, 85, 90, 95, 100 };
        Competitor comp = new Competitor("John Doe", 1, "Expert", 25, scores);

        String expectedShortDetails = "ID: 1 ; Initials: J. D. ; Overall Score: 90";
        assertEquals(expectedShortDetails, comp.getShortDetails());

        // Test case with negative score
        int[] scoresWithNegative = { 80, -1, 90, 95, 100 };
        Competitor compWithNegative = new Competitor("Jane Doe", 2, "Beginner", 30, scoresWithNegative);
        String expectedShortDetailsWithNegative = "ID: 2 ; Initials: J. D. ; Overall Score: Scores Aren't Fully Filled";
        assertEquals(expectedShortDetailsWithNegative, compWithNegative.getShortDetails());
    }

    /**
     * Test the toString method of the Competitor class.
     */
    @Test
    public void testToString() {
        int[] scores = { 80, 85, 90, 95, 100 };
        Competitor comp = new Competitor("John Doe", 1, "Expert", 25, scores);

        String expectedFullDetails = "ID: 1, John Doe is 25 years old, and is a Expert scoring Score1: 80, Score2: 85, Score3: 90, Score4: 95, Score5: 100 ; With an Overall Score of 90";
        assertEquals(expectedFullDetails, comp.toString());

        // Test case with negative score
        int[] scoresWithNegative = { 80, -1, 90, 95, 100 };
        Competitor compWithNegative = new Competitor("Jane Doe", 2, "Beginner", 30, scoresWithNegative);
        String expectedFullDetailsWithNegative = "ID: 2, Jane Doe is 30 years old, and is a Beginner scoring Score1: 80, Score2: -, Score3: 90, Score4: 95, Score5: 100 ; With an Overall Score of Scores Aren't Fully Filled";
        assertEquals(expectedFullDetailsWithNegative, compWithNegative.toString());
    }
}
