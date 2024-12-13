#include <stdio.h>

int main() {
    int arr[] = {1, 2, 3, 4, 5, 6}, toSearch = 6, i = 0;
    for (; i < 6 && arr[i] != toSearch; i++);
    printf("%d\n", i < 6 ? i : -1);
    return 0;
}

