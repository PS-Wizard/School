#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>

// Shared state
char *messages[3] = {NULL, NULL, NULL};

// The ID of the thread that is currently allowed to be the active thread (Receive THEN Send)
int turn = 0; 

void *messenger(void *p) {
    long tid = (long)p;
    char tmpbuf[100];

    for(int i = 0; i < 10; i++) {
        long int dest = (tid + 1) % 3; 

        while(turn != tid) { }
        
        while(messages[tid] == NULL) {}

        printf("Thread %ld RECEIVED the message '%s'\n", tid, messages[tid]);
        free(messages[tid]);
        messages[tid] = NULL;
        
        while(messages[dest] != NULL) {}

        sprintf(tmpbuf, "Hello from Thread %ld, Cycle %d!", tid, i + 1);
        char *msg = strdup(tmpbuf);
        messages[dest] = msg;

        printf("Thread %ld SENT the message to Thread %ld\n", tid, dest);
        
        turn = (tid + 1) % 3;
    }
    return NULL;
}

int main() {
    pthread_t thrID1, thrID2, thrID3;

    printf("Starting 10 cycles of strict communication (RECEIVE THEN SEND):\n");
    printf("Main sends to T0 to initiate the cycle.\n\n");
    
    // Create threads with IDs 0, 1, and 2
    pthread_create(&thrID1, NULL, messenger, (void *)0);
    pthread_create(&thrID2, NULL, messenger, (void *)1);
    pthread_create(&thrID3, NULL, messenger, (void *)2);

    // INITIATE THE CYCLE:
    // Send the first message to Thread 0's slot.
    // Thread 0 will be waiting for this message after it acquires the turn.
    char *msg = strdup("Initial message from main!");
    messages[0] = msg;
    
    // Wait for all threads to finish
    pthread_join(thrID1, NULL);
    pthread_join(thrID2, NULL);
    pthread_join(thrID3, NULL);

    printf("\nAll 10 cycles completed successfully.\n");

    return 0;
}
