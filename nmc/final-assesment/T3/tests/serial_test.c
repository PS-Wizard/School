#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// Function to check if a number is prime
int is_prime(int num) {
    if (num <= 1) return 0; // 0 and 1 are not primes
    if (num == 2) return 1; // 2 is the only even prime
    if (num % 2 == 0) return 0; // Other even numbers are not primes
    for (int i = 3; i <= sqrt(num); i += 2) {
        if (num % i == 0) return 0; // Not a prime if divisible by any number
    }
    return 1; // It's a prime
}

int main() {
    FILE *file1, *file2, *file3;
    int num, total_primes = 0;

    file1 = fopen("PrimeData1.txt", "r");
    file2 = fopen("PrimeData2.txt", "r");
    file3 = fopen("PrimeData3.txt", "r");

    if (file1 == NULL || file2 == NULL || file3 == NULL) {
        perror("Error opening file");
        return EXIT_FAILURE;
    }

    // Read and count primes from PrimeData1.txt
    while (fscanf(file1, "%d", &num) != EOF) {
        if (is_prime(num)) {
            total_primes++;
        }
    }

    // Read and count primes from PrimeData2.txt
    while (fscanf(file2, "%d", &num) != EOF) {
        if (is_prime(num)) {
            total_primes++;
        }
    }

    // Read and count primes from PrimeData3.txt
    while (fscanf(file3, "%d", &num) != EOF) {
        if (is_prime(num)) {
            total_primes++;
        }
    }

    // Close the files
    fclose(file1);
    fclose(file2);
    fclose(file3);

    // Print the total number of primes found
    printf("Total number of primes: %d\n", total_primes);

    return 0;
}
