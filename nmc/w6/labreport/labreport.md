## Create a structure named student having members: studentName, age and marks. Use this structure to read the name, age and salary of n (ask from user) employees and write entered information to a file student.txt.
```c
~

#include <stdlib.h>
#include <stdio.h>
struct student{
    char studentName[30];
    unsigned age,marks; 
};

int main(){
    unsigned n;
    scanf("%u",&n);
    struct student* ptr = malloc(n * sizeof(struct student));
    for (int i = 0; i < n; i++) {
        printf("Enter name age marks: "); 
        scanf("%s %u %u", ptr[i].studentName, &ptr[i].age, &ptr[i].marks);
    }
    FILE* fptr = fopen("student.txt","a");
    for (int i = 0; i < n; i++) {
        fprintf(fptr,"Name: %s, Age: %u, Marks: %u\n",ptr[i].studentName, ptr[i].age, ptr[i].marks);
    }
    free(ptr);
    fclose(fptr);

}
```
```c
~

#include <stdio.h>
#include <stdlib.h>

int main() {
    unsigned n;
    scanf("%u", &n);
    struct { char name[30]; unsigned age, marks; } *s = malloc(n * sizeof(*s));
    FILE *f = fopen("student.txt", "a");
    for (int i = 0; i < n; i++) {
        scanf("%s %u %u", s[i].name, &s[i].age, &s[i].marks);
        fprintf(f, "Name: %s, Age: %u, Marks: %u\n", s[i].name, s[i].age, s[i].marks);
    }
    free(s), fclose(f);
}
```
```
~

[wizard@archlinux labreport]$ cat student.txt 
Name: someone, Age: 1, Marks: 100
Name: someone, Age: 2, Marks: 200
Name: someone, Age: 3, Marks: 300
[wizard@archlinux labreport]$ 
```
>
## Write a program to read information from the above file student.txt.
```c
~

#include <stdio.h>
#include <stdlib.h>

int main() {
    char line[30];
    FILE *f = fopen("./student.txt","r");
    while(fgets(line,sizeof(line),f)){ printf("%s",line); }
    fclose(f);
}

```
```
~

[wizard@archlinux labreport]$ ./a.out 
Name: someone, Age: 1, Marks: 100
Name: someone, Age: 2, Marks: 200
Name: someone, Age: 3, Marks: 300
[wizard@archlinux labreport]$ 
```
>
## WAP to add n number of new students in the employee.txt file (open file in “a” mode).
```c
~

#include <stdio.h>
#include <stdlib.h>

int main() {
    char line[30];
    FILE *f = fopen("./student.txt","a");
    fprintf(f,"Name: new student, Age: 69, Marks: 100\n");
    fclose(f);
}
```
```
~
-- Previous --
[wizard@archlinux labreport]$ cat student.txt
Name: someone, Age: 1, Marks: 100
Name: someone, Age: 2, Marks: 200
Name: someone, Age: 3, Marks: 300

-- New --
[wizard@archlinux labreport]$ cat student.txt
Name: someone, Age: 1, Marks: 100
Name: someone, Age: 2, Marks: 200
Name: someone, Age: 3, Marks: 300
Name: new student, Age: 69, Marks: 100
```
>
## Write a C program to read integers from the user until the user inputs "stop". Save all prime numbers to a file named prime.txt and all composite numbers to a file named composite.txt.
```c
~

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

int isPrime(int n){
    for (int i = 2; i <= sqrt(n); i++) {
        if (n % i == 0){
            return 0;
        }
    }
    return 1;
     
}
int main() {
    char uin[5];
    int a;
    FILE *composite= fopen("composite.txt","w");
    FILE *prime = fopen("prime.txt","w");
    while(1){
        if (scanf("%d",&a) == 1){
            fprintf(isPrime(a)? prime: composite, "%d\n",a);
        } else{
            scanf("%s",uin);
            if (strcmp(uin,"stop") == 0){
                break;
            }
        }
    }
    fclose(prime);
    fclose(composite);
}
```
```
~

[wizard@archlinux labreport]$ cat composite.txt; echo "===" ; cat prime.txt 
4
6
8
9
10
===
1
2
3
5
7
[wizard@archlinux labreport]$ 
```
>
## Write a program to combine the contents of prime.txt and composite.txt into a new file called numbers_combined.txt.
```c
~

#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *composite= fopen("composite.txt","r"); FILE *prime = fopen("prime.txt","r"); FILE *com = fopen("combined.txt","w");
    int a;
    while(fscanf(prime,"%d\n",&a) == 1) fprintf(com,"%d\n",a);
    while(fscanf(composite,"%d\n",&a) == 1) fprintf(com,"%d\n",a);
    fclose(prime); fclose(composite); fclose(com);
}
```
```
~

[wizard@archlinux labreport]$ cat combined.txt
1
2
3
5
7
4
6
8
9
10
```
>
## Write a c program to read integers from the user and append the sum to the end in the file name sum.txt.
```c
~

#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *sumf = fopen("sum.txt","a");
    for( int a, sum = 0; scanf("%d", &a) == 1; fprintf(sumf, "%d + %d = %d\n", a, (sum-a), (sum += a)));
    fclose(sumf);
}
```
```
~

[wizard@archlinux labreport]$ cat sum.txt 
1 + 0 = 1
2 + 1 = 3
3 + 3 = 6
4 + 6 = 10
5 + 10 = 15
[wizard@archlinux labreport]$ 
```
