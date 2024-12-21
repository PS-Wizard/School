### Homework Hustlers: https://discord.gg/aJ55rZBV
### - Wizard.

--- 

## Write a program to create memory for int, char and float variables at run time.
```c
~

#include <stdio.h>
#include <stdlib.h>

int main() {
    int *intPtr = (int *)malloc(sizeof(int));
    char *charPtr = (char *)malloc(sizeof(char));
    float *floatPtr = (float *)malloc(sizeof(float));

    scanf("%d, %c, %f",intPtr,charPtr,floatPtr);
    printf("Value of int: %d\n", *intPtr);
    printf("Value of char: %c\n", *charPtr);
    printf("Value of float: %.2f\n", *floatPtr);

    free(intPtr);
    free(charPtr);
    free(floatPtr);

    return 0;
}

```
```
~

[wizard@archlinux workshop]$ gcc main.c 
[wizard@archlinux workshop]$ ./a.out 
1,c,2
Value of int: 1
Value of char: c
Value of float: 2.00
[wizard@archlinux workshop]$ 
```
>
## Finding the maxium in an array using dynamic memory allocation.
```c
~

#include <stdio.h>
#include <stdlib.h>
int main(){
    int *ptr = malloc(5 * sizeof(int)),max=0;
    for (int i = 0; i < 5; i++){ scanf("%d",ptr+i); max = (ptr[i] > max)? ptr[i]:max; } 
    printf("Max is %d",max);
    free(ptr);
}
```
```
~

[wizard@archlinux workshop]$ ./a.out 
1
2
3
4
5
Max is 5
[wizard@archlinux workshop]$ 
```
>
## Write a program that allocates memory space as required by the user for three arrays. User enters the numbers for two arrays and the program sums the corresponding array elements and stores them in the third array.
```c
~

#include <stdio.h>
#include <stdlib.h>

int main() {
    int len;
    printf("Enter the length of the arrays: ");
    scanf("%d", &len);
    int *arr1 = malloc(len * sizeof(int));
    int *arr2 = malloc(len * sizeof(int));
    int *arr3 = malloc(len * sizeof(int));
    
    printf("enter array 1: \n");
    for (int i = 0; i < len; i++) scanf("%d", arr1 + i);
    printf("array 2: \n");
    for (int i = 0; i < len; i++) scanf("%d", arr2 + i);

    for (int i = 0; i < len; i++) arr3[i] = arr1[i] + arr2[i];
    for (int i = 0; i < len; i++) printf("%d ", arr3[i]);
    
    free(arr1);
    free(arr2);
    free(arr3);
    
    return 0;
}

```
```
~

[wizard@archlinux workshop]$ ./a.out 
Enter the length of the arrays: 4
enter array 1: 
1
2
3
4
array 2: 
5
6
7
8
6 8 10 12 
[wizard@archlinux workshop]$ 
```
## Write a program that reads ‘n’ from the user and allocates memory to hold n integer numbers. Pass these numbers to a function that returns the sum.
```c
~

#include <stdio.h>
#include <stdlib.h>
int sum(int *a, int size){
    int sum = 0;
    for (int i = 0; i < size; i++) sum += a[i];
    return sum;
}
int main(){
    int leng=0;
    printf("Enter the length of the arrays: ");
    scanf("%d",&leng);
    int *ptr = malloc(leng * sizeof(int));
    printf("Enter array: \n");
    for (int i = 0; i < leng; i++) scanf("%d",ptr+i);
    printf("Sum is %d",sum(ptr,leng));
    free(ptr);
}
```
```
~
[wizard@archlinux workshop]$ gcc main.c 
[wizard@archlinux workshop]$ ./a.out 
Enter the length of the arrays: 5
Enter array: 
1
2
3
4
5
Sum is 15
[wizard@archlinux workshop]$ 
```
