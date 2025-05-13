import akka.actor.*;
import java.util.Random;

public class Main {
    // Add `throws InterruptedException` because of Thread.sleep
    public static void main(String[] args) throws InterruptedException {
        ActorSystem system = ActorSystem.create("BankingSystem");
        ActorRef account = system.actorOf(Props.create(BankAccount.class), "BankAccount");

        Random rand = new Random(420);
        for ( int i = 0; i<10; i++){
            int value = rand.nextInt(2001) - 1000; // shift the range from [0,2000] -> [-1000,1000]
            if (value > 0){
                account.tell(new Deposit(value),ActorRef.noSender());
            } else {
                account.tell(new Withdrawal(-value),ActorRef.noSender());
            }
        }
        
        Thread.sleep(1000); // Ensure Async Calls Go through
        system.terminate();

    }
}
