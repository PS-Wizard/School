import akka.actor.*;
import java.util.Random;
import java.util.concurrent.atomic.AtomicInteger;

public class Main {
    static class Producer extends AbstractActor {
        private final ActorRef supervisor;

        public Producer(ActorRef supervisor) {
            this.supervisor = supervisor;
        }

        @Override
        public Receive createReceive() {
            return receiveBuilder()
                    .matchEquals("start", msg -> {
                        Random rand = new Random();
                        for (int i = 0; i < 1000; i++) {
                            long number = 10000 + rand.nextInt(90000); 
                            supervisor.tell(number, getSelf());
                        }
                    })
                    .match(String.class, msg -> {
                        System.out.println(msg); 
                        if (msg.equals("done")) {
                            getContext().getSystem().terminate(); // Terminate actor system after all numbers are processed
                        }
                    })
                    .build();
        }
    }

    // Supervisor Actor: Receives numbers from the Producer and forwards them to Worker actors
    static class Supervisor extends AbstractActor {
        private final ActorRef[] workers = new ActorRef[10];
        private final AtomicInteger roundRobinCounter = new AtomicInteger(0);

        public Supervisor() {
            for (int i = 0; i < 10; i++) {
                workers[i] = getContext().actorOf(Props.create(Worker.class), "worker-" + i);
            }
        }

        @Override
        public Receive createReceive() {
            return receiveBuilder()
                    .match(Long.class, number -> {
                        ActorRef worker = workers[roundRobinCounter.getAndIncrement() % workers.length];
                        worker.tell(new Worker.Task(number, getSender()), getSelf());
                    })
                    .build();
        }
    }

    static class Worker extends AbstractActor {
        public static class Task {
            public final long number;
            public final ActorRef producer;

            public Task(long number, ActorRef producer) {
                this.number = number;
                this.producer = producer;
            }
        }

        @Override
        public Receive createReceive() {
            return receiveBuilder()
                    .match(Task.class, task -> {
                        if (isPrime(task.number)) {
                            String message = "The number " + task.number + " is a prime number.";
                            task.producer.tell(message, getSelf()); 
                        }
                    })
                    .build();
        }


        private boolean isPrime(long number) {
            if (number <= 1) return false;
            if (number <= 3) return true;  
            if (number % 2 == 0 || number % 3 == 0) return false;  

            for (long i = 5; i * i <= number; i += 6) {
                if (number % i == 0 || number % (i + 2) == 0) {
                    return false;  
                }
            }
            return true;
        }
    }

    public static void main(String[] args) {
        ActorSystem system = ActorSystem.create("PrimeNumberSystem");
        ActorRef supervisor = system.actorOf(Props.create(Supervisor.class), "supervisor");
        ActorRef producer = system.actorOf(Props.create(Producer.class, supervisor), "producer"); // the second argument is for the constructor
        producer.tell("start", ActorRef.noSender());

        system.terminate();
    }
}
