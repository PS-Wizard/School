#include "./array_ops.h"

int find_max(int *a, int n) {
    int m = a[0];
    for(int i = 1; i < n; i++) if (a[i] > m) m = a[i]; 
    return m;
}

void bubble_sort(int *arr, int size) {
    for(int i = 0; i < size-1; i++) {
        for(int j = 0; j < size-i-1; j++){
            if(arr[j] > arr[j+1]) {
                int tmp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = tmp;
            }
        }
    }
}
