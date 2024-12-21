import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class InventoryTest {
    @Test
    public void testIsProductAvailable() {
        assertAll(
            () -> assertTrue(Inventory.isProductAvailable("laptop", 5)),
            () -> assertFalse(Inventory.isProductAvailable("phone", 6)),
            () -> assertFalse(Inventory.isProductAvailable("Moniter", 1)),
            () -> assertTrue(Inventory.isProductAvailable("tablet", 8))
        );
    }
}
class Inventory {
    public static String[] productNames = {"laptop", "phone", "tablet"};
    public static int[] productQuantities = {10, 5, 8};

    public static boolean isProductAvailable(String productName, int quantity) {
        for (int i = 0; i < productNames.length; i++) {
            if (productNames[i].equals(productName)) {
                return productQuantities[i] >= quantity; 
            }
        }
        return false; 
    }
}

