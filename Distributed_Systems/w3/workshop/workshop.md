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

    // Some Other Type
    static class MessageB {
        public final String content;
        public MessageB(String content) {
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
        actorA.tell(new MessageB("Hello from MessageB"), akka.actor.ActorRef.noSender());
        actorA.tell("Some random message", akka.actor.ActorRef.noSender());

        system.terminate();
    }
}
```
```
~

Received MessageA: Hello from MessageA
Received an unknown message: Main$MessageB@519d96d1
Received an unknown message: Some random message

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
3. In standard multithreading programs (for example Pthread programs), shared-resource contention (e.g. global variables) can be an issue and requires the use of mutexes and critical sections. Demonstrate that with Akka Actor, this is not an issue, by creating a "Counter" Actor class to keep track of a global counter, and lots of instances(20) of "ActorA" objects to send messages to "Counter" to increment the global counter.


4. Create 2 Akka Actor classes "ActorA" and "ActorB" to demonstrate the Akka API setReceiveTimeout().ActorA will generate a random integer number from 1 to 5 in a loop for 100 times, and send this integer as a message to ActorB, which would then call Thread.sleep() that many seconds. Set the receive timeout to 2 seconds, and when the timeout triggers, send ActorB a stop() message, and then create a new instance of ActorB to process the next number.
