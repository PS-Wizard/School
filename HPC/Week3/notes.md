### Refresher 101:
---

basic stuff:
```c
// Standard for loop
for (int i = 0; i < 10; i++) { }

// While loop
while (condition) { }

// Do-while (executes at least once)
do { } while (condition);

// If-else
if (condition) { } else { }
```

Fancier stuff:
```c
// Declare and use multiple variables
for (int i = 0, j = 10; i < j; i++, j--) {
    printf("%d %d\n", i, j);
}

// Use comma operator (but only one declaration type)
int j = 10;
for (int i = 0; i < 5; i++, j -= 2) {
    printf("%d %d\n", i, j);
}


// For loop with no initialization or increment
int i = 0;
for (; i < 10;) {
    i++;
}

// Infinite loop (cleaner than while(1))
for (;;) {
    // do stuff
    if (condition) break;
}

```
---
### Conditionals

```c
// Ternary operator (condition ? true_value : false_value)
int max = (a > b) ? a : b;

// One-liner if with comma operator
if (condition) x++, y--, z = 0;

// Short-circuit evaluation for side effects
(ptr != NULL) && (*ptr = value);  // Only assigns if ptr is not NULL

// Combining loop and condition
for (int i = 0; i < n && arr[i] != target; i++);
```
---
### Comma operator magic

Execute multiple statements, return last value
```c
int x = (printf("Hello\n"), 5 + 3);  // x = 8, but prints "Hello"

// In loops
while (read_input(), process_data(), check_condition()) {
    // do stuff
}
```
---
### Switch statement tricks

```c
// Fall-through for multiple cases
switch (c) {
    case 'a': case 'e': case 'i': case 'o': case 'u':
        printf("Vowel\n");
        break;
    case '0' ... '9':  // GCC extension: range
        printf("Digit\n");
        break;
}
```
---

## Pointers
Just a variable that stores the memory location of another variable. 

```c
int x = 42;
int *ptr = &x;  // ptr holds the ADDRESS of x

// & = "address of" operator
// * = "dereference" operator (go to that address and get/set the value)

printf("%p\n", (void*)ptr);   // Print the address
printf("%d\n", *ptr);          // Print the value at that address (42)
*ptr = 100;                    // Change the value at that address
```


```c
int arr[5] = {10, 20, 30, 40, 50};
int *p = arr;  // Arrays decay to pointers

// These are ALL equivalent:
arr[3]        // Array indexing
*(arr + 3)    // Pointer arithmetic
*(p + 3)      // Same thing
p[3]          // Pointers can use array syntax!
3[arr]        // This actually works! (cursed but legal)

// Why does 3[arr] work?
// Because arr[3] is just *(arr + 3)
// And addition is commutative, so *(arr + 3) == *(3 + arr) == 3[arr]
```
