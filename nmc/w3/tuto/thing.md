## WAP to find the largest element of an array:
```c
~

#include <stdio.h>

void findLargest(int *a, int size) {
    for (int i = 0; i < size - 1; i++) {
        for (int j = 0; j < size - 1 - i; j++) {
            if (a[j] > a[j + 1]) { 
                a[j] ^= a[j + 1];
                a[j + 1] ^= a[j];
                a[j] ^= a[j + 1];
            }
        }
    }
    printf("%d", a[size - 1]); 
}

int main() {
    int a[] = {3,2,1,5,6,12,99};
    int size = sizeof(a) / sizeof(a[0]);
    findLargest(a, size);
    return 0;
}

```
```
~

[wizard@archlinux tuto]$ ./a.out 
99
[wizard@archlinux tuto]$ 
```
>
## WAP to sort array elements in ascending order
```c
~

#include <stdio.h>

void bSort(int *a, int size) {
    for (int i = 0; i < size - 1; i++) {
        for (int j = 0; j < size - 1 - i; j++) {
            if (a[j] > a[j + 1]) { 
                a[j] ^= a[j + 1];
                a[j + 1] ^= a[j];
                a[j] ^= a[j + 1];
            }
        }
    }
}

int main() {
    int a[] = {3,2,1,5,6,12,99};
    int size = sizeof(a) / sizeof(a[0]);
    bSort(a, size);
    for (int i = 0; i < size; i++) {
        printf("%d, ", a[i]); 
    }
    return 0;
}
```
```
~

[wizard@archlinux tuto]$ ./a.out 
1, 2, 3, 5, 6, 12, 99, 
[wizard@archlinux tuto]$ 
```

## WAP to read 10 numbers from keyboard to store these num into array and then calculate sum of these num using function
```c
~

#include <stdio.h>

void sum(int *a, int size) {
    int sum = 0;
    for (int i = 0; i <= size - 1; i++) {
        sum += *(a+i);
    }
    printf("Sum: %d",sum);
}

int main() {
    int size;
    printf("Enter size: ");
    scanf("%d",&size);
    int arr[size];
    for (int i = 0; i < size; i++) {
        printf("Enter Element: ");
        scanf("%d",(arr+i));
    }

    sum(arr,size);
     
}

```
```
~

[wizard@archlinux tuto]$ ./a.out 
Enter size: 10
Enter Element: 1
Enter Element: 2
Enter Element: 3
Enter Element: 4
Enter Element: 5
Enter Element: 6
Enter Element: 7
Enter Element: 8
Enter Element: 9
Enter Element: 0
Sum: 45
[wizard@archlinux tuto]$ 
```
>

##  WAP reads two 2-D arrays,adds the corresponding elements and displays the result on the screen.
```c
~

#include <stdio.h>
int main() {
    int row, col;
    printf("Enter row,col: ");
    scanf("%d,%d",&row,&col);
    int arr[row][col];
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < col; j++) {
            printf("Enter element: ");
            scanf("%d",&arr[i][j]); // *(*(arr + i) + j) arr[i] -> *(arr + i) In a 2d array this points to the first row, instead of the first element.
        }
        }
    for (int i = 0; i < row; i++) {
        printf("[");
        for (int j = 0; j < col; j++) {
            printf("%d,", arr[i][j]);
        }
            printf("],\n");
    }

}
```
```
~

Enter row,col: 3,3
Enter element: 1
Enter element: 2
Enter element: 3
Enter element: 4
Enter element: 5
Enter element: 6
Enter element: 7
Enter element: 8
Enter element: 8
[1,2,3,],
[4,5,6,],
[7,8,8,],
[wizard@archlinux tuto]$ 
```
>
## 5. WAP to store the name of week days and then print all.
```c
~

#include <stdio.h>
int main() {
    char weekdays[7][9];
    for (int i = 0; i <= 6; i++) {
        printf("Enter day:");
        scanf("%s",weekdays[i]);
    } 
    for(int i = 0; i<=6;i++){
        printf("%d. %s\n",i,weekdays[i]);
    }
}

```
```
~

[wizard@archlinux tuto]$ ./a.out 
Enter day:Sunday
Enter day:Monday
Enter day:Tuesday
Enter day:Wednesday
Enter day:Thursday
Enter day:Friday
Enter day:Saturday
0. Sunday
1. Monday
2. Tuesday
3. WednesdaThursdayFriday
4. ThursdayFriday
5. Friday
6. Saturday
```

## 6. WAP to swap the number using a pointer(call by value and call by reference).
```c
~ Swapping Without Temporary Variable Using XOR

#include <stdio.h>

void swap( int *a, int *b){
    *a ^= *b;
    *b ^= *a;
    *a ^= *b;
}
int main() {
    int a=5,b=4;
    swap(&a,&b);
    printf("a: %d, b: %d",a,b);
}

```
```
~

[wizard@archlinux tuto]$ ./a.out 
a: 4, b: 5
[wizard@archlinux tuto]$ 

```
