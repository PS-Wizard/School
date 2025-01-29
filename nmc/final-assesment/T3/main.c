#include <stdio.h>
#include <pthread.h>
#include <stdint.h>
#include <stdlib.h>

struct Thread {
    pthread_t id;
    uint16_t start;    
    uint16_t end;     
    uint16_t p_count;
};

struct Files {
    char path[1024];
    uint32_t num_count;
    uint32_t* numbers;       
    uint32_t totalPrimeCount;
    struct Thread* threads;  
};

void readnumbers(struct Files* f_info) {
    FILE* file = fopen(f_info->path, "r");
    if (file == NULL) {
        perror("can't open file");
    }

    int def_capacity = 5000;
    f_info->numbers = malloc(def_capacity * sizeof(uint32_t));
    uint32_t count = 0, num;
    while (fscanf(file, "%d", &num) == 1) {
        if (count >= def_capacity) {
            def_capacity += 5000;
            f_info->numbers = realloc(f_info->numbers, def_capacity * sizeof(uint32_t));
        }
        f_info->numbers[count++] = num;
    }
    fclose(file);
    f_info->num_count = count;
}

int main() {
    struct Files datasets[3] = { 
        {"./files/PrimeData1.txt"}, 
        {"./files/PrimeData2.txt"}, 
        {"./files/PrimeData3.txt"} 
    };

    int n_threads, threads_per_file;
    printf("Enter number of threads: ");
    scanf("%d", &n_threads);

    // Distribute threads across files
    int threads_left = n_threads;
    int threads_per_file_base = n_threads / 3;
    int remaining_threads = n_threads % 3;

    for (int i = 0; i < 3; i++) {
        readnumbers(&datasets[i]);

        // Distribute the threads among the files
        threads_per_file = threads_per_file_base + (i < remaining_threads ? 1 : 0);
        datasets[i].threads = malloc(threads_per_file * sizeof(struct Thread));

        int sub_threads_per_file = datasets[i].num_count / threads_per_file;
        int remainder = datasets[i].num_count % threads_per_file;

        for (int j = 0; j < threads_per_file; j++) {
            datasets[i].threads[j].start = j * sub_threads_per_file;
            datasets[i].threads[j].end = (j + 1) * sub_threads_per_file;

            // Distribute the remainder across threads
            if (j < remainder) {
                datasets[i].threads[j].end++;
            }

            datasets[i].threads[j].p_count = 0;
        }
    }

    // Example of how you would print or use the data
    for (int i = 0; i < 3; i++) {
        printf("File: %s\n", datasets[i].path);
        printf("Threads for this file: %d\n", n_threads / 3 + (i < (n_threads % 3)));
        for (int j = 0; j < n_threads / 3 + (i < (n_threads % 3)); j++) {
            printf("Thread %d: Start = %d, End = %d\n", j, datasets[i].threads[j].start, datasets[i].threads[j].end);
        }
    }

    // Free memory after processing
    for (int i = 0; i < 3; i++) {
        free(datasets[i].numbers);
        free(datasets[i].threads);
    }

    return 0;
}
