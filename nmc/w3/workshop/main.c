#include <stdio.h>

int findMin(int *a, int *b){
    return (*a < *b)? *a:*b;
}

int main(){
    int a,b;
    printf("Enter input: a,b: ");
    scanf("%d,%d", &a,&b);
    printf("The Miniumum Is %d\n", findMin(&a,&b));
}
