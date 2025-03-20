import akka.actor.*;

class A extends AbstractActor {
    private ActorRef b;

    public A(ActorRef b) {
        this.b = b;
    }

    public Receive createReceive() {
        return receiveBuilder()
            .match(Integer.class, sumFromB -> {
                if (sumFromB <= 100) {
                    System.out.println("A Got: " + sumFromB);
                    sumFromB += 45;
                    System.out.println("A did some work: " + sumFromB);
                    b.tell(sumFromB, getSelf());
                } else {
                    System.out.println("A encountered the stopping condition: <--- Terminating" );
                    getContext().getSystem().terminate();
                }
            })
            .build();
    }
}

class B extends AbstractActor {
    public Receive createReceive() {
        return receiveBuilder()
            .match(Integer.class, sumFromA -> {
                if (sumFromA <= 100) {
                    System.out.println("B got: " + sumFromA);
                    sumFromA += 45;
                    System.out.println("B did some work: " + sumFromA );
                    getSender().tell(sumFromA , getSelf());
                } else {
                    System.out.println("B encountered the stopping condition: <--- Terminating" );
                    getContext().getSystem().terminate();
                }
            })
            .build();
    }
}

public class Main {
    public static void main(String[] args) {
        ActorSystem system = ActorSystem.create("PingPongSystem");
        ActorRef b = system.actorOf(Props.create(B.class), "B");
        ActorRef a = system.actorOf(Props.create(A.class, b), "A");
        
        a.tell(0, ActorRef.noSender());
    }
}
