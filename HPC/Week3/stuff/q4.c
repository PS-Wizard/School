#include <pthread.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

typedef struct {
    int thread_id;
    int start;
    int end;
    int* numbers;  
} Range;

int total_primes_found = 0;
pthread_mutex_t count_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_t *threads;
int number_of_threads = 0;

void* find_primes(void* arg) {
    Range* range = (Range*) arg;
    int* count = malloc(sizeof(int));  
    *count = 0;
    
    pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);
    pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, NULL);
    
    for (int i = range->start; i <= range->end; i++) {
        int n = range->numbers[i];
        if (n < 2) continue;
        int lim = sqrt(n);
        int is_prime = 1;
        for (int j = 2; j <= lim; j++) {
            if (n % j == 0) {
                is_prime = 0;
                break;
            }
        }
        if (is_prime) {
            pthread_mutex_lock(&count_mutex);
            total_primes_found++;
            printf("Thread: %d found that the number %d is prime (Total: %d)\n", 
                   range->thread_id, n, total_primes_found);
            (*count)++;
            
            // Check if we've found 5 primes
            if (total_primes_found >= 5) {
                printf("\n5 primes found! Cancelling all threads...\n\n");
                // Cancel all other threads
                for (int t = 0; t < number_of_threads; t++) {
                    if (threads[t] != pthread_self()) {
                        pthread_cancel(threads[t]);
                    }
                }
                pthread_mutex_unlock(&count_mutex);
                pthread_exit((void*) count);
            }
            pthread_mutex_unlock(&count_mutex);
        }
    }
    pthread_exit((void*) count);
}

int main() {
    int number_of_numbers = 0;
    printf("Enter the number of numbers you want to check for prime: ");
    scanf("%d", &number_of_numbers);
    printf("Enter the number of threads you want to use: ");
    scanf("%d", &number_of_threads);
    
    Range *ranges = malloc(number_of_threads * sizeof(Range));
    int *numbers = malloc(number_of_numbers * sizeof(int));  
    threads = malloc(number_of_threads * sizeof(pthread_t));
    
    for (int i = 0; i < number_of_numbers; i++) {
        printf("Enter Number %d: ", i);
        scanf("%d", &numbers[i]);
    }
    
    int numbers_for_each_thread = number_of_numbers / number_of_threads;
    
    // Make Ranges
    for (int i = 0; i < number_of_threads; i++) {
        int start = numbers_for_each_thread * i;
        int end = (i == number_of_threads - 1) ? number_of_numbers - 1 : numbers_for_each_thread * (i + 1) - 1;
        ranges[i] = (Range){i, start, end, numbers};
    }
    
    // Assign Threads
    for (int i = 0; i < number_of_threads; i++) {
        pthread_create(&threads[i], NULL, find_primes, (void *) &ranges[i]);
    }
    
    // Wait for em to finish and get the results
    for (int i = 0; i < number_of_threads; i++) {
        int* count;
        int result = pthread_join(threads[i], (void**) &count);
        
        if (result == 0 && count != NULL) {
            // Thread completed normally
            printf("-------\n");
            printf("Thread %d found %d prime numbers\n", i, *count);
            printf("-------\n");
            free(count);
        } else {
            // Thread was cancelled
            printf("-------\n");
            printf("Thread %d was cancelled\n", i);
            printf("-------\n");
        }
    }
    
    printf("\nTotal primes found: %d\n", total_primes_found);
    
    pthread_mutex_destroy(&count_mutex);
    free(ranges);
    free(threads);
    free(numbers);
}
