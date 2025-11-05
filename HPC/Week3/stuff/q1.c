#include <pthread.h>
#include <stdio.h>
#include <stdbool.h>
#include <math.h>

void* is_prime(void* num) {
    int casted_num = *(int *)(num);
    if (casted_num<2){
        printf("%d is not prime\n", casted_num);
        return NULL;
    }

    int lim = (int)sqrt(casted_num);
    for (int i = 2; i <= lim; i++) {
        if (casted_num % i == 0) {
            return NULL;
        }
    }
    printf("The Number: %d, is prime\n", casted_num);
    return NULL;
}


int main(){
    pthread_t t1,t2,t3;
    int n1=4, n2=13, n3=22;
    pthread_create(&t1, NULL, is_prime, &n1);
    pthread_create(&t2, NULL, is_prime, &n2);
    pthread_create(&t3, NULL, is_prime, &n3);
    pthread_join(t1, NULL);
    pthread_join(t2, NULL);
    pthread_join(t3, NULL);
    return 0;
}
