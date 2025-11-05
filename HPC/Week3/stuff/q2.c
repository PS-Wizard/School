#include <pthread.h>
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <math.h>

void* is_prime(void* num) {
    int n = *(int*)num;

    if (n < 2) {
        printf("%d is not prime\n", n);
        return NULL;
    }

    int lim = (int)sqrt(n);
    for (int i = 2; i <= lim; i++) {
        if (n % i == 0) {
            printf("%d is not prime\n", n);
            return NULL;
        }
    }

    printf("%d is prime\n", n);
    return NULL;
}

int main() {
    int count;

    printf("How many numbers do you want to check for primes? ");
    scanf("%d", &count);

    if (count <= 0) {
        printf("Invalid count.\n");
        return 1;
    }

    pthread_t* threads = malloc(count * sizeof(pthread_t));
    int* numbers = malloc(count * sizeof(int));

    if (!threads || !numbers) {
        printf("Memory allocation failed.\n");
        return 1;
    }

    for (int i = 0; i < count; i++) {
        printf("Enter number %d: ", i + 1);
        scanf("%d", &numbers[i]);
    }

    for (int i = 0; i < count; i++) {
        pthread_create(&threads[i], NULL, is_prime, &numbers[i]);
    }

    for (int i = 0; i < count; i++) {
        pthread_join(threads[i], NULL);
    }

    free(threads);
    free(numbers);

    return 0;
}
