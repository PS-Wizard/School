import java.util.Arrays; // Import this at the top
class Name{

    private String fName;
    private String lName;

    public Name(String fullName) {
        String[] parts = fullName.split(" ", 2);
        this.fName = parts.length > 0 ? parts[0] : "";
        this.lName = parts.length > 1 ? parts[1] : "";
    }

    public String getFirstName() {
        return fName;
    }

    public String getLastName() {
        return lName;
    }

    public String getInitials() {
        return (!fName.isEmpty() ? fName.charAt(0) : '-') + " " + (!lName.isEmpty() ? lName.charAt(0) : '-');
    }
}
public class Competitor {
    private Name name;
    public int ID;
    private String Level;
    private int Age;
    private int[] Scores;

    public Competitor(String name, int age, String level, int[] scores){
        this.name = new Name(name);
        this.Age = age;
        this.Level = level;
        this.Scores = scores;
    }

    public Name getName() {
        return name;
    }

    public int getID() {
        return ID;
    }

    public String getLevel() {
        return Level;
    }

    public int getAge() {
        return Age;
    }

    public int[] getScores() {
        return Scores;
    }

    public int getOverallScores() {
        int sum = 0;
        for (int score : Scores) {
            sum += score;
        }
        return Scores.length > 0 ? sum / Scores.length : 0; // Avoid division by zero
    }

    public String getShortDetails() {
        return String.format("Competitor ID: %d; %s ; Overall Scores: %d", ID, name.getInitials(), getOverallScores());
    }

    public String toString() {
        return "Competitor ID: " + ID + ", Name: " + name.getFirstName() + " " + name.getLastName() + 
            ", Age: " + Age + ", Level: " + Level + ", Scores: " + Arrays.toString(Scores) + 
            ", Overall Score: " + getOverallScores();
    }
}
