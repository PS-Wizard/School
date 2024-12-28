## Create a structure named student that has a name, roll number and marks as members. Assume appropriate types and size of members. Use this structure to read and display records of n number of students (n is given by the user). Create two functions: One is to read information of students and other to display the information.
```c
~

#include <stdio.h>
#include <stdlib.h>

struct student {
    char name[10];
    unsigned roll;
    unsigned marks;
};

int main() {
    unsigned n;
    printf("Enter the number of students: ");
    scanf("%u", &n);

    struct student* ptr = malloc(n * sizeof(struct student));
    if (ptr == NULL) {
        printf("Memory allocation failed\n");
        return 1; 
    }

    for (unsigned i = 0; i < n; i++) {
        printf("Enter fields (Name, Roll, Marks) separated by spaces: ");
        scanf("%s %u %u", ptr[i].name, &ptr[i].roll, &ptr[i].marks);
    }

    for (unsigned i = 0; i < n; i++) {
        printf("Name: %s, Roll: %u, Marks: %u\n", ptr[i].name, ptr[i].roll, ptr[i].marks);
    }

    free(ptr);
    return 0;
}
```
```c
~

#include <stdio.h>
#include <stdlib.h>

struct student {char name[10]; unsigned roll, marks;};

void takeInput(struct student* std) {
    scanf("%s %u %u", std->name, &std->roll, &std->marks);
}

void print(struct student* std) {
    printf("Name: %s, Roll: %u, Marks: %u\n", std->name, std->roll, std->marks);
}

int main() {
    unsigned n;
    scanf("%u", &n);
    struct student* ptr = malloc(n * sizeof(struct student));
    for (unsigned i = 0; i < n; i++) takeInput(&ptr[i]);
    for (unsigned i = 0; i < n; i++) print(&ptr[i]);
    free(ptr);
    return 0;
}
```
```
~
3
a 1 100
b 2 100
c 3 100
Name: a, Roll: 1, Marks: 100
Name: b, Roll: 2, Marks: 100
Name: c, Roll: 3, Marks: 100
[wizard@archlinux labreport]$ 
```
>
## WAP to input name, post and salary of ten employees from main () function and pass to structure type user defined function (argument of this function should also be a structure type). This function returns a structure variable which keeps the record of only those employees whose salary is greater than 10,000. This modified record is also displayed from the main () function.
```c
~

#include <stdio.h>

struct employee {char name[30]; char post[20]; unsigned salary;};

struct employee* filter(struct employee* emp) {
    return emp->salary > 10000 ? emp : NULL;
}

int main() {
    struct employee emps[10];
    for (int i = 0; i < 10; i++) {
        scanf("%s %s %u", emps[i].name, emps[i].post, &emps[i].salary);
    }

    for (int i = 0; i < 10; i++) {
        struct employee* filtered = filter(&emps[i]);
        if (filtered)  // Only print if valid
            printf("Name: %s, Post: %s, Salary: %u\n", filtered->name, filtered->post, filtered->salary);
    }

    return 0;
}
```
```
~

[wizard@archlinux labreport]$ ./a.out 
a b 10000
c d 10001
e f 10002
Name: c, Post: d, Salary: 10001
Name: e, Post: f, Salary: 10002
[wizard@archlinux labreport]$ 
```
>
## Write a program that asks the user for two inputs: lower limit and upper limit. Now write a function named display() that prints all the numbers between those limits. NOTE: You are only allowed to pass one parameter to the function and lower limit and upper limit variables should not be made as global variables.
```c
~

#include <stdio.h>

void display(int lower) {
    int upper;
    scanf("%d", &upper);
    for (int i = lower; i <= upper; i++) 
        printf("%d ", i);
}

int main() {
    int lower;
    scanf("%d", &lower);
    display(lower);
    return 0;
}
```
```
~

[wizard@archlinux labreport]$ ./a.out 
1
5
1 2 3 4 5 
[wizard@archlinux labreport]$ 
```
>
## Create a structure named Report_Card and inside that struct include two data members' student_name and roll_no, inside that struct student definition create another struct named subjects where you should include three data members i.e marks for NMC, OOPD, and AI and print it out for 3 students.

```c
~

#include <stdio.h>

struct Report_Card {
    char student_name[30];
    unsigned roll_no;
    struct subjects {
        unsigned nmc_marks, oopd_marks, ai_marks;
    } sub;
};

int main() {
    struct Report_Card students[3];

    for (int i = 0; i < 3; i++) {
        scanf("%s %u %u %u %u", students[i].student_name, &students[i].roll_no, 
                               &students[i].sub.nmc_marks, &students[i].sub.oopd_marks, 
                               &students[i].sub.ai_marks);
    }

    for (int i = 0; i < 3; i++) {
        printf("Student: %s, Roll No: %u\n", students[i].student_name, students[i].roll_no);
        printf("NMC Marks: %u, OOPD Marks: %u, AI Marks: %u\n", students[i].sub.nmc_marks, 
                students[i].sub.oopd_marks, students[i].sub.ai_marks);
    }

    return 0;
}
```
```
~

[wizard@archlinux labreport]$ ./a.out 
a 1 100 100 100
b 2 100 100 100
c 3 100 100 100
Student: a, Roll No: 1
NMC Marks: 100, OOPD Marks: 100, AI Marks: 100
Student: b, Roll No: 2
NMC Marks: 100, OOPD Marks: 100, AI Marks: 100
Student: c, Roll No: 3
NMC Marks: 100, OOPD Marks: 100, AI Marks: 100
[wizard@archlinux labreport]$ 
```
>
## Write a structure to store the names, salary and hours of work per day of 5 employees in a company. Write a program to increase the salary depending on the number of hours of work per day as follows and then print the name of all the employees along with their final salaries.
| Hours of work per day | Change in salary |
|-----------------------|------------------|
| < 6                   | -$20             |
| 6 <= hours <= 8       | +$50             |
| 8 < hours <= 10       | +$100            |
| > 10                  | +$150            |
```c
~

#include <stdio.h>

struct Employee { char name[30]; float salary; int hours; };

int main() {
    struct Employee employees[5];
    for (int i = 0; i < 5; i++) {
        scanf("%s %f %d", employees[i].name, &employees[i].salary, &employees[i].hours);
        if (employees[i].hours < 6) employees[i].salary -= 20;
        else if (employees[i].hours <= 8) employees[i].salary += 50;
        else if (employees[i].hours <= 10) employees[i].salary += 100;
        else employees[i].salary += 150;
    }
    for (int i = 0; i < 5; i++) printf("Name: %s, Final Salary: %.2f\n", employees[i].name, employees[i].salary);
    return 0;
}
```
```
~

[wizard@archlinux labreport]$ ./a.out 
a 150 12
b 200 12
c 300 12
d 400 15
e 500 24
Name: a, Final Salary: 300.00
Name: b, Final Salary: 350.00
Name: c, Final Salary: 450.00
Name: d, Final Salary: 550.00
Name: e, Final Salary: 650.00
[wizard@archlinux labreport]$ 
```
>
## Create a structure named Employee having members name, salary and hours of work per day. Now, write a program to dynamically create an ‘n’ number of structures of type Employee. Pass this array of structure to a function that prints the highest salary of the employee.
```c
~

#include <stdio.h>
#include <stdlib.h>

struct Employee { char name[30]; float salary; int hours; };

void highestSalary(struct Employee *emps, int n) {
    float max = emps[0].salary;
    for (int i = 1; i < n; i++) if (emps[i].salary > max) max = emps[i].salary;
    printf("Highest Salary: %.2f\n", max);
}

int main() {
    int n;
    scanf("%d", &n);
    struct Employee *emps = malloc(n * sizeof(struct Employee));
    for (int i = 0; i < n; i++) scanf("%s %f %d", emps[i].name, &emps[i].salary, &emps[i].hours);
    highestSalary(emps, n);
    free(emps);
    return 0;
}


```
```
~

[wizard@archlinux labreport]$ gcc main.c 
[wizard@archlinux labreport]$ ./a.out 
3
someone 1234 4
else 1245 3
idk 1000 6
Highest Salary: 1245.00
[wizard@archlinux labreport]$ 
```
