#include <stdio.h>
#include <math.h>

void checkArmstrong(){
    int n,sum,tmp;
    printf("Enter a number: ");
    scanf("%d", &n);
    tmp = n;
    int exp = log10(n)+ 1;
    while(tmp){
        sum += pow(tmp % 10,exp);
        tmp /= 10;
    }
    printf("The Number Is %s Armstrong ",(sum == n)? "an":"not an");
}

void checkPerfect(){
    int n,sum;
    printf("Enter a number: ");
    scanf("%d", &n);
    for (int i = 1; i < n ; sum += (n % i == 0)? i:0, i++); 
    printf("The Number Is %s Perfect number",(sum == n)? "a":"not a");

}
int main(){
    checkPerfect(500);
}
