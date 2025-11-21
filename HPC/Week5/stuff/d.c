#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

char *messages[3] = {NULL, NULL, NULL};

sem_t empty[3]; 
sem_t full[3];  

sem_t turn_send[3]; 

#define MAX_CYCLES 10

void *messenger(void *p) {
    long tid = (long)p;
    char tmpbuf[100];
    
    for(int i = 0; i < MAX_CYCLES; i++) {
        long int dest = (tid + 1) % 3;

        sem_wait(&turn_send[tid]); 

        sem_wait(&full[tid]);
        
        printf("Thread %ld RECEIVED the message '%s'\n", tid, messages[tid]);
        free(messages[tid]);
        messages[tid] = NULL;
        
        sem_post(&empty[tid]);


        sem_wait(&empty[dest]);

        sprintf(tmpbuf, "Hello from Thread %ld, Cycle %d!", tid, i + 1);
        char *msg = strdup(tmpbuf);
        
        messages[dest] = msg;
        printf("Thread %ld SENT the message to Thread %ld\n", tid, dest);

        sem_post(&full[dest]);

        sem_post(&turn_send[dest]); 
    }
    
    return NULL;
}

int main()
{
    pthread_t thrID1, thrID2, thrID3;
    
    printf("Starting %d cycles of strict RECEIVE-THEN-SEND communication (Semaphores).\n\n", MAX_CYCLES);

    for(int i = 0; i < 3; i++)
    {
        sem_init(&empty[i], 0, 1); 
        sem_init(&full[i], 0, 0);
        
        sem_init(&turn_send[i], 0, 0); 
    }
    
    pthread_create(&thrID1, NULL, messenger, (void *)0);
    pthread_create(&thrID2, NULL, messenger, (void *)1);
    pthread_create(&thrID3, NULL, messenger, (void *)2);
    
    char *initial_msg = strdup("Initial message from main!");
    
    messages[0] = initial_msg; 
    printf("Main sent the initial message to Thread 0\n");

    sem_post(&full[0]);
    sem_post(&turn_send[0]); 
    
    pthread_join(thrID1, NULL);
    pthread_join(thrID2, NULL);
    pthread_join(thrID3, NULL);
    
    for(int i = 0; i < 3; i++)
    {
        sem_destroy(&empty[i]);
        sem_destroy(&full[i]);
        sem_destroy(&turn_send[i]);
    }
    
    printf("\nAll %d cycles completed successfully.\n", MAX_CYCLES);
    
    return 0;
}
