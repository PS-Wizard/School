package backend.models;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Represents a collection of competitors.
 */
public class CompetitorList{
    private List<Competitor> competitors;

    /**
     * Constructs an empty list of competitors.
     */
    public CompetitorList(){
        this.competitors = new ArrayList<>();
    }

    /**
     * Adds a competitor to the list from a given ResultSet.
     *
     * @param rs The ResultSet containing the competitor's data. 
     *           Expected columns: CompetitorID, Name, Level, Age, Score1, Score2, Score3, Score4, Score5.
     */
    public void addCompetitor(ResultSet rs){
        try {
            int id = rs.getInt("CompetitorID");
            String name = rs.getString("Name");
            String level = rs.getString("Level");
            int age = rs.getInt("Age");
            int[] scores = { rs.getInt("Score1"), rs.getInt("Score2"), rs.getInt("Score3"), rs.getInt("Score4"), rs.getInt("Score5") };
            Competitor comp = new Competitor(name, id, level, age, scores);
            competitors.add(comp);
        } catch (SQLException e){
            e.printStackTrace();
        }
    }

    /**
     * Returns the list of all competitors.
     *
     * @return A List of Competitor objects.
     */
    public List<Competitor> getAllCompetitors(){
        return this.competitors;
    }
}
