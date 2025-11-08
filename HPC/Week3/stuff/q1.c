#include <pthread.h>
#include <stdio.h>
#include <math.h>

typedef struct {
    int start;
    int end;
}  Range;


void* find_primes(void* arg) {
    Range* range = (Range*) arg;

    for (int n = range->start; n <= range->end; n++) {
        if (n < 2) continue;

        int lim = sqrt(n);
        int is_prime = 1;
        for (int i = 2; i <= lim; i++) {
            if (n % i == 0) {
                is_prime = 0;
                break;
            }
        }

        if (is_prime)
            printf("%d is prime\n", n);
    }

    return NULL;
}

int main(){
    pthread_t threads[3];
    Range ranges[3];

    int numbers_per_thread = 10000 / 3;

    for (int i = 0; i < 3; i++) {
        ranges[i].start = i * numbers_per_thread + 1;
        // If last thread, just take up the rest that's remaining
        ranges[i].end = (i == 3 - 1)? 10000 : (i + 1) * numbers_per_thread;
    }


    for (int i = 0; i < 3; i++) {
        pthread_create(&threads[i], NULL, find_primes, &ranges[i]);
    }

    for (int i = 0; i < 3; i++) {
        pthread_join(threads[i], NULL);
    }

    return 0;

}
