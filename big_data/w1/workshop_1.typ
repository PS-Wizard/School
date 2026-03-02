#import "@preview/hetvid:0.1.0": *
#show: hetvid.with(
  title: [Worksheet 1],
  author: "Sushil Timilsina",
  affiliation: "Swoyam Pokharel",
  header: "Worksheet 1",
  toc: true,
)

#pagebreak()
= Exercise on Loops

== Task 1: Fibonacci Series

Display the Fibonacci series up to 10 terms.

```python
"""Display Fibonacci series up to 10 terms."""
a, b = 0, 1
for _ in range(10):
    print(a, end=" ")
    a, b = b, a + b
print()
```

```
--- Output ---
0 1 1 2 3 5 8 13 21 34
```

#line(length: 100%, stroke: 0.4pt + luma(160))

== Task 2: Factorial

Find the factorial of a given number. The user provides the number.

```python
"""Find the factorial of a user-provided number."""
num = int(input("Enter a number: "))
factorial = 1
for i in range(1, num + 1):
    factorial *= i
print(f"Factorial of {num} is {factorial}")
```

```
--- Output ---
Enter a number: 6
Factorial of 6 is 720
```

#line(length: 100%, stroke: 0.4pt + luma(160))

== Task 3: Right Angle Triangle

Print a right angle triangle using a for loop.

```python
"""Print a right angle triangle using for loop."""
rows = 5
for i in range(1, rows + 1):
    print("*" * i)
```

```
--- Output ---
*
**
***
****
*****
```

#line(length: 100%, stroke: 0.4pt + luma(160))

#pagebreak()
= Exercise on Functions

== Task 1: Simple Calculator

A calculator that can add, subtract, multiply, and divide two numbers using functions.

```python
def add(a, b):      return a + b
def subtract(a, b): return a - b
def multiply(a, b): return a * b
def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero.")
    return a / b

operations = {
    "1": ("Add",      add),
    "2": ("Subtract", subtract),
    "3": ("Multiply", multiply),
    "4": ("Divide",   divide),
}

print("1) Add\n2) Subtract\n3) Multiply\n4) Divide")
op = input("Choose an operation: ")

if op not in operations:
    print("Invalid choice.")
else:
    try:
        a = float(input("Enter first number: "))
        b = float(input("Enter second number: "))
        name, func = operations[op]
        print(f"{name}: {func(a, b)}")
    except ValueError as e:
        print(f"Error: {e}")
```

```
--- Output ---
1) Add
2) Subtract
3) Multiply
4) Divide
Choose an operation: 3
Enter first number: 12
Enter second number: 7
Multiply: 84.0
```

#line(length: 100%, stroke: 0.4pt + luma(160))

#pagebreak()
= Exercise on Lists and Dictionaries

== Task 1: Remove First Duplicate Element

Remove the first duplicate element found in a list.

```python
"""Remove the first duplicate element of a list."""
my_list = [1, 2, 3, 2, 4, 5, 3]
seen = set()
for item in my_list:
    if item in seen:
        my_list.remove(item)
        break
    seen.add(item)
print("List after removing first duplicate:", my_list)
```

```
--- Output ---
List after removing first duplicate: [1, 3, 2, 4, 5, 3]
```

#line(length: 100%, stroke: 0.4pt + luma(160))

== Task 2: Extract Keys from Dictionary

Extract specific keys from a given dictionary to create a new one.

```python
sample_dict = {"name": "Anderson", "age": 35, "salary": 5000, "city": "London"}
keys = ["name", "salary"]

new_dict = {k: sample_dict[k] for k in keys if k in sample_dict}
print(new_dict)
```

```
--- Output ---
{'name': 'Anderson', 'salary': 5000}
```

#line(length: 100%, stroke: 0.4pt + luma(160))

== Task 3: Convert Two Lists into a Dictionary

Combine two lists so that items from the first list become keys and items from the second become values.

```python
list_one = ['one', 'two', 'three']
list_two = [1, 2, 3]

result = dict(zip(list_one, list_two))
print(result)
```

```
--- Output ---
{'one': 1, 'two': 2, 'three': 3}
```

#line(length: 100%, stroke: 0.4pt + luma(160))


