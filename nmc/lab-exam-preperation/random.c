#include <stdio.h>
#include <math.h>
int main(){
    int a;
    char str[100];
    if (scanf("%d",&a) == 1){
        printf("Entered Digit: %d",a);
    }else if(scanf("%s",str) == 1){
        printf("Entered String: %s",str);
    }

}
