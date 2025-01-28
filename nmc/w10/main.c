#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

void* threadOne(void* arg) {
    for (int i = 1; i <= 5; i++) {
        if (i == 3) {
            printf("Thread 1 exiting at i = %d\n", i);
            pthread_exit(NULL);  
        }
        printf("Thread 1: %d\n", i);
        sleep(1);
    }
    return NULL;
}

void* threadTwo(void* arg) {
    for (int i = 1; i <= 5; i++) {
        printf("Thread 2: %d\n", i);
        pthread_testcancel();
        sleep(1);
    }
    return NULL;
}

int main() {
    pthread_t thread1, thread2;

    pthread_create(&thread1, NULL, threadOne, NULL);
    pthread_create(&thread2, NULL, threadTwo, NULL);

    sleep(3);  

    printf("Canceling Thread 2...\n");
    pthread_cancel(thread2);

    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    printf("Main thread finished.\n");

    return 0;
}
