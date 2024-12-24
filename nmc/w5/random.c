#include <stdio.h>
#include <stdlib.h>
int main(){
    int *a = malloc(30);
    float *b = malloc(50);
    int *c = malloc(sizeof(char));
    int *some = calloc(3,sizeof(int));

    printf("int: %p, char: %p, float: %p, calloc: %p\n",a,b,c,some);
    printf("%p\n",malloc(1));
    printf("%p\n",malloc(1));
    free(a);free(b);free(c);
}
