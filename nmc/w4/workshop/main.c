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

