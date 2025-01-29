#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>
#include <math.h>
struct info {
    int start;
    int end;
    long double partial_sum;
    pthread_t id;
};

void* Leibniz(void* args) {
    struct info* range = args;
    long double local_sum = 0;

    for (int i = range->start; i <= range->end; i++) {
        local_sum += (pow(-1, i) / (2 * i + 1));
    }

    range->partial_sum = local_sum;  
    return NULL;
}

int main() {
    int n_iterations, n_threads, division;
    printf("Enter number of iterations and number of threads to perform those iterations: ");
    scanf("%d %d", &n_iterations, &n_threads);
    division = n_iterations / n_threads;
    struct info* threads = malloc(n_threads * sizeof(struct info));
    long double pi_4 = 0;

    for (int i = 0; i < n_threads; i++) {
        threads[i].start = i * division;
        threads[i].end = (i == n_threads - 1) ? n_iterations - 1 : (i + 1) * division - 1;  // -1 here to make the number of iterations correct cause we are counting from 0
        threads[i].partial_sum = 0;
        printf("Start: %d, end: %d \n", threads[i].start, threads[i].end);
        pthread_create(&threads[i].id, NULL, Leibniz, (void*)(&threads[i]));
    }

    for (int i = 0; i < n_threads; i++) {
        pthread_join(threads[i].id, NULL);
    }

    for (int i = 0; i < n_threads; i++) {
        pi_4 += threads[i].partial_sum;
    }

    printf("Pi approximation: %.20Lf\n", pi_4 * 4);
    free(threads);

    return 0;
}
