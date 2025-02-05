import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CompetitorList {
    private List<Competitor> competitors;

    public CompetitorList() {
        this.competitors = new ArrayList<>();
    }

    public void addCompetitor(ResultSet rs) {
        try {
            int id = rs.getInt("id");
            String name = rs.getString("Name");
            String level = rs.getString("Level");
            int age = rs.getInt("Age");
            int[] scores = { rs.getInt("Score1"), rs.getInt("Score2"), rs.getInt("Score3"), rs.getInt("Score4"), rs.getInt("Score5") };
            Competitor competitor = new Competitor(name, age, level, scores);
            competitor.ID = id;
            competitors.add(competitor);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void printCompetitorList() {
        for (Competitor competitor : competitors) {
            System.out.println(competitor);
        }
    }

    public List<Competitor> getCompetitors() {
        return competitors;
    }
}
