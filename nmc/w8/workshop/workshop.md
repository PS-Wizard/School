## Write a program that creates two threads to display the numbers from 1-1000. The two threads should equally contribute to display the numbers. 
```c
~

#include <stdio.h>
#include <pthread.h>
struct info {
    int offset;
};
void *printStuff(void* arg){
    struct info *data= (struct info *)arg;
    for(int i = data->offset * 500; i < 500 * (data->offset + 1); i++ ){
        printf("%d: %d\n", data->offset, i);
    }
}

int main(){
    pthread_t threads[2];
    struct info infos[2] = { {0},{1} };
    for (int i = 0; i < 2; i++) {
        pthread_create(&threads[i],NULL,printStuff,(void *)&infos[i]);
    }
    for (int i = 0; i < 2; i++) {
        pthread_join(threads[i],NULL);
    }
}
```
>
## Write a program that creates 5 threads to display the numbers from 1-1000.The five threads should equally contribute to display the numbers. 
```c
~

#include <stdio.h>
#include <pthread.h>
struct info {
    int offset;
};
void *printStuff(void* arg){
    struct info *data= (struct info *)arg;
    for(int i = data->offset * 200 ; i < 200 * (data->offset + 1); i++ ){
        printf("%d: %d\n", data->offset, i);
    }
}

int main(){
    pthread_t threads[5];
    struct info infos[5] = { {0},{1},{2},{3},{4} };
    for (int i = 0; i < 5; i++) {
        pthread_create(&threads[i],NULL,printStuff,(void *)&infos[i]);
    }
    for (int i = 0; i < 5; i++) {
        pthread_join(threads[i],NULL);
    }
}

```
>
## Convert program no. 2 to accept an integer to specify the number of threads and then create that number of threads dynamically. All the threads will equally contribute to display the numbers from 1-1000. 
```c
~

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
    for (int i = data->start; i < data->end; i++) {
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
        infos[i].start = i * subrange;
        infos[i].end = (i + 1) * subrange;
        pthread_create(&threads[i], NULL, printStuff, (void *)&infos[i]);
    }

    for (int i = 0; i < threads_n; i++) {
        pthread_join(threads[i], NULL);
    }

    return 0;
}

```
>
## Create a multithreaded program to display all the odd numbers from 1-1000. Your program should ask the user to input the number of threads. Based on the number of threads you should divide the workload among the threads.
```c
~

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

```
