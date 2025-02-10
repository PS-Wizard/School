## 1. Triangular Numbers:
Basically Just:
- 1
- 3 (1+2)
- 6 (1+2+3)
- 10 (1+2+3+4)
...
```c
~
void q1(){
    int uin = 0,sum = 0;
    scanf("%d", &uin);
    for (int i = 1; i < uin; i++) {
        sum += i;
        printf("%d\n",sum);
    }
}

```
```
~ outputs:

[wizard@archlinux lab-exam-preperation]$ ./a.out
5 // This is user in for the number of terms
1
3
6
10
```
>

## 2. Write a program to print the sum of digits of the number provided by user.
```c
~

#include <stdio.h>
int main(){
    int uin,sum = 0;
    printf("Enter number: ");
    scanf("%d",&uin);
    for( ;uin; (sum += uin % 10,uin /= 10 ));
    printf("Sum: %d",sum);
    return 0;
}
```
```
~ outputs

[wizard@archlinux lab-exam-preperation]$ ./a.out
Enter number: 123
Sum: 6 ( 1+2+3 )
[wizard@archlinux lab-exam-preperation]$ ./a.out
Enter number: 3456
Sum: 18 (3+4+5+6)
[wizard@archlinux lab-exam-preperation]$
```
>
## 3. Write a program to create simple calculator using switch case. (The operators +, -, *, /and % must be asked to user as a character.)
```c
~
#include <stdio.h>
int main(){
    char uin;
    int a,b;
    for(;printf("\nEnter operation: "),scanf(" %c",&uin)==1;) {
        printf("Enter a,b seperated by spaces: ");
        scanf("%d %d",&a,&b);
        switch (uin) {
            case '%':
                printf("%d",a%b);
                break;
            case '-':
                printf("%d",a-b);
                break;
            case '+':
                printf("%d",a+b);
                break;
            case '*':
                printf("%d",a*b);
                break;
            case '/':
                printf("%d",a/b);
                break;
            default:
                return 0;
        }
    }
}
```
>

## 4. Write a program to input a character from the user until an enter is pressed and print it in lowercase. If the character is in uppercase, then you must change it in lowercase and if it is in lowercase then you must print as it is.

```c
~
#include <stdio.h>
int main(){
    for(char uin;(uin = getchar())!='\n';getchar()){
        if (uin >= 65 && uin <= 90)
            printf("%c\n",(uin >=65 && uin <= 90)? uin+32: uin);
    }
}
```

## 5. Write a program to ask the final score from user and print it whether he/she is passed in (distinction above 80%, first division above 60% to 80%, second division above 50% to 60%, Third division above 40% to 50%, and fail below 40%). It is mandatory to use elseif statement to solve the task.

its not worth a do

## 6. Write a program to print the following pattern using nested loop:
```c
~

#include <stdio.h>
int main(){
    for (int i = 'A'; i <= 'E'; i++) {
        for (int j = 'A'; j <= i; j++) {
            printf("%c", i);
        }
        printf("\n");
    }
}
// Prints A,BB,CCC,DDDD,EEEEE
```
```c
~ Doesn't Give the Same Output but the .*s\n is pretty cool

#include <stdio.h>

int main() {
    for (int i = 'A'; i <= 'E'; i++) { printf("%.*s\n", i - 'A' + 1, "ABCDE");}
    return 0;
}
// Prints A, AB , ABC, ABCD, ABCDE
```

---
Week 2 type shi

## Swap 2 nmbers
```c
~

#include <stdio.h>

void swap (int* a, int* b){
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

int main(){
    int a=5,b=6;
    printf("%d %d\n",a,b);
    swap(&a,&b);
    printf("%d %d",a,b);
}

```

## Armstrong and Perfect Numbers

**Armstrong Number**: Basically, for a number say 153, if 1^3 + 5^3 + 3^3 == 153, then its an armstrong number. The power to raise is determined by the number of digits in the number. log10(num) + 1 will give u the number of digits


**Perfect Numbers**: If The Sum Of Divisors Of A Number == number than its Perfec

```c
~

#include <stdio.h>
#include <math.h>

void checkArmstrong(){
    int n,sum,tmp;
    printf("Enter a number: ");
    scanf("%d", &n);
    tmp = n;
    int exp = log10(n)+ 1;
    while(tmp){
        sum += pow(tmp % 10,exp);
        tmp /= 10;
    }
    printf("The Number Is %s Armstrong ",(sum == n)? "an":"not an");
}

void checkPerfect(){
    int n,sum;
    printf("Enter a number: ");
    scanf("%d", &n);
    for (int i = 1; i < n ; sum += (n % i == 0)? i:0, i++); 
    printf("The Number Is %s Perfect number",(sum == n)? "a":"not a");

}
int main(){
    checkPerfect(500);
}
```

>

##
