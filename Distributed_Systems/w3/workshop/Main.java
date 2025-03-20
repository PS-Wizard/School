import akka.actor.*;
import java.util.Random;

public class Main {
    static class ActorA extends AbstractActor {
        private ActorRef currentActorB;

        @Override
        public Receive createReceive() {
            return receiveBuilder()
                    .matchEquals("start", msg -> {
                        int number = new Random().nextInt(5) + 1;
                        currentActorB = getContext().actorOf(Props.create(ActorB.class));
                        currentActorB.tell(number, getSelf());
                    })
                    .match(ActorBTimeout.class, msg -> {
                        System.out.println("ActorB timed out, creating new one");
                        currentActorB = getContext().actorOf(Props.create(ActorB.class));
                    })
                    .build();
        }
    }

    static class ActorB extends AbstractActor {
        {
            getContext().setReceiveTimeout(java.time.Duration.ofSeconds(2));
        }

        @Override
        public Receive createReceive() {
            return receiveBuilder()
                    .match(Integer.class, num -> {
                        System.out.println("ActorB received: " + num + ", sleeping for " + num + " seconds");
                        Thread.sleep(num * 1000);
                        System.out.println("ActorB finished sleeping for " + num + " seconds");
                    })
                    .match(ReceiveTimeout.class, msg -> {
                        System.out.println("ActorB timed out, notifying ActorA");
                        getContext().getParent().tell(new ActorBTimeout(), getSelf());
                        getContext().stop(self());
                    })
                    .build();
        }
    }

    static class ActorBTimeout {}

    public static void main(String[] args) {
        ActorSystem system = ActorSystem.create("ActorTimeoutSystem");
        ActorRef actorA = system.actorOf(Props.create(ActorA.class));
        actorA.tell("start", ActorRef.noSender());
    }
}
