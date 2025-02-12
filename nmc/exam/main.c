#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

int counter = 0;
int finalAdd = -1;
pthread_mutex_t lock;


void* count_thread(void* args){
    while(1){
        pthread_mutex_lock(&lock);
        if (counter >= 50){
            pthread_mutex_unlock(&lock);
            break;
        }
        counter++;
        if (counter == 50 && finalAdd == -1){
            finalAdd = 0;
        }
        pthread_mutex_unlock(&lock);
    }
}

void* count_thread1(void* args){
    while(1){
        pthread_mutex_lock(&lock);
        if (counter >= 50){
            pthread_mutex_unlock(&lock);
            break;
        }
        counter++;
        if (counter == 50 && finalAdd == -1){
            finalAdd = 1;
        }
        pthread_mutex_unlock(&lock);
    }
}

void* count_thread2(void* args){
    while(1){
        pthread_mutex_lock(&lock);
        if (counter >= 50){
            pthread_mutex_unlock(&lock);
            break;
        }
        counter++;
        if (counter == 50 && finalAdd == -1){
            finalAdd = 2;
        }
        pthread_mutex_unlock(&lock);
    }
}


int main() {
    pthread_mutex_init(&lock,NULL);
    pthread_t ids[3];
    pthread_create(&ids[0],NULL,count_thread,NULL);
    pthread_create(&ids[1],NULL,count_thread,NULL);
    pthread_create(&ids[2],NULL,count_thread,NULL);
    pthread_join(ids[0],NULL);
    pthread_join(ids[1],NULL);
    pthread_join(ids[2],NULL);

    printf("Counter: %d, Final Add From thread :%d",counter,finalAdd);
    pthread_mutex_destroy(&lock);
    
}
