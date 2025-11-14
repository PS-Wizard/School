#include <stdio.h>
#include <pthread.h>
#include <math.h>

#define MAX 10000
#define THREADS 3

struct Range {
    int start;
    int end;
};

int is_prime(int n) {
    if (n < 2) return 0;
    for (int i = 2; i <= sqrt(n); i++) {
        if (n % i == 0) return 0;
    }
    return 1;
}

void* check_range(void* arg) {
    struct Range* r = (struct Range*)arg;
    for (int i = r->start; i <= r->end; i++) {
        if (is_prime(i)) {
            printf("%d\n", i);
        }
    }
    return NULL;
}

int main() {
    pthread_t threads[THREADS];
    struct Range ranges[THREADS];

    int chunk = MAX / THREADS;

    for (int i = 0; i < THREADS; i++) {
        ranges[i].start = i * chunk + 1;
        ranges[i].end = (i == THREADS - 1) ? MAX : (i + 1) * chunk;
        pthread_create(&threads[i], NULL, check_range, &ranges[i]);
    }

    for (int i = 0; i < THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    return 0;
}
