#include <stdio.h>
#include <stdlib.h>
int main(){
    int n=3,nn=5;
    int *arr = malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) scanf("%d",(arr+i));  
    for (int i = 0; i < n; i++) printf("%d",*(arr+i));  
    arr = realloc(arr,nn);
    for (int i = n; i < nn; i++) scanf("%d",(arr+i));  
    for (int i = 0; i < nn; i++) printf("%d",*(arr+i));  
    free(arr);

    
}
