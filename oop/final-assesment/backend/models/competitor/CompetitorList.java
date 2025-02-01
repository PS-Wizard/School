package backend.models.competitor;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompetitorList {
    private List<Competitor> competitors;

    // Constructor to create an empty list
    public CompetitorList() {
        this.competitors = new ArrayList<>();
    }

    // Adds a Competitor to the list
    public void addCompetitor(ResultSet rs) {
        try {
            int id = rs.getInt("CompetitorID");
            String name = rs.getString("Name");
            String level = rs.getString("Level");
            int age = rs.getInt("Age");
            int[] scores = { rs.getInt("Score1"), rs.getInt("Score2"), rs.getInt("Score3"), rs.getInt("Score4"), rs.getInt("Score5") };
            Competitor competitor = new Competitor(name, age, getLevelIndex(level), scores);
            competitor.setCompetitorID(id);
            competitors.add(competitor);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Removes a Competitor from the list by id
    public void removeCompetitor(int id) {
        competitors.removeIf(competitor -> competitor.getCompetitorID() == id);
    }

    // Returns the list of all competitors
    public List<Competitor> getAllCompetitors() {
        return competitors;
    }

    // Helper method to get the level index
    private int getLevelIndex(String level) {
        return switch (level) {
            case "Beginner" -> 0;
            case "Intermediate" -> 1;
            case "Expert" -> 2;
            default -> 0;
        };
    }

    public void printCompetitorList() {
        for (Competitor competitor : competitors) {
            System.out.println(competitor.getFullDetails());
        }
    }
}
