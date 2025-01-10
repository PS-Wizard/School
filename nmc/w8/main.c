#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int id;
    int start;
    int end;
} thingy;

void* someFunc(void* p) {
    thingy* args = (thingy*)p; 
    printf("Thread %d: ", args->id);
    for (int i = args->start; i < args->end; i++) {
        printf("%d ", i);
        sleep(1);
    }
    printf("\n");
    return NULL;
}

int main() {
    unsigned n;
    printf("Enter the number of threads: ");
    scanf("%u", &n);

    pthread_t threads[n];
    thingy all_structs[n];

    for (int i = 0; i < n; i++) {
        printf("id, start, end for thread %d: ", i + 1);
        scanf("%d %d %d", &all_structs[i].id, &all_structs[i].start, &all_structs[i].end);
    }

    for (int i = 0; i < n; i++) {
        pthread_create(&threads[i], NULL, someFunc, &all_structs[i]);
    }

    for (int i = 0; i < n; i++) {
        pthread_join(threads[i], NULL);
    }

    return 0;
}
