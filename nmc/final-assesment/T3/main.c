#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

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
    scanf("%d",&n_threads);
    for (int i = 0; i < 3; i++) {
        free(datasets[i].numbers);
    }



    return 0;
}
