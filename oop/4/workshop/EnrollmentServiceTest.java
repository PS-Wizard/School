import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class EnrollmentServiceTest {
    @Test
    public void testEnrollStudent() {
        assertAll(
            () -> assertTrue(EnrollmentService.enrollStudent("someone", "java")),
            () -> assertFalse(EnrollmentService.enrollStudent("student1", "java"));
        );
    }
}

class EnrollmentService {
    static String[] enrolledStudents = {"student1:java", "student2:c"}; 

    public static boolean enrollStudent(String student, String courseName) {
        String enrollmentRecord = student + ":" + courseName;
        for (String record : enrolledStudents) {
            if (record.equals(enrollmentRecord)) {
                return false; 
            }
        }

        System.out.println("Enrolled " + student);
        return true;
    }
}
