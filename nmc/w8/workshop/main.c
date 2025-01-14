#include <stdio.h>
#include <pthread.h>

int factor = 1000; 

struct info {
    int offset;
    int start;
    int end;
};

void *printStuff(void *arg) {
    struct info *data = (struct info *)arg;
    for (int i = data->start; i < data->end; i+=2) {
        printf("%d: %d \n", data->offset, i);
    }
    return NULL;
}

int main() {
    unsigned threads_n;
    scanf("%u", &threads_n);

    int subrange = factor / threads_n; 

    pthread_t threads[threads_n];
    struct info infos[threads_n]; 

    for (int i = 0; i < threads_n; i++) {
        infos[i].offset = i;
        infos[i].start = i * subrange + 1;
        infos[i].end = (i + 1) * subrange;
        pthread_create(&threads[i], NULL, printStuff, (void *)&infos[i]);
    }

    for (int i = 0; i < threads_n; i++) {
        pthread_join(threads[i], NULL);
    }
    return 0;
}

