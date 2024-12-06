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

>

## V. Why Does Pointer Arithmetic even work?

Thinking this through, say we have an array of int of 5 size so,
```c
~
int arr[] = [1,2,3,4,5];
```

Here `arr` points to the adress of the first element in the array, so it points to where `1` is stored. And, we know that , say if &arr[0]  = `"0x00000",` then &arr[1] = `"0x00004",` since the array is of type `int`, which takes 4 bytes, makes sense. But if thats the case, how on gods green earth does pointer arithmetic even work?
because,

```c
~
arr[1] essentially is  *(arr+1)
```

but if `arr` is a pointer to the first element, in our case `1`, and has the adress `"0x0000"` then, `*(arr+1)` is just, `*(0x0000 + 1)` which results in `*(0x0001)`?
But, we know that `arr[1]` is at `"0x00004"`?

>
__What happens with `*(arr+1)`?__

When you do `*(arr+1)`, here's what actually goes on step by step:

1. `arr` is a pointer to the first element of the array (i.e., `&arr[0]`)

    - Say `arr = 0x1000` for an example,

2. `arr + 1`:

    - The compiler knows the type of `arr` is `int *`.

    - So it calculates the adress for the next `int` element by doing:

    ```c
    ~

    Address = Base Address + (sizeof(int) * 1)
            = 0x1000 + 4
            = 0x1004

    ```

3. `*(arr + 1)` :
    - It dereferences the adress `0x1004`, so you get the value stored there (e.g `arr[1]`);

>
__What's it equivalent to?__
If we wrote it manually, yeah, it’d look like this:
```c
~ 

*(arr + 1) == *(int *)((char *)arr + sizeof(int) * 1)
```

Here’s what’s happening in that mess:

1. `(char *)arr`:

    - converts `arr` into a `char *`, meaning now we view it as a pointer to __individual bytes__.

    - TL;DR: This is just to prevent the compiler from automatically inserting the offset of `4` bytes which is the default for the `int *` pointer type when doing pointer arithmetic, by casting it with `char *` which takes `1` byte

2. ` + sizeof(int) * 1`:

    - Adds 4 bytes to the base address (since `sizeof(int) = 4`)

3. `(int *)`:

    - converts the address back to an (int *) so the compiler knows it's pointing to an integer.

4. `*` :

    - Dereferences the final `int *` pointer, giving you the actual value stored at the calculated address.

>

__Why Use `char`__ ?

When you do arithmetic with `int *`, the compiler automatically scales by `sizeof(int)` (i.e., 4 bytes). That’s convenient, but you lose the ability to move through memory byte-by-byte.

Casting to `char *` disables the scaling, Now, every increment is just __+1 byte__, giving you full control over the raw memory.
```c
~

int arr[5] = {10, 20, 30, 40, 50};
int *intPtr = arr;
char *bytePtr = (char *)arr;

printf("intPtr + 1: %p\n", intPtr + 1);  // Skips 4 bytes: 0x1004
printf("bytePtr + 1: %p\n", bytePtr + 1); // Skips 1 byte: 0x1001
```

__TL;DR:__

- Scaling in pointer arithmetic basically means " By What Offset Should I Add To A Certain Data Type",

- An `int *` pointer moves in __4-byte chunks__, 

- But an `char *` it just moves in __1-byte chunks__, 

The compiler does this scaling automatically because it knows what type you're working with. This scaling ensures that when you say `ptr + 1`, it moves the pointer to the next element in memory, not just the next byte. 

In That Example of Manually Moving the pointer in pointer arithmetic we used char, to disable the compiler automatically scaling the offset for the pointer arithmetic

>

##  Example scaling in action:


### Memory Layout (Example):

```c
~

int arr[3] = {10, 20, 30};
```
The memory layout (Assuming `sizeof(int) = 4`):

| Address | Value |
|---|---|
0x100|10|
0x104|20|
0x108|30|

__using an__ `int *`

```c
~

int *intPtr = arr;
intPtr + 1;  // Moves to the next int element (4 bytes forward)

// intPtr now points to address 0x1004

```

__using an__  `char *`:
```c
~

char *bytePtr = (char *)arr;
bytePtr + 1;  // Moves to the next byte (1 byte forward)

// bytePtr now points to address 0x1001
```
>

### Inspecting Memory Byte-By-Byte:
```c
~

int arr[3] = {10, 20, 30};
char *bytePtr = (char *)arr;

// Print each byte in the array
for (int i = 0; i < 12; i++) {  // 3 ints * 4 bytes each = 12 bytes
    printf("Byte %d: %x\n", i, bytePtr[i]);
}
```
```
~

Byte 0: a   // Low byte of 10
Byte 1: 0
Byte 2: 0
Byte 3: 0
Byte 4: 14  // Low byte of 20 ( 14 hex in bytes is 00001010 = 20)
Byte 5: 0
Byte 6: 0
Byte 7: 0
Byte 8: 1e  // Low byte of 30 .. 
Byte 9: 0
Byte 10: 0
Byte 11: 0
```
