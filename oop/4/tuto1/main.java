class BankAccount {
    private String accountNumber;
    private double balance;

    public BankAccount(String accountNumber, double balance) {
        this.accountNumber = accountNumber;
        if (balance >= 0) {
            this.balance = balance;
        } else {
            this.balance = 0;
        }
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        if (balance >= 0) {
            this.balance = balance;
        }
    }

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
}


public class main {
    public static void main(String[] args) {
        BankAccount account = new BankAccount("123456789", 500.00); 
        System.out.println("account number: " + account.getAccountNumber());
        System.out.println("balance: " + account.getBalance());
        account.deposit(200);
        System.out.println("balance: " + account.getBalance());
        if (account.withdraw(100)) {
            System.out.println("successful, balance: " + account.getBalance());
        } else {
            System.out.println("withdrawal failed, insufficient ");
        }

        if (account.withdraw(700)) {
            System.out.println("successful, Balance: " + account.getBalance());
        } else {
            System.out.println("withdrawal failed, insufficient .");
        }

        account.setBalance(1000);
        System.out.println("balance: " + account.getBalance());
    }
}
