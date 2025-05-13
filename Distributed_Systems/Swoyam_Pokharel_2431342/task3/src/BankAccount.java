import akka.actor.*;

public class BankAccount extends AbstractActor {
    private double balance = 100.00;

    public void preStart(){
        System.out.println(String.format("Initial Balance: $%.2f", balance));
    }
    
    public Receive createReceive(){
        return receiveBuilder()

            .match(Deposit.class, deposit -> {
                this.balance += deposit.amount;
                System.out.println(String.format("Deposited: $%.2f, New Balance: $%.2f", deposit.amount, this.balance ));
            })

            .match(Withdrawal.class, withdrawl -> {

                if (this.balance < withdrawl.amount){
                    System.out.println(String.format("Insufficient Funds; Have: $%.2f, Tried To Withdraw: $%.2f", this.balance, withdrawl.amount));
                    return;
                }

                this.balance -= withdrawl.amount;
                System.out.println(String.format("WithDrew: $%.2f, New Balance: $%.2f", withdrawl.amount, this.balance ));
            })

            .build();
    }

}
