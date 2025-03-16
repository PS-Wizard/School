import akka.actor.*;
import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) throws Exception {
        ActorSystem system = ActorSystem.create("exampleSystem");

        ActorRef actorA = system.actorOf(Props.create(ActorA.class), "counterthing");

        List<ActorRef> actors = new ArrayList<>();
        for (int i = 0; i < 20; i++) {
            ActorRef actorA = system.actorOf(Props.create(ActorA.class, counter), "actorA" + i);
            actors.add(actorA);
            actorA.tell("increment", ActorRef.noSender()); 
        }

        try {
            Thread.sleep(2000); 
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        system.terminate();
    }
}

class Counter extends AbstractActor {
    
}
class ActorA extends AbstractActor {
    @Override
    public Receive createReceive() {
        return receiveBuilder()
        .match(Integer.class, number -> {
            System.out.println("Received Integer: " + number);
        })
        .match(Double.class, number -> {
            System.out.println("Received Double: " + number);
        })
        .match(Boolean.class, value -> {
            System.out.println("Received Boolean: " + value);
        })
        .match(Character.class, character -> {
            System.out.println("Received Char: " + character);
        })
        .build();
    }
}

