#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <omp.h>

int is_prime(uint32_t num) {
    if (num < 2) return 0;
    if (num == 2) return 1;
    if (num % 2 == 0) return 0;
    for (uint32_t i = 3; i <= sqrt(num); i += 2) {
        if (num % i == 0) return 0;
    }
    return 1;
}

int main() {
    FILE* file = fopen("./prime_numbers.txt", "r");
    if (!file) {
        perror("Failed to open file");
        return 1;
    }

    uint32_t* numbers = malloc(110882 * sizeof(uint32_t)); // Assuming max 110882 numbers
    uint32_t count = 0;

    while (fscanf(file, "%u", &numbers[count]) == 1) {
        count++;
    }
    fclose(file);

    uint32_t false_primes = 0;

    #pragma omp parallel for reduction(+:false_primes)
    for (uint32_t i = 0; i < count; i++) {
        if (!is_prime(numbers[i])) {
            #pragma omp critical
            printf("%u is NOT prime!\n", numbers[i]);
            false_primes++;
        }
    }

    printf("Total non-prime numbers found: %u\n", false_primes);
    free(numbers);
    return 0;
}
