#include <stdio.h>
int increment(int *a){
    return ++(*a);
}
int main() {
    int x = 5;
    printf("%d %d\n",increment(&x),x);
    return 0;
}
