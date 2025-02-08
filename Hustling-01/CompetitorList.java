import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Manages a list of competitors, allowing for retrieval and display.
 */
public class CompetitorList {
    private List<Competitor> competitors;

    /**
     * Constructs an empty CompetitorList.
     */
    public CompetitorList() {
        this.competitors = new ArrayList<>();
    }

    /**
     * Adds a competitor to the list using data from a {@link ResultSet}.
     * Assumes that the ResultSet contains columns: id, Name, Level, Age, Score1, Score2, Score3, Score4, and Score5.
     *
     * @param rs The ResultSet containing competitor data.
     */
    public void addCompetitor(ResultSet rs) {
        try {
            int id = rs.getInt("id");
            String name = rs.getString("Name");
            String level = rs.getString("Level");
            int age = rs.getInt("Age");
            int[] scores = { 
                rs.getInt("Score1"), rs.getInt("Score2"), 
                rs.getInt("Score3"), rs.getInt("Score4"), rs.getInt("Score5") 
            };
            Competitor competitor = new Competitor(name, age, level, scores);
            competitor.ID = id;
            competitors.add(competitor);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Prints a short summary of all competitors in the list.
     */
    public void printCompetitorList() {
        for (Competitor competitor : competitors) {
            System.out.println(competitor.getShortDetails());
        }
    }

    /**
     * Retrieves the list of competitors.
     * @return A list of {@link Competitor} objects.
     */
    public List<Competitor> getCompetitors() {
        return competitors;
    }
}
