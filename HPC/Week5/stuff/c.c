#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>

char *messages[3] = {NULL, NULL, NULL};

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER; 

pthread_cond_t can_act[3] = {
    PTHREAD_COND_INITIALIZER,
    PTHREAD_COND_INITIALIZER,
    PTHREAD_COND_INITIALIZER
};

int current_turn = 0; 
#define MAX_CYCLES 10

void *messenger(void *p) {
    long tid = (long)p;
    char tmpbuf[100];
    
    for(int i = 0; i < MAX_CYCLES; i++) {
        long int dest = (tid + 1) % 3;
        
        pthread_mutex_lock(&mutex);

        while (current_turn != tid || messages[tid] == NULL) {
            pthread_cond_wait(&can_act[tid], &mutex);
        }

        printf("Thread %ld RECEIVED the message '%s'\n", tid, messages[tid]);
        free(messages[tid]); messages[tid] = NULL;
        
        sprintf(tmpbuf, "Hello from Thread %ld, Cycle %d!", tid, i + 1);
        char *msg = strdup(tmpbuf);
        messages[dest] = msg;
        
        printf("Thread %ld SENT the message to Thread %ld\n", tid, dest);
        
        current_turn = dest;

        pthread_cond_signal(&can_act[dest]);
        
        pthread_mutex_unlock(&mutex);
    }
    
    return NULL;
}

int main()
{
    pthread_t thrID1, thrID2, thrID3;
    
    printf("Starting %d cycles of strict RECEIVE-THEN-SEND communication, initiated by main.\n\n", MAX_CYCLES);
    
    pthread_create(&thrID1, NULL, messenger, (void *)0);
    pthread_create(&thrID2, NULL, messenger, (void *)1);
    pthread_create(&thrID3, NULL, messenger, (void *)2);
    
    pthread_mutex_lock(&mutex);
    char *initial_msg = strdup("Initial message from main!");
    messages[0] = initial_msg;
    
    printf("Main sent the initial message to Thread 0\n");
    
    pthread_cond_signal(&can_act[0]);
    pthread_mutex_unlock(&mutex);
    
    pthread_join(thrID1, NULL);
    pthread_join(thrID2, NULL);
    pthread_join(thrID3, NULL);
    
    pthread_mutex_destroy(&mutex);
    for(int i = 0; i < 3; i++) {
        pthread_cond_destroy(&can_act[i]);
    }
    
    printf("\nAll %d cycles completed successfully.\n", MAX_CYCLES);
    
    return 0;
}
