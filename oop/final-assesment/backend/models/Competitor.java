package backend.models;

/**
 * Represents a competitor.
 */
public class Competitor {
    private int ID;
    private Name name;
    private String level;
    private int age;
    private int[] scores;

    /**
     * Constructs a competitor.
     *
     * @param fullName The full name of the competitor (String).
     * @param competitorID The ID of the competitor (int).
     * @param competitorLevel The level of the competitor (String).
     * @param competitorAge The age of the competitor (int).
     * @param scores The scores of the competitor (int[]).
     */
    public Competitor(String fullName, int competitorID, String competitorLevel, int competitorAge, int[] scores) {
        this.name = new Name(fullName);
        this.ID = competitorID;
        this.level = competitorLevel;
        this.age = competitorAge;
        this.scores = new int[5];

        if (scores != null) {
            int len = Math.min(scores.length, 5); // If more than 5 are provided, only the first 5 are used.
            System.arraycopy(scores, 0, this.scores, 0, len); // Start copying from index 0 of scores and start writing from index 0 of this.scores 
        }

        if ("Intermediate".equalsIgnoreCase(competitorLevel) || "Expert".equalsIgnoreCase(competitorLevel)) {
            this.level = competitorLevel;
        } else {
            this.level = "Beginner";
        }       
    }

    /**
     * Returns a competitor's Name.
     *
     * @return The competitor's ID (int).
     */
    public Name getName() {
        return this.name;
    }

    /**
     * Returns a competitor's ID.
     *
     * @return The competitor's ID (int).
     */
    public int getCompetitorID() {
        return this.ID;
    }

    /**
     * Returns a competitor's level.
     *
     * @return The competitor's level (String).
     */
    public String getLevel() {
        return this.level;
    }

    /**
     * Returns a competitor's level.
     *
     * @return The competitor's age (int).
     */
    public int getAge() {
        return this.age;
    }

    /**
     * Returns all the scores of the competitor.
     *
     * @return Array of scores .
     */
    public int[] getScores() {
        return this.scores; 
    }
    
    /**
     * Returns the overall score of the competitor.
     *
     * @return The overall score (mean) of the competitor.
     */
    public String getOverallScore() {
        int sum = 0;
        for (int score : this.scores) {
            if (score < 0) {
                return "Scores Aren't Fully Filled";
            }
            sum += score;
        }
        return (sum / this.scores.length) + ""; // Calculate the mean
    }

    /**
     * Returns the full details of the competitor.
     *
     * @return A formatted string with the competitor's full details.
     */

    public String getFullDetails() {
        StringBuilder scoreDetails = new StringBuilder();

        for (int i = 0; i < this.scores.length; i++) {
            if (this.scores[i] < 0) {
                scoreDetails.append(String.format("Score%d: -", i + 1));
            } else {
                scoreDetails.append(String.format("Score%d: %d", i + 1, this.scores[i]));
            }
            if (i < this.scores.length - 1) {
                scoreDetails.append(", ");
            }
        }

        return String.format(
                "ID: %d, %s is %d years old, and is a %s scoring %s ; With an Overall Score of %s",
                this.ID, this.name.getFullName(), getAge(), this.level, scoreDetails.toString(), getOverallScore()
                );
    }

    /**
     * Returns a short version of the competitor's details.
     *
     * @return A formatted string with the competitor's short details.
     */
    public String getShortDetails() {
        return String.format("ID: %d ; Initials: %s ; Overall Score: %s", this.ID, this.name.getInitials(), getOverallScore());
    }


    /**
     * Returns the string representation of the competitor.
     *
     * @return A string representation of the competitor, calling getFullDetails().
     */
    @Override 
    public String toString(){
        return getFullDetails();
    }
}
