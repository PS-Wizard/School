### Homework Hustlers: https://discord.gg/aJ55rZBV
### - Wizard.

--- 
## 1) Create a user defined datatype.
```c
~

#include <stdio.h>

typedef struct { int a,b; }custom;

int main(){
    custom c = {1,2};
    printf("%d, %d", c.a, c.b);
}
```
```
~

[wizard@archlinux tuto]$ gcc main.c 
[wizard@archlinux tuto]$ ./a.out 
1, 2
[wizard@archlinux tuto]$
```
>
## 2) Create a structure varibale.
```c
~

#include <stdio.h>

struct custom{ int a,b; };

int main(){
    struct custom c = {1,2};
    printf("%d, %d", c.a, c.b);
}
```
```
~

1, 2[wizard@archlinux tuto]$ gcc main.c 
[wizard@archlinux tuto]$ ./a.out 
1, 2
[wizard@archlinux tuto]$ 
```
>
## 3) Use of typedef keyword in c.
```c
~

#include <stdio.h>

typedef struct { int a,b; }custom;

int main(){
    custom c = {1,2};
    printf("%d, %d", c.a, c.b);
}
```
```
~

[wizard@archlinux tuto]$ gcc main.c 
[wizard@archlinux tuto]$ ./a.out 
1, 2
[wizard@archlinux tuto]$
```
>
## 4) Create a structure for student(roll,name,address,mark) and access the members. 
```c
~

#include <stdio.h>

typedef struct{
    int roll, mark;
    char address[10],name[10];
}student;

int main(){
    student std1 = {1,100,"Sydney","Angel"};
    printf("%d, %d, %s, %s", std1.roll,std1.mark,std1.address,std1.name);
}
```
```
~

[wizard@archlinux tuto]$ ./a.out 
1, 100, Sydney, Angel
[wizard@archlinux tuto]$ 
```
>
## 5) Create a structure for student(roll,name,address(province,district,city,ward),mark) and access the members.
```c
~

#include <stdio.h>
typedef struct {
    char province[10];
    char district[10];
    char city[10];
    short ward;
}address;

typedef struct{
    int roll, mark;
    char name[10];
    address address;
}student;


int main(){
    student std1 = {1,100,"Angel\0",{"P 1\0","d 1\0","sydney\0",9}};
    printf("Roll: %d, Mark: %d, Name: %s, Province: %s, District: %s, City: %s, Ward: %d", std1.roll,std1.mark,std1.name,std1.address.province,std1.address.district, std1.address.city,std1.address.ward);
}
```
```
~

[wizard@archlinux tuto]$ gcc main.c 
[wizard@archlinux tuto]$ ./a.out 
Roll: 1, Mark: 100, Name: Angel, Province: P 1, District: d 1, City: sydney, Ward: 9
[wizard@archlinux tuto]$ 
```
>>
## 6) Array of structure.
```c
~

#include <stdio.h>

typedef struct {
    int a, b;
} example;

int main() {
    example e[3];
    for (int i = 0; i < 3; i++) { e[i] = (example){1, 2};  }
    for (int i = 0; i < 3; i++) { printf("%d, %d\n", e[i].a, e[i].b); }

    return 0;
}
```
```
~

[wizard@archlinux tuto]$ ./a.out 
1, 2
1, 2
1, 2
[wizard@archlinux tuto]$ 
```
>
## 7) Create a structure named student that has a name, roll number and marks as members. Assume appropriate types and size of members. Use this structure to read and display records of 10 students. Create two functions: One is to read information of students and other to display the information.
```c
~

#include <stdio.h>

typedef struct {
    char name[10];
    short roll;
    short marks;
} student;

void takeInput(student* std){
    printf("Enter name roll marks: ");
    scanf("%s %hd %hd", std->name, &std->roll, &std->marks);  
}

void print(student* std){
    printf("name: %s, Roll: %hd, Marks: %hd\n", std->name, std->roll, std->marks);
}

int main() {
    student stds[10];
    for (int i = 0; i < 10; i++) {
        takeInput(&stds[i]);  
    }
    for (int i = 0; i < 10; i++) {
        print(&stds[i]);  
    }
    return 0;
}
```
```
~

[wizard@archlinux tuto]$ ./a.out 
Enter name roll marks: a 1 1
Enter name roll marks: b 1 1
Enter name roll marks: c 1 1
Enter name roll marks: d 1 1
Enter name roll marks: e 1 1
Enter name roll marks: f 1 1
Enter name roll marks: g 1 1
Enter name roll marks: h 1 1
Enter name roll marks: i 1 1
Enter name roll marks: j 1 1
name: a, Roll: 1, Marks: 1
name: b, Roll: 1, Marks: 1
name: c, Roll: 1, Marks: 1
name: d, Roll: 1, Marks: 1
name: e, Roll: 1, Marks: 1
name: f, Roll: 1, Marks: 1
name: g, Roll: 1, Marks: 1
name: h, Roll: 1, Marks: 1
name: i, Roll: 1, Marks: 1
name: j, Roll: 1, Marks: 1
```
## 8) Create a user defined data type for storing 2D coordinate point. Take two points from user and calculate midpoint using function.
```c
~

#include <stdio.h>

typedef struct {
    float x, y;
} Point;

Point midpoint(Point p1, Point p2) {
    Point m;
    m.x = (p1.x + p2.x) / 2;
    m.y = (p1.y + p2.y) / 2;
    return m;
}

int main() {
    Point p1, p2, m;
    
    printf("Enter coordinate 1: ");
    scanf("%f %f", &p1.x, &p1.y);
    printf("enter coordinate 2: ");
    scanf("%f %f", &p2.x, &p2.y);
    
    m = midpoint(p1, p2);
    
    printf("Midpoint: (%.2f, %.2f)\n", m.x, m.y);
    
    return 0;
}
```
```
~

[wizard@archlinux tuto]$ ./a.out 
Enter coordinate 1: 1 2
enter coordinate 2: 3 4
Midpoint: (2.00, 3.00)
[wizard@archlinux tuto]$  n
```

