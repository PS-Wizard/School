import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import java.util.Arrays;
import java.util.List;
import java.sql.*;

class NameTest {
    @Test
    void testNameParsing() {
        Name name = new Name("John Doe");
        assertEquals("John", name.getFirstName());
        assertEquals("Doe", name.getLastName());
        assertEquals("J D", name.getInitials());
    }

    @Test
    void testEmptyLastName() {
        Name name = new Name("John");
        assertEquals("John", name.getFirstName());
        assertEquals("", name.getLastName());
        assertEquals("J -", name.getInitials());
    }
}

class CompetitorTest {
    @Test
    void testCompetitorCreation() {
        int[] scores = {10, 20, 30, 40, 50};
        Competitor competitor = new Competitor("Jane Doe", 25, "Pro", scores);
        competitor.ID = 1;
        assertEquals("Jane", competitor.getName().getFirstName());
        assertEquals("Doe", competitor.getName().getLastName());
        assertEquals(25, competitor.getAge());
        assertEquals("Pro", competitor.getLevel());
        assertArrayEquals(scores, competitor.getScores());
        assertEquals(30, competitor.getOverallScores());
    }
}

class CompetitorListTest {
    @Test
    void testAddCompetitor() throws SQLException {
        CompetitorList list = new CompetitorList();
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/TestCompetitorDB", "wizard", "Banana4President");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM Competitors");
        while (rs.next()) {
            list.addCompetitor(rs);
        }
        assertFalse(list.getCompetitors().isEmpty());
    }
}

class DatabaseTest {
    @Test
    void testGetScores() {
        database db = new database();
        CompetitorList list = db.getScores();
        assertNotNull(list);
        assertFalse(list.getCompetitors().isEmpty());
    }
}

class QuestionsTest {
    @Test
    void testQuestionsRetrieval() throws SQLException {
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/TestQuizDB", "wizard", "Banana4President");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM Questions");
        Questions questions = new Questions(rs);
        assertNotNull(questions.getQuestions());
        assertFalse(questions.getQuestions().isEmpty());
    }
}
