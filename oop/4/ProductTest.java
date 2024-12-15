import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ProductTest {

    @Test
    public void testProduct() {
        Product product = new Product("Laptop", 1000, 3);

        assertAll(
            "Product assertions",
            () -> assertNotNull(product.getName(), "Product name should not be null"),
            () -> assertTrue(product.getPrice() > 0, "Product price should be positive"),
            () -> assertTrue(product.isAffordable(4000), "Product should be affordable with budget of 4000"),
            () -> assertFalse(product.isAffordable(2000), "Product should not be affordable with budget of 2000")
        );
    }
}

