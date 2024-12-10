#include <stdio.h>

int find(int *arr, int Size, int toFind){
    for (int i = 0; i < Size; i++) {
        if (arr[i] == toFind){
            return i;
        }
    }
    printf("Element Not Found ");
    return -1;
}

int main(){
    int a[] = {20, 15, 87, 71, 24, 34};
    int toFind;
    printf("Enter thing to search for: ");
    scanf("%d",&toFind);
    printf("%d\n", find(a, (sizeof(a)/sizeof(a[0])), toFind));
}
