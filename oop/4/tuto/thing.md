## I. Create an abstract class Shape
### The Shape class has two abstract methods: calculateArea() and calculatePerimeter. Both the methods have a return type of void
 
```java
~

abstract class Shape {
    abstract void calculateArea();
    abstract void calculatePerimeter();
}
```
> 
### Create a class Quadrilateral which extends the abstract class Shape, Implement all the abstract method of the parent class

```java
~

class Quadilateral extends Shape {

    @Override 
        void calculateArea() {
            System.out.println("Prints Area");
        }
    @Override 
        void calculatePerimeter() {
            System.out.println("Prints Perimenter");
        }
}

public class main {
    public static void main(String[] args) {
    }
}
```

--- 

## II. Create an abstract class named Vehicle which consist of two methods: wheel and door. Both the methods have void return type and no parameters. The method wheel has no implementation.
```java
~

abstract class Vehicle {
    void Door(){
        System.out.println("This prints door");
    };
    abstract void Wheel();
}
```
> 
### Create a class name Bus and extend the Vehicle class.
```java
~

abstract class Vehicle {
    void Door(){
        System.out.println("This prints door");
    };
    abstract void Wheel();
}

class Bus extends Vehicle {
   
    @Override 
    void Wheel() {
        System.out.println("Prints Wheel");
    }
}
public class main {
    public static void main(String[] args) {
    }
}
```
---

## III. Create an interface Animal. The Animal interface has two methods eat() and walk()

```java
~

interface Animal {
    void eat(); // gets converted to abstract void eat() implicitly
    void walk();
}
```
>

### Create another interface Printable. The Printable interface has a method called display()
```java
~

interface Printable{
    void display();
}
```

> 
### Create a class Cow that implements the Animal and Printable interfaces
```java
~

class Cow implements Animal,Printable {

    @Override void eat() { System.out.println("cow Eats"); }

    @Override void walk() { System.out.println("Walks cow"); }

    @Override void display() { System.out.println("Displays Cow"); }
}
```

---

## IV. Create an interface LivingBeing

```java
~

interface LivingBeing {
}

```

### Create an method void specialFeature()
```java
~

interface LivingBeing {
    void specialFeature(); 
}
```

### Create 2 classes Fish and Bird that implements LivingBeing
```java
~

class Fish implements LivingBeing{
    @Override
    public void specialFeature(){}
}

class Bird implements LivingBeing{
    @Override
    public void specialFeature(){}
}
```

### The specialFeature should display special features of the respective class animal.

```java
~

class Fish implements LivingBeing{
    @Override
    public void specialFeature(){
        System.out.println("Fish can swim");
    }
}

class Bird implements LivingBeing{
    @Override
    public void specialFeature(){
        System.out.println("Bird can fly");
    }
}
```
