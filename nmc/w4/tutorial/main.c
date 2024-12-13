#include <stdio.h>
#include <stdlib.h>

int main() {
    int *arr = malloc(3 * sizeof(int));
    arr = realloc(arr, 6 * sizeof(int));
    for (int i = 0; i < 6; i++) scanf("%d", &arr[i]);
    for (int i = 0; i < 6; i++) printf("%d\n", arr[i]);
    free(arr);
    return 0;
}

