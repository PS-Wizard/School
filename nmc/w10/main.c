#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h> 

void *thread_function(void *arg) {
    printf("Thread started. Doing work...\n");
    for (int i = 0; i < 5; i++) {
        printf("Working... %d\n", i);
        sleep(1); 
    }
    printf("Thread finished work.\n");
    return NULL;
}

int main() {
    pthread_t thread;

    if (pthread_create(&thread, NULL, thread_function, NULL) != 0) {
        perror("Failed to create thread");
        return 1;
    }

    sleep(2);

    printf("Main: Sending cancellation request to thread...\n");
    if (pthread_cancel(thread) != 0) {
        perror("Failed to cancel thread");
        return 1;
    }

    if (pthread_join(thread, NULL) != 0) {
        perror("Failed to join thread");
        return 1;
    }

    printf("Main: Thread has been canceled.\n");
    return 0;
}
