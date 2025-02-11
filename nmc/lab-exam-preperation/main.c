#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

struct pthread_info {
    unsigned start;
    unsigned end;
    pthread_t id;
};

void* printStuff(void* args){
    struct pthread_info* ranges = (struct pthread_info*)args;
    for (int i = ranges->start; i < ranges->end; i++) {
       printf("Thread: %p: %d\n",ranges->id,i); 
    }
}

int main(){
    struct pthread_info threads[2];
    for (int i = 0; i < 2; i++) {
        threads[i].start = (i * 500)+1;
        threads[i].end = (i+1)*500;
        pthread_create(&(threads[i].id),NULL,printStuff,(void*)&threads[i]);
    }

    for (int i = 0; i < 2; i++) {
        pthread_join(threads[i].id,NULL);
    }
}
