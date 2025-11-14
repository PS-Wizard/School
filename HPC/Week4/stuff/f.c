#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

sem_t printer_sem; 

void* print_document(void* arg) {
    int userId = *(int*)arg;

    sem_wait(&printer_sem);   // get a printer

    printf("User %d is using a printer...\n", userId);
    sleep(1);  // simulate printing time
    printf("User %d finished printing.\n", userId);

    sem_post(&printer_sem);   // release printer

    return NULL;
}

int main() {
    pthread_t threads[10];
    int ids[10];

    // initialize semaphore to 2 printers
    sem_init(&printer_sem, 0, 2);

    // create user threads
    for (int i = 0; i < 10; i++) {
        ids[i] = i;
        pthread_create(&threads[i], NULL, print_document, &ids[i]);
    }

    // wait for all users
    for (int i = 0; i < 10; i++) {
        pthread_join(threads[i], NULL);
    }

    sem_destroy(&printer_sem);

    return 0;
}
