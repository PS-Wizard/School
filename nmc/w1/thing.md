Week 1
## Write a program to find the sum of numbers from 1 to 10
```c
~ Question 1:

#include<stdio.h>

int one(){
    int sum = 0;
    for (int i = 0; i <= 10; i++) {
        sum += i;
    }
    return sum;
}
int main(){
    printf("%d\n",one());
    return 0;
}
```
```
~

[wizard@archlinux w1]$ gcc main.c && ./a.out
-> 55
[wizard@archlinux w1]$ 
```
---
# Write a program to find the factorial of a number.

```c
~ Question 2:

#include<stdio.h>

int two(int num) {
    int tmp = 1;
    for (int i = num; i > 0; i--) {
        tmp *= i; 
    }
    return tmp;
}
int main(){
    printf("%d\n",two(5));
    return 0;
}
```

```
~

[wizard@archlinux w1]$ gcc main.c && ./a.out 
-> 120
[wizard@archlinux w1]$ 
```

---
## Write a program to print out all triangular numbers from 1 up to nth term.
```c
~ Question 3

#include<stdio.h>
#define TRIANGULATE(n) (n * (n + 1) / 2)

int main(){
    int n = 5;
    for (int i = 1; i <= n; i++) {
        printf("%d) %d\n",i,TRIANGULATE(i));
    }
    return 0;
}
```
```
~

[wizard@archlinux w1]$ ./a.out 
1) 1
2) 3
3) 6
4) 10
5) 15
[wizard@archlinux w1]$ 
```
---

## Write a program to input a character from the user and print it in lowercase. If the character is in uppercase then you have to change it in lowercase and if it is in lowercase then you have to print as it is.

```c
~ Question 4

#include<stdio.h>

int main(){
    char n;
    printf("Enter a character: ");
    scanf("%c",&n);
    if (n >=65 && n <= 90){
        printf("%c",n+32);
        return 0; 
    }
    printf("%c",n);
}

```
```
~
[wizard@archlinux w1]$ ./a.out 
Enter a character: A
a
[wizard@archlinux w1]$ ./a.out 
Enter a character: a
a
[wizard@archlinux w1]$ 
```

## Make changes in the program of Question Number 4. Ask characters from the user until an enter key is pressed.
```c
~  Question 5 
#include <stdio.h>
int main() {
    while (1) {
        char n;
        printf("Enter character: ");
        n = getchar();

        if (n == '\n') {
            return 0;
        }

        if (n >= 'A' && n <= 'Z') {
            printf("%c\n", n + 32);
        } else {
            printf("%c\n", n);
        }

        while (getchar() != '\n');
    }
    return 0;
}

```
```
~
[wizard@archlinux w1]$ ./a.out 
Enter character: a
a
Enter character: A
a
Enter character: 
```

## Print the following pattern using nested loop:
```c
~ Question 6

#include<stdio.h>
int main(){
    for (char i = 'A' ; i <= 'E'; i++) {
        for (int j = 'A'; j <= i; j++) {
                printf("%c",i);
         } 
        printf("\n") ;
    }
}
```
```
~

[wizard@archlinux w1]$ gcc main.c  && ./a.out
A
BB
CCC
DDDD
EEEEE
```

# Fibonacci series
```c
~

#include<stdio.h>
int main(){
    int a = 0, b = 1;
    int c = a+b;
    for (int i=0;i<=5;i++){
        printf("%d ",c);
        a = b;
        b = c;
        c = a+b;

    }
}

```
```
~
[wizard@archlinux w1]$ ./a.out 
1 2 3 5 8 13 
[wizard@archlinux w1]$ 
```

# Prime Between 2 numbers:
```c
~

#include<stdio.h>

int isPrime(int n){
    for (int i = 2; i <= n; i++) {
        if (n % i == 0 && i != n){
            return 0;
        }
    }
    printf("%d ",n);
}

int main(){
    int a,b;
    printf("Enter 2 numbers comma seperated: ");
    scanf("%d,%d",&a,&b);
    for (int i=a;i<=b;i++){
        isPrime(i);
    }
}
```
```
~

[wizard@archlinux w1]$ gcc main.c 
[wizard@archlinux w1]$ ./a.out 
Enter 2 numbers comma seperated: 1,5
1 2 3 5 
[wizard@archlinux w1]$ 
```

# Compound interest:
```c
~

#include<stdio.h>

int main(){
    float a,b, c;
    printf("Enter p,t,r: ");
    scanf("%f,%f,%f",&a,&b,&c);
    printf("%f",(a*b*c)/100);
}
```

```
~

Enter p,t,r: 1.3,5.3,9.0
0.620100
[wizard@archlinux w1]$ 
```
