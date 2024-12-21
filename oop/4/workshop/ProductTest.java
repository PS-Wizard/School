import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ProductTest {
    @Test
    public void testProduct() {
        Product product = new Product("Laptop", 1000, 3);
        assertAll(
            "Product Assertions",
            () -> assertNotNull(product.getName(), "Product name should not be null"),
            () -> assertTrue(product.getPrice() > 0, "Product price should be positive"),
            () -> assertTrue(product.isAffordable(4000), "Should be affordable with a budget of 4000"),
            () -> assertFalse(product.isAffordable(2000), "Should not be affordable with a budget of 2000")
        );
    }
}

class Product {
    String name;
    double price;
    int quantity;

    public Product(String name, double price, int quantity) {
        this.name = name;
        this.price = price;
        this.quantity = quantity;
    }

    public String getName() { return name; }

    public double getPrice() { return price; }

    public boolean isAffordable(double budget) { return (price * quantity) <= budget; }
}

