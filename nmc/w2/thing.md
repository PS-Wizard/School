## Write a program to find out the midpoint of any two points.

```c
~

# include <stdio.h>
void findMidpoint(double a, double b, double c , double d){
    printf("Midpoints: (%.2f, %.2f)\n",((a+b)/2),((c+d)/2));
}

int main(){
    findMidpoint(1,3,5,7);
    return 0;
}
```
```
~

[wizard@archlinux w2]$ ./a.out 
Midpoints: (2.00, 6.00)
[wizard@archlinux w2]$ 
```

> 

## Write a program to find the greatest amongst two numbers.

```c
~

# include <stdio.h>

void findGreater(int a, int b){
    printf("The Greater Value is %d",(a>b? a:b));
}

int main(){
    findGreater(1,2);
    return 0;
}
```
```
~

[wizard@archlinux w2]$ ./a.out 
The Greater Value is 2
[wizard@archlinux w2]$ 
```

>
## Write a program to find the triangular numbers upto n^th^ term:

```c
~

# include <stdio.h>


void triangular (int n){
    for (int i = 1; i <=n ; i++) {
        printf("%d, ", (i * (i+1) )/2);
    }
}

int main(){
    triangular(5);
    return 0;
}

```
```
~

[wizard@archlinux w2]$ ./a.out 
1, 3, 6, 10, 15, 
[wizard@archlinux w2]$ 
```
>

## Write a program to calculate velocity:
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
```
~

[wizard@archlinux w2]$ ./a.out 
The calculated value is: 5.00
[wizard@archlinux w2]$ 
```
>

## Write a void function named “equations” which solves simultaneous equations. 
Your program will take six parameters. E.g. function(double a, double b, double c, double d, double e, double f){}. By solving simultaneous equations, you are finding where the two lines cross each other, so your function should print an x and y coordinate.

- ax+by=c ... (i)
- dx+ey=f ... (ii)
- a = number in front of x of equation one
- b = number in front of y of equation one
- c = constant of equation one
- d = number in front of x of equation two
- e = number in front of y of equation two
- f = constant of equation two

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

# LABREPORTS

## 1. Write a C program to find cube of a number using function. 
```c
~
#include <stdio.h>
#define CUBE(x) x*x*x
int main(){
    printf("Cube: %d", CUBE(3));
    return 0;
}
```
```
~

Cube: 27
```

>
## 2. Write a program in C to swap two numbers using function.
```c
~ Swapping Without Temporary Variable Using XOR

void swap( int *a, int *b){
    *a = (*a ^= *b,*b ^= *a, *a ^ *b);
}

int main(){

    int a,b;
    printf("Enter 2 numbers: (a,b): ");
    scanf("%d,%d",&a,&b);
    printf("a,b: %d, %d\n",a,b);
    swap(&a,&b);
    printf("a,b: %d, %d",a,b);

}
```

```
~ Outputs:

[wizard@archlinux w2]$ ./a.out 
Enter 2 numbers: (a,b): 1,2
a,b: 1, 2
a,b: 2, 1
[wizard@archlinux w2]$ 
```
__Explanation__: [Primeagen's Magic Swap](https://www.youtube.com/shorts/DJxEYOC8IRc)

>
## 3. Write a void function which finds and prints the midpoint coordinates of a line. The function should take in four parameters (x1, y1, x2 and y2).
```c
~

# include <stdio.h>
void findMidpoint(double a, double b, double c , double d){
    printf("Midpoints: (%.2f, %.2f)\n",((a+b)/2),((c+d)/2));
}

int main(){
    findMidpoint(1,3,5,7);
    return 0;
}
```
```
~

[wizard@archlinux w2]$ ./a.out 
Midpoints: (2.00, 6.00)
[wizard@archlinux w2]$ 
```
>

## 4. Write a program in C to check Armstrong and perfect numbers using the function.

```c
~

#include <stdio.h>
#include <math.h> // needs the gcc main.c -lm flag

void isArmstrong(int n){
    int sum = 0;
    for (int tmp=n, ndigits = (int)log10(n)+1; tmp; tmp / = 10) {
        sum += pow(tmp%10,ndigits);
    }
    printf(n == sum? "Armstrong\n":"Not Armstrong\n");
}

void isPerfect(int n){
    int sum = 0;
    for (int i=1;i<n;i++)
        sum += (n % i == 0)? i:0;
    printf(sum == n? "Perfect": "Not Perfect");

}


int main(){
    int n, sum = 0;
    printf("Enter a number: ");
    scanf("%d",&n);
    isArmstrong(n);
    isPerfect(n);
    return 0;
}
```
```
~

[wizard@archlinux w2]$ ./a.out 
Enter a number: 6
Armstrong
Perfect
[wizard@archlinux w2]$ ./a.out 
Enter a number: 28
Not Armstrong
Perfect
[wizard@archlinux w2]$ 
```
>
## 5. Write a function named “velocityCalc” which returns an appropriate value for the formula “v=u+at”.

Where v is the final velocity, u is the initial velocity, a is the acceleration and t is the time that has elapsed. Depending upon which variable is set to “NAN” when the function is called, your function should work it out and return the value. Make sure to take inputs from the user and let them decide which variable should be NAN, and the program should not work if more than one variable is NAN.

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
```
~

[wizard@archlinux w2]$ ./a.out 
The calculated value is: 5.00
[wizard@archlinux w2]$ 
```

>
## 6. Write a void function named “equations” which solves simultaneous equations. 
Your program will take six parameters. E.g. function(double a, double b, double c, double d, double e, double f){}. By solving simultaneous equations, you are finding where the two lines cross each other, so your function should print an x and y coordinate.

- ax+by=c ... (i)
- dx+ey=f ... (ii)
- a = number in front of x of equation one
- b = number in front of y of equation one
- c = constant of equation one
- d = number in front of x of equation two
- e = number in front of y of equation two
- f = constant of equation two

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
