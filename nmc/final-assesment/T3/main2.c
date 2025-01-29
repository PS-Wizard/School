#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <pthread.h>
#include <math.h>

struct Files {
    char path[1024];
    uint32_t* numbers;
    uint32_t num_count;
    uint32_t* prime_index;
};

int is_prime(int num) {
    if (num <= 1) return 0;
    if (num == 2) return 1;
    if (num % 2 == 0) return 0;
    for (int i = 3; i <= sqrt(num); i += 2) {
        if (num % i == 0) return 0;
    }
    return 1;
}

void readnumbers(struct Files* f_info) {
    FILE* file = fopen(f_info->path, "r");
    if (file == NULL) {
        perror("can't open file");
        return;
    }

    int def_capacity = 50000;
    f_info->numbers = malloc(def_capacity * sizeof(uint32_t));
    uint32_t count = 0, num;

    while (fscanf(file, "%d", &num) == 1) {
        if (count >= def_capacity) {
            def_capacity += 50000;
            f_info->numbers = realloc(f_info->numbers, def_capacity * sizeof(uint32_t));
        }
        f_info->numbers[count++] = num;
    }

    fclose(file);
    f_info->num_count = count;
}

struct ThreadData {
    struct Files* f_info;
    uint32_t start_index;
    uint32_t end_index;
};

void* check_prime(void* arg) {
    struct ThreadData* data = (struct ThreadData*) arg;
    struct Files* f_info = data->f_info;
    
    for (uint32_t i = data->start_index; i < data->end_index; i++) {
        if (is_prime(f_info->numbers[i])) {
            f_info->prime_index[i] = 1;
        }
    }

    return NULL;
}

void write_primes_to_file(struct Files* f_info) {
    FILE* prime_file = fopen("prime_numbers.txt", "w");
    if (prime_file == NULL) {
        perror("Unable to open prime_numbers.txt");
        return;
    }

    for (uint32_t i = 0; i < f_info->num_count; i++) {
        if (f_info->prime_index[i] == 1) {
            fprintf(prime_file, "%u\n", f_info->numbers[i]);
        }
    }

    fclose(prime_file);
}

int main() {
    int n_threads;
    struct Files datasets[3] = {
        {"./files/PrimeData1.txt"},
        {"./files/PrimeData2.txt"},
        {"./files/PrimeData3.txt"}
    };

    for (int i = 0; i < 3; i++) {
        readnumbers(&datasets[i]);
        printf("File: %s\n", datasets[i].path);
        printf("Total numbers read: %u\n", datasets[i].num_count);
    }

    printf("Enter the number of threads: ");
    scanf("%d", &n_threads);

    for (int i = 0; i < 3; i++) {
        datasets[i].prime_index = calloc(datasets[i].num_count, sizeof(uint32_t));
    }

    pthread_t threads[n_threads];
    for (int i = 0; i < 3; i++) {
        int chunk_size = datasets[i].num_count / n_threads;
        for (int j = 0; j < n_threads; j++) {
            struct ThreadData* data = malloc(sizeof(struct ThreadData));
            data->f_info = &datasets[i];
            data->start_index = j * chunk_size;
            data->end_index = (j == n_threads - 1) ? datasets[i].num_count : (j + 1) * chunk_size;
            pthread_create(&threads[j], NULL, check_prime, data);
        }

        
        for (int j = 0; j < n_threads; j++) {
            pthread_join(threads[j], NULL);
        }
    }

    
    for (int i = 0; i < 3; i++) {
        write_primes_to_file(&datasets[i]);
        free(datasets[i].prime_index);  
        free(datasets[i].numbers);   
    }
    return 0;
}

