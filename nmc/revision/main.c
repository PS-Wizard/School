#include <stdio.h>
#include <pthread.h>

struct range {
    int start;
    int end;
    int threadID;
};

void *printStuff(void *args) {
    struct range *arg = (struct range *)args;
    for (int i = arg->start; i < arg->end; i++) {
        printf("Thread %d: %d\n", arg->threadID, i);
    }
    return NULL;
}

int main() {
    pthread_t thingys[5];
    struct range ranges[5];
    int total_numbers = 1000;
    int numbers_per_thread = total_numbers / 5;

    for (int i = 0; i < 5; i++) {
        ranges[i].start = i * numbers_per_thread + 1;
        ranges[i].end = (i + 1) * numbers_per_thread + 1;
        ranges[i].threadID = i + 1;

        pthread_create(&thingys[i], NULL, printStuff, (void *)&ranges[i]);
    }

    for (int i = 0; i < 5; i++) {
        pthread_join(thingys[i], NULL);
    }

    return 0;
}
