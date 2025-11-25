#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

//
// void *thread_func(void *arg) {
//     int *num = (int *)  arg;
//     printf("Thread received: %d\n", *num);
//
//     int *result = malloc(sizeof(int));
//     *result = *num * 2;
//
//     return result;
// }l
//
// int main() {
//     pthread_t thread;
//     int input = 42;
//     int *output;
//
//     if (pthread_create(&thread, NULL, thread_func, &input) != 0 ) {
//         printf("Error creating thread");
//         return 1;
//     }
//
//     printf("main thread continues");
//
//     if (pthread_join(thread, (void **)&output) != 0) {
//         perror("pthread_join failed");
//         return 1;
//     }
//     printf("Thread returned: %d\n", *output);
//     free(output);
//
//     return 0;
// }
//

void *background_worker(void *arg) {
    // can detach itself
    pthread_detach(pthread_self());
    
    // Do some background task
    sleep(2);
    printf("Background task complete\n");
    
    return NULL;  // Nobody listening anyway
}

int main() {
    pthread_t t1, t2, t3;
    
    // Spawn multiple background workers
    pthread_create(&t1, NULL, background_worker, NULL);
    // can detach from main too
    //pthread_detach(&t1);  

    pthread_create(&t2, NULL, background_worker, NULL);
    pthread_create(&t3, NULL, background_worker, NULL);

    
    // sleep(3);  // Wait a bit so they can finish
    printf("Main exiting\n");
    return 0;
}
