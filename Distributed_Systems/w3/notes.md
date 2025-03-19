# Stateful Actors
==Akka automatically preserves state for any variable used within an actor==
```java
import akka.actor.*;

class CounterActor extends AbstractActor {
    private int counter = 0;

    public Receive createReceive() {
        return receiveBuilder()
            .match(String.class, msg -> {
                if (msg.equals("idk")){
                    counter ++;
                    System.out.println("Counter: " + counter);
                }
            })
            .build();
    }
}

public class Main {
    public static void main(String[] args) {
        ActorSystem system = ActorSystem.create("States");
        ActorRef counterRef = system.actorOf(Props.create(CounterActor.class),"Counter_Actor");
        counterRef.tell("idk",ActorRef.noSender());
        counterRef.tell("idk",ActorRef.noSender());
        counterRef.tell("idk",ActorRef.noSender());
        counterRef.tell("idk",ActorRef.noSender());
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
Counter: 1
Counter: 2
Counter: 3
Counter: 4
```
>
# LifeCycle Hooks

```java
~

import akka.actor.*;

class ActorLifecycle extends AbstractActor {

    public void preStart(){
        System.out.println("Before Starting");
    }

    public void postStop(){
        System.out.println("After Ending");
    }
    public Receive createReceive() {
        return receiveBuilder()
            .match(String.class, msg -> {
                    System.out.println("Received: " + msg);
            })
            .build();
    }
}

public class Main {
    public static void main(String[] args) {
        ActorSystem system = ActorSystem.create("LifeCycle");
        ActorRef counterRef = system.actorOf(Props.create(ActorLifecycle.class),"ActorLifecycle");
        counterRef.tell("idk",ActorRef.noSender());
        counterRef.tell("idk",ActorRef.noSender());
        counterRef.tell("idk",ActorRef.noSender());
        counterRef.tell("idk",ActorRef.noSender());
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
Before Starting
Received: idk
Received: idk
Received: idk
Received: idk
After Ending
```
