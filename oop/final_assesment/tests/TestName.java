package tests;

// JUnit
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import backend.models.Name;

public class TestName {

    /**
     * Test the constructor and getters of the Name class.
     */
    @Test
    public void testNameConstructorAndGetters() {
        String fullName = "John Doe";
        Name name = new Name(fullName);

        // Test if the first name is set correctly
        assertEquals("John", name.getFirstName());

        // Test if the last name is set correctly
        assertEquals("Doe", name.getLastName());

        // Test if the full name is returned correctly
        assertEquals("John Doe", name.getFullName());
    }

    /**
     * Test the getInitials method of the Name class.
     */
    @Test
    public void testGetInitials() {
        String fullName = "John Doe";
        Name name = new Name(fullName);

        // Test if the initials are returned correctly
        assertEquals("J. D.", name.getInitials());
    }

    /**
     * Test the toString method of the Name class.
     */
    @Test
    public void testToString() {
        String fullName = "John Doe";
        Name name = new Name(fullName);

        // Test if the toString method returns the full name
        assertEquals("John Doe", name.toString());
    }

    /**
     * Test the behavior when an invalid full name is passed (only one part).
     */
    @Test
    public void testInvalidFullName() {
        String fullName = "John";
        
        // This should throw an ArrayIndexOutOfBoundsException because we don't have a last name.
        assertThrows(ArrayIndexOutOfBoundsException.class, () -> {
            new Name(fullName);
        });
    }
}
