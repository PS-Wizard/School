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

