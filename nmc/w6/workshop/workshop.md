## Create a structure named employee having members: empName, age and salary. Use this structure to read the name, age and salary of the 5 employees and write entered information to a file employee.txt.
```c
~

#include <stdio.h>
struct employee{
    char empName[20];
    unsigned age,salary;
};
int main(){
    struct employee emps[5];
    for (int i = 0; i < 5; i++) {
        printf("Enter name,age,salary: ");
        scanf("%s %u %u",emps[i].empName,&emps[i].age, &emps[i].salary);
    }
    FILE *file = fopen("employee.txt","w");
    if (file == NULL){
        printf("Error opening file");
    }
    for (int i = 0; i < 5; i++) {
        fprintf(file,"Name: %s, Age: %u, Salary: %u\n",emps[i].empName, emps[i].age, emps[i].salary);
    }
    fclose(file);
}
```
```
~

[wizard@archlinux workshop]$ cat employee.txt 
Name: a, Age: 1, Salary: 100
Name: b, Age: 1, Salary: 100
Name: c, Age: 1, Salary: 100
Name: d, Age: 1, Salary: 100
Name: e, Age: 1, Salary: 100
[wizard@archlinux workshop]$ 
```
>
## Write a program to copy content from employee.txt. File to newemployee.txt file.
```c
~

#include <stdio.h>

int main() {
    FILE *file = fopen("employee.txt", "r");
    FILE *file1 = fopen("newemployee.txt", "w");

    if (!file || !file1) return 1;

    char name[20];
    unsigned age, salary;

    while (fscanf(file, "Name: %19[^,], Age: %u, Salary: %u\n", name, &age, &salary) == 3) {
        fprintf(file1, "Name: %s, Age: %u, Salary: %u\n", name, age, salary);
    }

    fclose(file);
    fclose(file1);
    return 0;
}
```
```
~

[wizard@archlinux workshop]$ cat newemployee.txt 
Name: a, Age: 1, Salary: 100
Name: b, Age: 1, Salary: 100
Name: c, Age: 1, Salary: 100
Name: d, Age: 1, Salary: 100
Name: e, Age: 1, Salary: 100
[wizard@archlinux workshop]$ 
```
>
## WAP to add new employee details in newemployee.txt file.
```c
~

#include <stdio.h>

int main() {
    char s[20];
    unsigned a,b;
    FILE *file1 = fopen("newemployee.txt", "a");
    printf("Enter name, age, salary: ");
    scanf("%s %u %u", s, &a, &b);
    fprintf(file1, "Name: %s, Age: %u, Salary: %u\n", s, a, b);
    fclose(file1);
    return 0;
}
```
```
~ BEFORE:

[wizard@archlinux workshop]$ cat newemployee.txt 
Name: a, Age: 1, Salary: 100
Name: b, Age: 1, Salary: 100
Name: c, Age: 1, Salary: 100
Name: d, Age: 1, Salary: 100
Name: e, Age: 1, Salary: 100
[wizard@archlinux workshop]$ 
```
```
~ AFTER:

Name: a, Age: 1, Salary: 100
Name: b, Age: 1, Salary: 100
Name: c, Age: 1, Salary: 100
Name: d, Age: 1, Salary: 100
Name: e, Age: 1, Salary: 100
Name: f, Age: 1, Salary: 100
[wizard@archlinux workshop]$ 
```
>
## Write a program in C to read integers from the user until the user says "no". After reading the data write all the odd numbers to a file named odd.txt and all the even numbers to file even.txt.
```c
~

#include <stdio.h>
#include <string.h>

int main() {
    FILE *odd = fopen("odd.txt","w");
    FILE *even = fopen("even.txt","w");
    int n;
    char c[4];
    while (1) {
        printf("Enter character or no stop: ");
        if (scanf("%d",&n) == 1) {
            fprintf(n % 2 == 0? even:odd, "%d\n", n);
        } else {
            scanf("%s",c);
            if (strcmp(c,"no") == 0) break;
        }
    }
    fclose(odd);
    fclose(even);
    return 0;
}
```
```
~

[wizard@archlinux workshop]$ ./a.out 
Enter character or no stop: 1
Enter character or no stop: 2
Enter character or no stop: 3
Enter character or no stop: 4
Enter character or no stop: 5
Enter character or no stop: 6
Enter character or no stop: 7
Enter character or no stop: 8
Enter character or no stop: 9
Enter character or no stop: 10
Enter character or no stop: no
[wizard@archlinux workshop]$ cat odd.txt; echo "---"; cat even.txt 
1
3
5
7
9
---
2
4
6
8
10
[wizard@archlinux workshop]$ 
```
