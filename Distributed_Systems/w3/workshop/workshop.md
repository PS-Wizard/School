1. The Actor class ActorA in the sample Akka program currently responds to only one message object – MessageA.
Modify the createReceive() method so that it will also respond to any other message and print out the message
on the standard output.

```java
~ Catch All Implementation

import akka.actor.AbstractActor;
import akka.actor.ActorSystem;
import akka.actor.Props;

public class Main {
    static class MessageA {
        public final String content;
        public MessageA(String content) {
            this.content = content;
        }
    }

    static class ActorA extends AbstractActor {
        @Override
        public Receive createReceive() {
            return receiveBuilder()
                .match(MessageA.class, msg -> {
                    System.out.println("Received MessageA: " + msg.content);
                })
                .matchAny(msg -> {
                    System.out.println("Received an unknown message: " + msg);
                })
                .build();
        }
    }

    public static void main(String[] args) {
        ActorSystem system = ActorSystem.create("ActorSystem");

        akka.actor.ActorRef actorA = system.actorOf(Props.create(ActorA.class), "actorA");

        actorA.tell(new MessageA("Hello from MessageA"), akka.actor.ActorRef.noSender());
        actorA.tell("Some random message", akka.actor.ActorRef.noSender());

        system.terminate();
    }
}
```
```
~

[wizard@archlinux workshop]$ java Main
Picked up _JAVA_OPTIONS: -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
Received MessageA: Hello from MessageA
Received an unknown message: Some random m:ssage

```

2. Every message in Akka is a Java object. However, not all messages need to have a custom Java class created for them. Convert the sample program so that it can respond to messages that contain the primitive data types such as byte, short, int, long, float, double, boolean, and char, without having to create custom Java classes.

```java
~
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

public class Main {
    public static void main(String[] args) throws Exception {
        ActorSystem system = ActorSystem.create("exampleSystem");

        ActorRef actorA = system.actorOf(Props.create(ActorA.class), "actorA");

        actorA.tell(42, ActorRef.noSender());        
        actorA.tell(3.14, ActorRef.noSender());      
        actorA.tell(true, ActorRef.noSender());      
        actorA.tell('A', ActorRef.noSender());       

        system.terminate();
    }
}
```
```
~

[wizard@archlinux workshop]$ java Main
Picked up _JAVA_OPTIONS: -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
Received Integer: 42
Received Double: 3.14
Received Boolean: true
Received Char: A

```

3. Create 2 Akka Actor classes "ActorA" and "ActorB" to demonstrate the Akka API setReceiveTimeout().ActorA will generate a random integer number from 1 to 5 in a loop for 100 times, and send this integer as a message to ActorB, which would then call Thread.sleep() that many seconds. Set the receive timeout to 2 seconds, and when the timeout triggers, send ActorB a stop() message, and then create a new instance of ActorB to process the next number.
```
~
import akka.actor.*;
import java.util.concurrent.TimeUnit;
import java.util.Random;

public class Main {
    static class ActorA extends AbstractActor {
        @Override
        public Receive createReceive() {
            return receiveBuilder()
                    .matchEquals("start", msg -> {
                        for (int i = 0; i < 100; i++) {
                            int number = new Random().nextInt(5) + 1; 
                            getContext().actorOf(Props.create(ActorB.class)).tell(number, getSelf());
                            Thread.sleep(1000); 
                        }
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
                        System.out.println("ActorB timed out, stopping");
                        getContext().stop(self()); 
                        getContext().actorOf(Props.create(ActorB.class)); 
                    })
                    .build();
        }
    }

    public static void main(String[] args) {
        ActorSystem system = ActorSystem.create("ActorTimeoutSystem");
        ActorRef actorA = system.actorOf(Props.create(ActorA.class));
        actorA.tell("start", ActorRef.noSender()); 
    }
}
```
```
~

[wizard@archlinux workshop]$ java Main
Picked up _JAVA_OPTIONS: -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel
SLF4J: Failed to load class "org.slf4j.impl.StaticLoggerBinder".
SLF4J: Defaulting to no-operation (NOP) logger implementation
SLF4J: See http://www.slf4j.org/codes.html#StaticLoggerBinder for further details.
ActorB received: 5, sleeping for 5 seconds
ActorB received: 4, sleeping for 4 seconds
ActorB received: 1, sleeping for 1 seconds
ActorB received: 2, sleeping for 2 seconds
ActorB finished sleeping for 1 seconds
ActorB received: 1, sleeping for 1 seconds
ActorB finished sleeping for 4 seconds
ActorB finished sleeping for 2 seconds
ActorB received: 1, sleeping for 1 seconds
ActorB finished sleeping for 1 seconds
ActorB finished sleeping for 5 seconds
ActorB timed out, stopping
ActorB finished sleeping for 1 seconds
ActorB received: 3, sleeping for 3 seconds
ActorB received: 3, sleeping for 3 seconds
ActorB timed out, stopping
ActorB timed out, stopping
ActorB timed out, stopping
ActorB timed out, stopping
ActorB received: 5, sleeping for 5 seconds
ActorB timed out, stopping
```

1. Create 3 Akka Actor classes called "Producer", "Supervisor" and "Worker". The "Producer" will generate 1000 random long integer numbers between 10000 and 100000. The "Producer" will send each number as a message to "Supervisor". At start-up, the Supervisor will create 10 "Worker" Actors. When the "Supervisor" receives a number from the "Producer", it will use the API forward() to forward that message to one of the "Worker" actors, in a round-robin fashion. The "Worker" actor will determine if the number in the message is a prime number. If it is a prime number, it will then send a string/text message to the "Producer", saying that "The number XXX is a prime number." And the Producer will print out the message on the standard output. When the 1000 numbers have been produced and checked, the "Producer" actor will terminate the Actor system.

```java
~

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

```
```
~


The number 84313 is a prime number.
The number 70573 is a prime number.
The number 48119 is a prime number.
The number 46507 is a prime number.
The number 36653 is a prime number.
The number 95971 is a prime number.
The number 63347 is a prime number.
The number 72073 is a prime number.
The number 11317 is a prime number.
The number 19087 is a prime number.
The number 95791 is a prime number.
The number 61007 is a prime number.
The number 30389 is a prime number.
The number 53419 is a prime number.
The number 34913 is a prime number.
The number 36299 is a prime number.
The number 45319 is a prime number.
The number 89917 is a prime number.
The number 66959 is a prime number.
The number 56519 is a prime number.
The number 13669 is a prime number.
The number 82471 is a prime number.
The number 67589 is a prime number.
The number 33037 is a prime number.
The number 11923 is a prime number.
The number 63367 is a prime number.
```
