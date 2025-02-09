package backend.models;

/**
 * Represents the name of a competitor.
 */
public class Name {
    private String firstName;
    private String lastName;

    /**
     * Constructor for the `Name` class.
     *
     * @param fullName String representation of the full name of the competitor.
     */
    public Name(String fullName) {
        String[] parts = fullName.split(" ");
        this.firstName = parts[0];
        this.lastName = parts[1];
    }

    /**
     * Returns the first name of the competitor.
     *
     * @return String competitor's first name.
     */ 
    public String getFirstName() {
        return this.firstName;
    }

    /**
     * Returns the last name of the competitor.
     *
     * @return String competitor's last name.
     */ 
    public String getLastName() {
        return this.lastName;
    }

    /**
     * Returns the competitor's full name.
     *
     * @return String competitor's full name.
     */
    public String getFullName() {
        return String.format("%s %s", this.firstName, this.lastName);
    }

    /**
     * Returns the competitor's initials.
     *
     * @return String competitor's initials.
     */
    public String getInitials() {
        return String.format("%s. %s.", this.firstName.charAt(0), this.lastName.charAt(0));
    }

    /**
     * Returns the full name of the competitor.
     *
     * @return A string representation of the competitor, calling getFullDetails().
     */
    @Override
    public String toString() {
        return getFullName();
    }
}

