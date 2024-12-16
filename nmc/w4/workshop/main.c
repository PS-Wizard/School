#include <stdio.h>
#include <stdlib.h>
int sum(int *a, int size){
    int sum = 0;
    for (int i = 0; i < size; i++) sum += a[i];
    return sum;
}
int main(){
    int leng=0;
    printf("Enter the length of the arrays: ");
    scanf("%d",&leng);
    int *ptr = malloc(leng * sizeof(int));
    printf("Enter array: \n");
    for (int i = 0; i < leng; i++) scanf("%d",ptr+i);
    printf("Sum is %d",sum(ptr,leng));
    free(ptr);
}
