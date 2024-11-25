// One:

/*int one(){*/
/*    int sum = 0;*/
/*    for (int i = 0; i < 11; i++) {*/
/*        sum += i;*/
/*    }*/
/*    return sum;*/
/*}*/
/*int two(int num) {*/
/*    int tmp = 1;*/
/*    for (int i = num; i > 0; i--) {*/
/*        tmp *= i; */
/*    }*/
/*    return tmp;*/
/*}*/

#include<stdio.h>

int main(){
    char s[] = {'A','B','C','D','E'};
    for (int i = 0 ; i <= 5; i++) {
        for (int j = 0; j <= i; j++) {
                printf("%c",s[i]);
         } 
        printf("\n") ;
    }
}
