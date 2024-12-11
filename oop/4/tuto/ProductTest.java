import org.junit.Test;
import static org.junit.Assert.assertEquals;

class Product {
    private double price;
    private double discount; 

    public Product(double price, double discount) {
        this.price = price;
        this.discount = discount;
    }

    public double calculateTotalPrice() {
        return price - (price * discount / 100);
    }
}

public class ProductTest {

    @Test
    public void testCalculateTotalPrice() {
        Product product = new Product(100, 10); 
        assertEquals(90, product.calculateTotalPrice(), 0.01); 

        product = new Product(200, 25); 
        assertEquals(150, product.calculateTotalPrice(), 0.01); 
    }
}

