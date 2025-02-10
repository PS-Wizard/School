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

## Wap to calculate v=u+at depending on which is nan:
```c
~

#include <stdio.h>
#include <math.h>

float velocityCalc(float u, float a, float t, float v) {
    if (isnan(v)) return u + (a * t);
    if (isnan(u)) return v - (a * t);
    if (isnan(a)) return (v - u) / t;
    if (isnan(t)) return (v - u) / a;
    return NAN; // Should never reach here
}

int main() {
    float u, a, t, v;
    int nanCount = 0;
    char unknown;

    printf("Enter 'N' for the unknown variable (u, a, t, v): \n");
    printf("Initial velocity (u): ");
    if (scanf("%f", &u) != 1) { u = NAN; nanCount++; getchar(); }
    
    printf("Acceleration (a): ");
    if (scanf("%f", &a) != 1) { a = NAN; nanCount++; getchar(); }
    
    printf("Time (t): ");
    if (scanf("%f", &t) != 1) { t = NAN; nanCount++; getchar(); }
    
    printf("Final velocity (v): ");
    if (scanf("%f", &v) != 1) { v = NAN; nanCount++; getchar(); }

    if (nanCount != 1) {
        printf("Error: Exactly one variable must be unknown.\n");
        return 1;
    }

    float result = velocityCalc(u, a, t, v);
    printf("Calculated value: %.2f\n", result);
    return 0;
}
```
---
Week 3 type shi
## Find Smallest And Largest
==Note== the only real important thing here is the `-INFINITY` and `INFINITY`
```c
~

#include <stdio.h>
#include <math.h>


int main(){
    int arr[] = {1,2,3,4,5,6,7};
    float smallest=INFINITY, largest=-INFINITY;
    for (int i = 0; i < sizeof(arr)/sizeof(arr[0]); i++) {
        if (arr[i] < smallest){ smallest = arr[i]; }
        if (arr[i] > largest) { largest = arr[i]; }
    }

    printf("%f, %f",smallest,largest);
}
```

## check anagram
==Key Takeaway: ==  the main thing here is just the `str[i] || str2[i]` which is a clever way of looping till the end of the string as `\0` is a falsey value
```c
~

#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int main() {
    char str1[100], str2[100]; int sum = 0;
    printf("String 1: "); fgets(str1,sizeof(str1),stdin);
    printf("String 2: "); fgets(str2,sizeof(str1),stdin);
    for (int i = 0; str1[i] || str2[i] ; i++) {
        sum += str1[i];
        sum -= str2[i];
    }
    if (sum == 0) {
        printf("is anagram");
        return 0;
    }
    printf("Aint anagram");

}
```

>

## Print uniques

```
~

#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int main() {
    int arr[] = {3,1,2,3,4,6,2,1,3,4,6};
    int* uniques = calloc(sizeof(arr)/sizeof(arr[0]),sizeof(int));
    for (int i = 0; i <sizeof(arr)/sizeof(arr[0]); i++) (!uniques[arr[i]])? (uniques[arr[i]] = 1, printf("%d",arr[i])): 0;
    free(uniques);
}
```
>

## Sort an array in ascending order
```
~

#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int main() {
    int arr[] = {3,10,2,3,4,6,2,1,3,4,6};
    int smallest,tmp;
    int arrSize = sizeof(arr)/sizeof(arr[0]);
    for (int i = 0; i < arrSize - 1; i++) {
        smallest = i;
        for(int j = i+1 ; j < arrSize; j++){
            if (arr[j] < arr[smallest]){
                smallest = j;
            }
        }
        tmp = arr[i];
        arr[i] = arr[smallest];
        arr[smallest] = tmp;
    }

    for (int i = 0; i < arrSize; i++) {
        printf("%d, ",arr[i]);
    }
}

```

## divisible by 5 but nah by 2 or 3, print count and sum
```c
~

#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int main() {
    int arr[] = {25,25,25,25,25,25};
    int sum,count;
    int arrSize = sizeof(arr)/sizeof(arr[0]);
    for (int i = 0; i < arrSize; i++) {
        sum += (arr[i] % 5 == 0 && arr[i] % 3 !=0 && arr[i] % 2 != 0)? (count++,arr[i]) : 0;

    }
    printf("%d %d",sum,count);
}
```
> 

Week 4 type shi
## Reallocate

```c
~
#include <stdio.h>
#include <stdlib.h>
#include <math.h>


int main() {
    int size = 0,extra = 0;
    scanf("%d",&size);
    int* arr = malloc(size * sizeof(int));

    for (int i = 0; i < size; i++) {
        scanf("%d",arr+i);
    } 

    for (int i = 0; i < size; i++) {
        printf("%d, \n",arr[i]);
    } 

    printf("realloc: ");
    scanf("%d",&extra);
    arr = realloc(arr,(size+extra) * sizeof(int));
    for (int j = size; j < extra; j++) {
        scanf("%d",arr+j);
    } 

    for (int i = 0; i < size+(extra-size); i++) {
        printf("%d, ",arr[i]);
    } 

    free(arr);

}
```


