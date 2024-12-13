#include <stdio.h>
#include <stdlib.h>

int main() {
    int r, c;
    printf("Enter rows and cols: ");
    scanf("%d-%d", &r, &c);
    int *arr1 = malloc(r * c * sizeof(int)), *arr2 = malloc(r * c * sizeof(int));

    printf("First matrix: \n");
    for (int i = 0; i < r * c; i++) scanf("%d", &arr1[i]);

    printf("second matrix: \n");
    for (int i = 0; i < r * c; i++) scanf("%d", &arr2[i]);

    for (int i = 0; i < r * c; i++) 
        printf("%d%c", arr1[i] + arr2[i], (i + 1) % c == 0 ? '\n' : ' ');

    free(arr1), free(arr2);
    return 0;
}

