#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void *threadFunc(void *arg) {
    int id = *(int *)arg;
    free(arg);
    for(int i = 0; i < 10; i++) {
        printf("Thread %d (ID %ld): i=%d\n", id, pthread_self(), i);
        usleep(1000);
    }
}

int main(int argc, char *argv[]) {
    int numThreads = atoi(argv[1]);
    pthread_t *threads = malloc(numThreads * sizeof(pthread_t));

    for(int i = 0; i < numThreads; i++) {
        int *id = malloc(sizeof(int));
        *id = i; 
        pthread_create(&threads[i], NULL, threadFunc, id);
    }

    for(int i = 0; i < numThreads; i++) {
        pthread_join(threads[i], NULL);
    }

    free(threads);
    return 0;
}
