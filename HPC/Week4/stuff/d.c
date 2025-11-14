#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <math.h>

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
    int* count = (int*)malloc(sizeof(int));   
    *count = 0;

    for (int i = r->start; i <= r->end; i++) {
        if (is_prime(i)) {
            printf("%d\n", i);
            (*count)++;
        }
    }

    pthread_exit(count);
}

int main() {
    int max, n;

    printf("Enter max number: ");
    scanf("%d", &max);

    printf("Enter number of threads: ");
    scanf("%d", &n);

    pthread_t threads[n];
    struct Range ranges[n];

    int chunk = max / n;

    for (int i = 0; i < n; i++) {
        ranges[i].start = i * chunk + 1;
        ranges[i].end = (i == n - 1) ? max : (i + 1) * chunk;

        pthread_create(&threads[i], NULL, check_range, &ranges[i]);
    }

    for (int i = 0; i < n; i++) {
        void* ret;
        pthread_join(threads[i], &ret);

        int count = *((int*)ret);
        printf("Thread %d found %d prime numbers.\n", i, count);

        free(ret);
    }

    return 0;
}
