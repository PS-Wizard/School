import java.util.ArrayList;
import java.util.List;

/**
 * Customer class represents a customer in the system.
 */
class Customer {
    String customerId;
    String name;
    String email;
    String password;
    ShoppingCart cart;

    /**
     * Registers a new customer.
     */
    public void register() { }

    /**
     * Customer logs into the system
     */
    public void login() { }

    /**
     * Displays available products.
     */
    public void viewProducts() { }

    /**
     * Adds product to the shopping cart
     */
    public void addToCart(Product product) {
        cart.addProduct(product);
    }

    /**
     * Proceeds with checkout
     */
    public void checkout() { }
}

/**
 * Product class represents a product 
 */
class Product {
    String productId;
    String name;
    double price;
    int stockQuantity;

    /**
     * Displays product details.
     */
    public void getDetails() { }

    /**
     * Checks if the product is available 
     * @return true if available, false else
     */
    public boolean checkAvailability() { return stockQuantity > 0; }
}

/**
 * ShoppingCart class represents a cart
 */
class ShoppingCart {
    List<Product> cartItems = new ArrayList<>();
    double totalPrice;

    /**
     * Adds a product to the shopping cart.
     */
    public void addProduct(Product product) { cartItems.add(product); }

    /**
     * Removes a product from the cart.
     */
    public void removeProduct(Product product) { cartItems.remove(product); }

    /**
     * Calculates the total price of items 
     * @return total price.
     */
    public double calculateTotalPrice() {
        totalPrice = 0;
        for (Product product : cartItems) {
            totalPrice += product.price;
        }
        return totalPrice;
    }

    /**
     * Displays the items in the cart.
     */
    public void viewCartItems() { }
}

/**
 * Main class 
 */
public class main {
    public static void main(String[] args) {
        Customer customer = new Customer(); Product product1 = new Product(); ShoppingCart cart = new ShoppingCart();

        customer.addToCart(product1);
        customer.checkout();
        cart.calculateTotalPrice();
    }
}
