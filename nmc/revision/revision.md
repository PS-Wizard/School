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
# Week 2: nvm too ez.
>
# Week 3: nvm too reduant ez stuff.



