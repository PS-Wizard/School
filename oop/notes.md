## Data Types
Java has several data types for different kinds of data:
- **Primitives**: `int`, `double`, `char`, `boolean`, etc.

- **Objects**: `String`, arrays (`int[]`, `String[]`), etc.

### Examples:
```java
~

int num = 10;
double price = 99.99;
char letter = 'A';
boolean isJavaFun = true;
String message = "Hello, Java!";
int[] numbers = {1, 2, 3, 4, 5};
```
--- 

## Loops:

```java
~

for (int i = 0; i < 5; i++) {
    System.out.println("Iteration: " + i);
}
```
>
```java
~

int i = 0;
while (i < 5) {
    System.out.println("Iteration: " + i);
    i++;
}

```

---

## Conditionals:

### I. `If` and shits:
```java
~

int num = 15;

if (num < 10) {
    System.out.println("Less than 10");
} else if (num < 20) {
    System.out.println("Between 10 and 19");
} else {
    System.out.println("20 or greater");
}
```

```java
~

int num = 10;
String result = (num > 5) ? "Greater than 5" : "5 or less";
System.out.println(result);

```
>

### II. `switch` and `yield`:
```java
~

public class Main {
    public static void main(String[] args) {
        int day = 3;

        String dayType = switch (day) {
            case 1, 7 -> "Weekend";
            case 2, 3, 4, 5, 6 -> {
                yield "Weekday"; // Using yield to return a value
            }
            default -> "Invalid day";
        };

        System.out.println("Day type: " + dayType);
    }
}
```

### Explanation:
- The `yield` keyword is used to return a value from a `case` block in a switch expression.

- Useful when a `case` block contains more than one statement (like in the Weekday case above).

### Why cant we use `return` instead of `yield`?
- `return` exits the entire method where the `switch` resides.

- `yield` exists only the `switch` statement and provides a value to the `switch` expression

### TL;DR:
- use `yield` in a `switch` expression to return a value to the switch.

- use `return` to return out of **methods**, not expression.

---

# Inputs:

## I. User input with `Scanner`:
```java
~

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("Enter your name: ");
        String name = scanner.nextLine();

        System.out.print("Enter your age: ");
        int age = scanner.nextInt();

        System.out.println("Hello, " + name + ". You are " + age + " years old.");
    }
}
```

| Method            | Description                                      | Example Usage                                  |
|-------------------|--------------------------------------------------|------------------------------------------------|
| `nextLine()`      | Reads an entire line of text (including spaces)  | `String line = scanner.nextLine();`            |
| `next()`          | Reads a single word (without spaces)             | `String word = scanner.next();`                |
| `nextInt()`       | Reads an integer                                  | `int num = scanner.nextInt();`                 |
| `nextDouble()`    | Reads a double (decimal number)                  | `double price = scanner.nextDouble();`         |
| `nextFloat()`     | Reads a float (single-precision decimal number)  | `float weight = scanner.nextFloat();`          |
| `nextBoolean()`   | Reads a boolean value (`true` or `false`)        | `boolean isTrue = scanner.nextBoolean();`      |
| `nextByte()`      | Reads a byte                                    | `byte b = scanner.nextByte();`                 |
| `nextShort()`     | Reads a short (16-bit integer)                   | `short s = scanner.nextShort();`               |
| `nextLong()`      | Reads a long (64-bit integer)                    | `long l = scanner.nextLong();`                 |
| `nextLine()`      | **Important Tip**: Reads the newline after `nextInt` or `next` | `String leftover = scanner.nextLine();`         |

### Explanation for the last thing on the table:

When you use `nextInt()`, `nextDouble()`, or any other method that reads a primitive value (like `nextInt()`), it doesn't consume the newline character `\n` left in the input buffer when you hit "Enter" after entering a number. The next time you use `nextLine()`, it will immediately read that leftover newline as an empty string instead of waiting for new input.

>

## II. File Handling:

### 1.  `try-with-resources` with `FileWriter` and `FileReader`:

```java
~

import java.io.FileWriter;
import java.io.FileReader;
import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        // Writing to a file
        try (FileWriter writer = new FileWriter("example.txt")) { // specify FileWriter("example.txt",true) to append.
            writer.write("Hello, Java!");
        } catch (IOException e) { // Or if you dont wana include java.io.IOException, just do catch (Exception e)
            e.printStackTrace();
        }

        // Reading from a file
        try (FileReader reader = new FileReader("example.txt")) {
            int ch;
            while ((ch = reader.read()) != -1) {
                System.out.print((char) ch);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

```
>
### 2. `BufferedWriter` and `BufferedReader`:

It just wraps around the `FileWriter` and `FileReader`

```java
~

import java.io.BufferedWriter;
import java.io.BufferedReader;
import java.io.FileWriter;
import java.io.FileReader;
import java.io.IOException;

public class Main {
    public static void main(String[] args) {
        // Writing with BufferedWriter
        try (BufferedWriter writer = new BufferedWriter(new FileWriter("example.txt"))) {
            writer.write("Hello, Buffered Java!");
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Reading with BufferedReader
        try (BufferedReader reader = new BufferedReader(new FileReader("example.txt"))) {
            String line;
            while ((line = reader.readLine()) != null) { // Notice here, assignments return assigned values too
                System.out.println(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

```


---

# Diggin Gold Baby:


## `static`:
```java
~

class Counter {
    static int count = 0;  // Static variable shared across all instances

    // Static method
    static void increment() {
        count++;
    }
}

public class Main {
    public static void main(String[] args) {
        // Creating multiple objects
        Counter c1 = new Counter();
        Counter c2 = new Counter();

        c1.increment();  // Increments the static count variable
        c2.increment();  // Increments the static count variable

        // Both objects share the same static variable 'count'
        System.out.println("Count from c1: " + c1.count);  // Output: 2
        System.out.println("Count from c2: " + c2.count);  // Output: 2
    }
}
```
>
```java
~

class MathHelper {
    // Static method
    static int square(int x) {
        return x * x;
    }
}

public class Main {
    public static void main(String[] args) {
        // Calling static method without creating an object
        int result = MathHelper.square(5);
        System.out.println("Square of 5 is: " + result);  // Output: 25
    }
}
```

### Bullet Points:
- __Static variables__ are __shared across all instances of a class__. When one object changes the static variable, the change is reflected in all other objects.

- __Static Methods__ can be __called without an object__

- __Static methods and variables__ belong to the __class itself__ rather than to individual instances.


## `abstract` and `interface`:

They Both Are Basically prototyping things. `abstract` can have both prototypes and like fully implemented functions, `interface`  can only have abstracts (prototypes). Any Other class that `extends` or `implements` them needs to overwrite the abstract (or again prototyped) methods.

so say
```java
~

abstract class Employee {
    abstract void calculateSalary();
    void getDetails() {
        System.out.println("Some Details");
    }
}
```

There, we have an abstract (or just a prototype) of a method `calculateSalary()`, but we also have a fully implemented `getDetails()` ( i mean fully is a lil subjective lmao its just 1 line but still). So any other method, that `extends` of this `Employee` class (`extends` because its an `abstract` class ) needs to overwrite the un-implemented method `calculateSalary()`. It can still override the `getDetails` method but its not mandatory.
```java
~ FullTimeEmployee needs to provide an implementation for the abstract function calculateSalary().

class FullTimeEmployee extends Employee{

    public void calculateSalary(){
        System.out.println(3000 * 30);
    }
}
```
>

__Whats up with interfaces then?__

Interfaces are basically the same thing as an `abstract` class except that they can't have implementations. So just pure prototyping.
```java
~

interface Shape {
    void calculateArea(int radius); 
    void calculatePerimeter(int radius); 
    
    void calculateArea(int length, int breadth); 
    void calculatePerimeter(int length, int breadth); 
}
```

In this case we have an `interface Shape` and every method inside that `interface block` is implicitly converted into an `public abstract ...` method so it becomes:

```java
~

interface Shape {
    public abstract void calculateArea(int radius); 
    public abstract void calculatePerimeter(int radius); 

    public abstract void calculateArea(int length, int breadth); 
    public abstract void calculatePerimeter(int length, int breadth); 
}
```

And, the same rule applies , every `abstract` method needs to have an implementation, so any class that `implements` (`implements` because its an `interface`) this interface needs to provide an implementation for those abstract methods.
```java
~

class Circle implements Shape{
    public static final double PI = 3.141592653; 

    public void calculateArea(int radius) {
        System.out.println("Area of Circle: " + PI * radius * radius);
    }

    public void calculatePerimeter(int radius) {
        System.out.println("Perimeter of Circle: " + 2 * PI * radius);
    }

    public void calculatePerimeter(int l,int b){}
    public void calculateArea(int l,int b){}

}
```

__Random Note__:

In the circle class we cant simply do  say :
```java
~

void calculatePerimeter(int radius) {
    System.out.println("Perimeter of Circle: " + 2 * PI * radius);
}
```

because if we dont have an access modifier, compiler implicitly adds  `default` as the access modifier, but since interface has `public abstract` , we cant use a `default` in place for a method that has a `public` access modifier.
