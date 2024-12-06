# Data Types

C provides several built-in data types, each with specific sizes and usage.

- **int**: Used for integers.  
- **float**: Used for single-precision floating-point numbers.  
- **double**: Used for double-precision floating-point numbers.  
- **char**: Used for single characters.  

--- 

# Loops

### For Loop:
```c
~ 

#include <stdio.h>

int main() {
    for (int i = 0; i < 5; i++) {
        printf("Iteration %d\n", i);
    }
    return 0;
}
```
```
~

Iteration 0  
Iteration 1  
Iteration 2  
Iteration 3  
Iteration 4
```
> 

### While Loop:

```c
~

#include <stdio.h>

int main() {
    int i = 0;
    while (i < 3) {
        printf("Value of i: %d\n", i);
        i++;
    }
    return 0;
}
```

```
~

Value of i: 0  
Value of i: 1  
Value of i: 2
```
>

### Do While:
```c
~

#include <stdio.h>

int main() {
    int i = 0;
    do {
        printf("Current i: %d\n", i);
        i++;
    } while (i < 2);
    return 0;
}
```
```
~

Current i: 0  
Current i: 1
```

---

# Conditionals:

### If-Else:
```c
~

#include <stdio.h>

int main() {
    int x = 10;
    if (x > 5) {
        printf("x is greater than 5\n");
    } else {
        printf("x is 5 or less\n");
    }
    return 0;
}
```
>

### Switch:
```c
~

#include <stdio.h>

int main() {
    int choice = 2;
    switch (choice) {
        case 1:
            printf("Choice is 1\n");
            break;
        case 2:
            printf("Choice is 2\n");
            break;
        default:
            printf("Invalid choice\n");
    }
    return 0;
}
```

--- 

# Macros:
Macros are used to define constants or functions that are substituted during preprocessing. So basically like a ==global find replace==

### Basic Macro to declare constatns:
```c
~ Defining a macro

#include <stdio.h>

#define PI 3.14

int main() {
    printf("Value of PI: %.2f\n", PI);
    return 0;
}
```
>
### Function like macro:
```c
~

#include <stdio.h>

#define SQUARE(x) ((x) * (x))

int main() {
    printf("Square of 4: %d\n", SQUARE(4));
    return 0;
}
```

### Built-in Macros:

- `__FILE__` : Expands to the name of the current file as a string.

- `__LINE__` : Expands to the current line number in the source file.

- `__DATE__` : Expands to the current date in the format `MMM DD YYYY` when the program was compiled.

- `__TIME__` : Expands to the time the program was compiled in the format `HH:MM:SS`. 

- `__COUNTER__`: Expands to a unique integer that starts at 0 and increments every time it's used in the program. 

**NOTE: `__COUNTER__` is not a built in C thing just a complier extention that compilers like gcc provide**

> 
#### Example: Logging Macros with Built-in Macros.
```c
~

#include <stdio.h>

#define LOG(message) printf("[%s:%d] %s\n", __FILE__, __LINE__, message)

int main() {
    LOG("This is a debug message");
    return 0;
}
```
```
~

[main.c:6] This is a debug message
```

> 
#### Example: Generating Unique Variable Names
```c
~

#include <stdio.h>

#define UNIQUE_VAR_NAME(prefix) prefix##__COUNTER__ // Here, `##` is a token concatenate operator. Check, https://www.geeksforgeeks.org/stringizing-and-token-pasting-operators-in-c/

int main() {
    int UNIQUE_VAR_NAME(var) = 10;  // Expands to var0
    int UNIQUE_VAR_NAME(var) = 20;  // Expands to var1

    printf("var0: %d\n", var0);
    printf("var1: %d\n", var1);

    return 0;
}
```
```
~

var0: 10  
var1: 20

```
---

# Functions

### Basic function:
```c
~

#include <stdio.h>

int add(int a, int b) {
    return a + b;
}

int main() {
    int result = add(3, 5);
    printf("Sum: %d\n", result);
    return 0;
}
```


--- 

# The `#` and `##` Operators:

## Stringizing operator `#`:

The stringizing operator `#` is a preprocessor operator that causes the corresponding actual argument to be enclosed in double quotation marks. The # operator, which is generally called the stringize operator, turns the argument it precedes into a quoted string. It is also known as the stringification operator.

```c
~

#include <stdio.h>

// Macro definition using the stringizing operator
#define mkstr(s) #s
int main(void)
{
    // Printing the stringized value of "geeksforgeeks"
    printf(mkstr(geeksforgeeks));
    return 0;
}
```

```
~ outputs:

geeksforgeeks
```

**Explanation**: The following preprocessor turns `geeksforgeeks`, into `"geeksforgeeks"`

> 

## Token-pasting operator (##):
The Token-pasting operator (##) allows tokens used as actual arguments to be concatenated to form other tokens. It is often useful to merge two tokens into one while expanding macros. This is called token pasting or token concatenation.

```c
~ C program to illustrate (##) operator

#include <stdio.h>

// Macro definition using the Token-pasting operator
#define concat(a, b) a##b
int main(void)
{
    int xy = 30;

    // Printing the concatenated value of x and y
    printf("%d", concat(x, y));
    return 0;
}
```
```
~ Outputs:

30
```
**Explanation**:  The preprocessor transforms `printf("%d", concat(x, y))`; into `printf(“%d”, xy)`;

--- 

# Gold Nuggets:

## I. `getch()`: 
Takes input without requiring the user to press enter. ==Sadly Not Available On Linux / Unix Systems==

>

## II. Using XOR to swap 2 variables without neeeding a temporary variable.
```c
~

#include<stdio.h>
int main(){
    int a=5,b=3;
    printf("a: %d, b: %d\n", a,b);
    a = a ^ b;
    b = a ^ b;
    a = a ^ b;
    printf("a: %d, b: %d\n", a,b);
}
```
>
## III. Assigments return values too

```c
~

#include <stdio.h>

int main() {
    int a;
    int b = (a = 5);  // a is assigned 5, and b gets the value of a (which is 5)
    
    for (char something; (something = getchar()) != '\n';) {
        printf("You entered: %c\n", something);
    }

    int c;
    printf("Assignments return the value declared: %d\n", (c = 5)); // c is assigned 5, and 5 is printed
}
```
>

## IV. Calculate The Length Of A Digit Using `log10()`:

```c
~ The Snippet:
length = (int)log10(n) + 1
```

```c
~ Full Blown Example:

#include <stdio.h>
#include <math.h>

int main() {
    int n;
    printf("Enter a number: ");
    scanf("%d", &n);
    
    // Handle case for 0, since log10(0) is undefined
    if (n == 0) {
        printf("Length: 1\n");
    } else {
        int length = (int)log10(n) + 1;
        printf("Length: %d\n", length);
    }
    
    return 0;
}
```

__Explanation:__
- `log10(n) `calculates the base-10 logarithm of `n`. This gives the highest power of 10 that's less than or equal to `n`.
- Adding 1 gives the total number of digits in the number.
- Special case for `n = 0`: `log10(0)` is undefined, so we handle it separately and print `1` for its length.

