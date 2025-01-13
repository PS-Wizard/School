## Write a program to find the sum of numbers from 1 to 10.
```c
~

#include <stdio.h>
int main(){
    int sum = 0;
    for (int i = 0; i < 10; i++) {
        sum += i; 
    }
    printf("%d",sum);
}
```
## Write a program to find the factorial of a number.
```c
~

#include <stdio.h>
int main(){
    int sum = 1;
    unsigned userin;
    scanf("%u",&userin);
    for (; userin >= 1; ) {
        sum *= userin--;
    }
    printf("%d",sum);
}
```
## Write a program to print out all triangular numbers from 1 up to nth term.
```c
~

#include <stdio.h>
int main(){
    int sum = 1;
    unsigned userin;
    scanf("%u",&userin);
    for (int i = 0; i <= userin; i++ ) {
        printf("%d, ",(i * (i+1))/2);
    }
}

```
## Write a program to input a character from the user and print it in lowercase. If the character is in uppercase then you have to change it in lowercase and if it is in lowercase then you have to print as it is.
```c
~

#include <stdio.h>
int main(){
    for(char c; (c=getchar()) != '\n'; ){
        printf("%c\n",(c>=65 && c<=90)? c+32:c);
        while (getchar() != '\n');
    }
}
```

## Make changes in the program of Question Number 4. Ask characters from the user until an enter key is pressed.
```c
~

#include <stdio.h>
int main(){
    for(char c; (c=getchar()) != '\n'; ){
        printf("%c\n",(c>=65 && c<=90)? c+32:c);
        while (getchar() != '\n');
    }
}
```
##  Print the following pattern using nested loop:
A
B  B
C  C  C
D  D  D  D
E  E  E  E  E
```c
~


#include <stdio.h>
int main(){
    for (char i = 'A'; i < 'E'; i++) {
        for (char j = 'A'; j <= i; j++) {
            printf("%c ",i);
        }
        printf("\n");
    }
}
```
>
# Week 2: 
## 1. Write a C program to find cube of a number using function.
```c
~

#include <stdio.h>
#include <math.h>
void findCube(float a){
    printf("%lf",pow(a,3));
}
int main(){
    float a;
    scanf("%f", &a);
    findCube(a);

}
```
## 2. Write a program in C to swap two numbers using function.
```c
~

#include <stdio.h>
#include <math.h>
void swap(int *a, int *b){
    int temp = *a;
    *a = *b;
    *b = temp;
}
int main(){
    int a,b;
    scanf("%d %d", &a,&b);
    swap(&a,&b);
    printf("%d %d", a,b);

}

```
## 3. Write a void function which finds and prints the midpoint coordinates of a line.
```c
~

#include <stdio.h>
#include <math.h>
void mid(int a, int b, int c, int d){
    printf("%d %d",(a+b)/2, (c+d)/2);
}

int main(){
    int a,b,c,d;
    scanf("%d %d %d %d", &a,&b,&c,&d);
    mid(a,b,c,d);

}

```
## 4. Write a program in C to check Armstrong and perfect numbers using the function.
```c
~

#include <stdio.h>
#include <math.h>
void check_armstrong(int a){
    int length = log10(a)+1;
    int sum = 0;
    while(a){
        sum += pow((a%10),length);
        printf("%d",sum);
        a /= 10;
    }
    if (sum == a) {
        printf("Armstrong");
    }
}

void check_perfect(int a){
    int sum = 0;
    for (int i = 1; i < a; i++) {
        sum += (a % i == 0)? i:0;
    }
    if (a == sum){ 
        printf("Perfect");
    }
}

int main(){
    int a;
    scanf("%d", &a);
    check_armstrong(a);
    check_perfect(a);

}

```
## 5. Write a function named “velocityCalc” which returns an appropriate value for the formula “v=u+at”, where v is the final velocity, u is the initial velocity, a is the acceleration and t is the time that has elapsed. Depending upon which variable is set to “NAN” when the function is called, your function should work it out and return the value. Make sure to take inputs from the user and let them decide which variable should be NAN, and the program should not work if more than one variable is NAN.
```c
~

#include <stdio.h>
#include <math.h>

double calcVelocity(double v, double u, double a, double t) {
    if (isnan(v)) return u + a * t;
    if (isnan(u)) return v - a * t;
    if (isnan(a)) return (v - u) / t;
    if (isnan(t)) return (v - u) / a;
    return 0;
}

int main(){
    double v = NAN, u = 5.0, a = 0, t = 3.0;
    printf("The calculated value is: %.2lf\n", calcVelocity(v, u, a, t));
    return 0;
}

```
## 6. Write a void function named “equations” which solves simultaneous equations. Your program will take six parameters. E.g. function(double a, double b, double c, double d, double e, double f){}. By solving simultaneous equations, you are finding where the two lines cross each other, so your function should print an x and y coordinate. ax+by=c
```c
~

#include <stdio.h>

void equations(double a, double b, double c, double d, double e, double f) {
    double x = (e*c - b*f) / (a*e - b*d);
    double y = (a*f-d*c) / (a*e - b*d);
    printf("x: %f, y: %f",x,y);
}

int main(){
    equations(5.0,6.0,7.0,8.0,9.0,10.0);
}
```
```
~
[wizard@archlinux w2]$ ./a.out 
x: -1.000000, y: 2.000000
[wizard@archlinux w2]$ 
```
---

>
# Week 3: nvm too reduant ez stuff.
# Concurrency:
```c
~

#include <stdio.h>
#include <math.h>
#include <pthread.h>

void *printStuff(){
    for (int i = 0; i < 1000; i++) {
        printf("%d, ",i);
    }
}
int main(){
    pthread_t a,b;
    pthread_create(&a,NULL,printStuff,NULL);
    pthread_create(&b,NULL,printStuff,NULL);
    pthread_join(a,NULL);
    pthread_join(b,NULL);
    return 0;
}
```

#
```c
~

#include <stdio.h>
#include <pthread.h>

struct range {
    int start;
    int end;
    int threadID;
};

void *printStuff(void *args) {
    struct range *arg = (struct range *)args;
    for (int i = arg->start; i < arg->end; i++) {
        printf("Thread %d: %d\n", arg->threadID, i);
    }
    return NULL;
}

int main() {
    pthread_t thingys[5];
    struct range ranges[5];
    int total_numbers = 1000;
    int numbers_per_thread = total_numbers / 5;

    for (int i = 0; i < 5; i++) {
        ranges[i].start = i * numbers_per_thread + 1;
        ranges[i].end = (i + 1) * numbers_per_thread + 1;
        ranges[i].threadID = i + 1;

        pthread_create(&thingys[i], NULL, printStuff, (void *)&ranges[i]);
    }

    for (int i = 0; i < 5; i++) {
        pthread_join(thingys[i], NULL);
    }

    return 0;
}

```
