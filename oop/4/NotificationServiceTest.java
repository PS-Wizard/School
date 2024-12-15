import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class NotificationServiceTest {
    @Test
    public void testSendEmail() {
        assertAll(
            () -> assertTrue(NotificationService.sendEmail("something@gmail.com", "should work")),
            () -> assertFalse(NotificationService.sendEmail("not valid", "shouldnt work")),
            () -> assertFalse(NotificationService.sendEmail("!@gmail.com", "shouldnt work"))
        );
    }
}

class NotificationService {
    public static boolean sendEmail(String email, String message) {
        if(email.matches("^[a-zA-Z0-9\\.]+@gmail\\.com$")){
            System.out.println("Sent Messagej" + message);
            return true;
        };
        return false;
    }
}
