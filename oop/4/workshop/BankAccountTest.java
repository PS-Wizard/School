import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class BankAccountTest {

    @Test
    public void testDeposit() {
        BankAccount account = new BankAccount();
        account.deposit(100.0);
        assertEquals(100.0, account.getBalance());
    }

    @Test
    public void testWithdraw() {
        BankAccount account = new BankAccount();
        account.deposit(100.0);

        boolean worked = account.withdraw(50.0);
        assertTrue(worked, "success withdraw");
        assertEquals(50.0, account.getBalance());
    }

    @Test
    public void testFailedWithdrawal() {
        BankAccount account = new BankAccount();
        account.deposit(100.0);
        account.withdraw(50.0);

        boolean fail = account.withdraw(60.0);
        assertFalse(fail, "should fail");
        assertEquals(50.0, account.getBalance());
    }
}

class BankAccount {
    private double balance = 0.0;

    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
        }
    }

    public boolean withdraw(double amount) {
        if (amount > 0 && amount <= balance) {
            balance -= amount;
            return true;
        }
        return false;
    }

    public double getBalance() {
        return balance;
    }
}
