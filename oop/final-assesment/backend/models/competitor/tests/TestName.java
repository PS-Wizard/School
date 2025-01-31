package backend.models.competitor.tests;

// Junit
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import backend.models.competitor.Name;

// To Test:
public class TestName {

    @Test
    public void testNameConstructor() {
        Name name = new Name("John Doe");
        assertEquals("John", name.getFName()); 
        assertEquals("Doe", name.getLName());  
    }

    @Test
    public void testGetFName() {
        Name name = new Name("Alice Smith");
        assertEquals("Alice", name.getFName()); 
    }

    @Test
    public void testGetLName() {
        Name name = new Name("Bob Johnson");
        assertEquals("Johnson", name.getLName()); 
    }

    @Test
    public void testGetFullName() {
        Name name = new Name("Charlie Brown");
        assertEquals("Charlie Brown", name.getFullName()); 
    }

    @Test
    public void testToString() {
        // Test the toString method (uses getFullName internally)
        Name name = new Name("Diana Prince");
        assertEquals("Diana Prince", name.toString()); 
    }
}
