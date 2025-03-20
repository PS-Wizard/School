1. Change the “work” done to add up numbers. Make the actors do the work before responding to their message senders. Send back the result of the work done to their senders. 2. Rewrite the "prime numbers" task from Week 1 MPI workshop to use Actors instead.
```java
~

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
```
```
~


[wizard@archlinux tutorial]$ java Main
Picked up _JAVA_OPTIONS: -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
A Got: 0
A did some work: 45
B got: 45
B did some work: 90
A Got: 90
A did some work: 135
B encountered the stopping condition: <--- Terminating
```

