#include<stdio.h>
int main(){
    for (char i = 'A' ; i <= 'E'; i++) {
        for (int j = 'A'; j <= i; j++) {
                printf("%c",i);
         } 
        printf("\n") ;
    }
}
