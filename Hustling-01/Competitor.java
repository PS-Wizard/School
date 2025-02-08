import java.util.Arrays;

/**
 * Represents a person's name with first and last name components.
 */
class Name {
    private String fName;
    private String lName;

    /**
     * Constructs a Name object from a full name string.
     * @param fullName The full name of the person.
     */
    public Name(String fullName) {
        String[] parts = fullName.split(" ", 2);
        this.fName = parts.length > 0 ? parts[0] : "";
        this.lName = parts.length > 1 ? parts[1] : "";
    }

    /**
     * Gets the first name.
     * @return The first name.
     */
    public String getFirstName() {
        return fName;
    }

    /**
     * Gets the last name.
     * @return The last name.
     */
    public String getLastName() {
        return lName;
    }

    /**
     * Gets the initials of the person.
     * @return A string representing the initials in the format "F L".
     */
    public String getInitials() {
        return (!fName.isEmpty() ? fName.charAt(0) : '-') + " " + (!lName.isEmpty() ? lName.charAt(0) : '-');
    }
}

/**
 * Represents a competitor in a competition.
 */
public class Competitor {
    private Name name;
    public int ID;
    private String Level;
    private int Age;
    private int[] Scores;

    /**
     * Constructs a Competitor object.
     * @param name The full name of the competitor.
     * @param age The age of the competitor.
     * @param level The competition level of the competitor.
     * @param scores An array of scores achieved by the competitor.
     */
    public Competitor(String name, int age, String level, int[] scores){
        this.name = new Name(name);
        this.Age = age;
        this.Level = level;
        this.Scores = scores;
    }

    /**
     * Gets the name of the competitor.
     * @return A Name object representing the competitor's name.
     */
    public Name getName() {
        return name;
    }

    /**
     * Gets the competitor's ID.
     * @return The ID of the competitor.
     */
    public int getID() {
        return ID;
    }

    /**
     * Gets the competition level of the competitor.
     * @return The competition level.
     */
    public String getLevel() {
        return Level;
    }

    /**
     * Gets the age of the competitor.
     * @return The age of the competitor.
     */
    public int getAge() {
        return Age;
    }

    /**
     * Gets the scores of the competitor.
     * @return An array of scores.
     */
    public int[] getScores() {
        return Scores;
    }

    /**
     * Calculates the overall score of the competitor as the average of all scores.
     * @return The overall score, or 0 if there are no scores.
     */
    public int getOverallScores() {
        int sum = 0;
        for (int score : Scores) {
            sum += score;
        }
        return Scores.length > 0 ? sum / Scores.length : 0;
    }

    /**
     * Gets a short summary of the competitor's details.
     * @return A string with the competitor's ID, initials, and overall score.
     */
    public String getShortDetails() {
        return String.format("Competitor ID: %d; %s ; Overall Scores: %d", ID, name.getInitials(), getOverallScores());
    }

    /**
     * Returns a string representation of the competitor.
     * @return A formatted string with the competitor's details.
     */
    public String toString() {
        return "Competitor ID: " + ID + ", Name: " + name.getFirstName() + " " + name.getLastName() + 
            ", Age: " + Age + ", Level: " + Level + ", Scores: " + Arrays.toString(Scores) + 
            ", Overall Score: " + getOverallScores();
    }
}
