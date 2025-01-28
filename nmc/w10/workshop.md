# Q1
```c
~

#include<stdio.h>
#include<pthread.h>

int count = 0; 
pthread_mutex_t lock; 

void* fun(void* arg)
{ 	
    pthread_mutex_lock(&lock); 
    count++; 
    printf("Thread %d has started\n", count);

    int i;
    for(i = 1; i <= 1000000; i++) { } 

    printf("Thread %d has finished\n", count);
    pthread_mutex_unlock(&lock); 

    return NULL;
}

void main()
{
    pthread_t thread1, thread2;

    pthread_mutex_init(&lock, NULL); 

    pthread_create(&thread1, NULL, fun, NULL);
    pthread_create(&thread2, NULL, fun, NULL);

    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    pthread_mutex_destroy(&lock); 
}

```
```
~

[wizard@archlinux w10]$ ./a.out
Thread 1 has started
Thread 1 has finished
Thread 2 has started
Thread 2 has finished
```
>
# Q2

```c
~

#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

int counter = 0;               
pthread_mutex_t lock;          

void *threadOne(void *p)
{
    int i, temp;

    for (i = 1; i <= 3; i++) {
        pthread_mutex_lock(&lock); 
        temp = counter;            
        sleep(1);
        counter = temp + 1;        
        pthread_mutex_unlock(&lock); 
    }
    return NULL;
}

void *threadTwo(void *p)
{
    int i, temp;

    for (i = 1; i <= 3; i++) {
        pthread_mutex_lock(&lock); 
        temp = counter;            
        sleep(1);
        counter = temp - 1;        
        pthread_mutex_unlock(&lock); 
    }
    return NULL;
}

void main()
{
    pthread_t thrID1, thrID2;

    pthread_mutex_init(&lock, NULL); 

    pthread_create(&thrID1, NULL, threadOne, NULL);
    pthread_create(&thrID2, NULL, threadTwo, NULL);

    pthread_join(thrID1, NULL);
    pthread_join(thrID2, NULL);

    pthread_mutex_destroy(&lock); 

    printf("counter = %d\n", counter); 
}
```
```
~

[wizard@archlinux w10]$ ./a.out
counter = 0
[wizard@archlinux w10]$
```
>
# Q3

```c
~

#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

void* threadOne(void* arg) {
    for (int i = 1; i <= 5; i++) {
        if (i == 3) {
            printf("Thread 1 exiting at i = %d\n", i);
            pthread_exit(NULL);  
        }
        printf("Thread 1: %d\n", i);
        sleep(1);
    }
    return NULL;
}

void* threadTwo(void* arg) {
    for (int i = 1; i <= 5; i++) {
        printf("Thread 2: %d\n", i);
        pthread_testcancel();
        sleep(1);
    }
    return NULL;
}

int main() {
    pthread_t thread1, thread2;

    pthread_create(&thread1, NULL, threadOne, NULL);
    pthread_create(&thread2, NULL, threadTwo, NULL);

    sleep(3);  

    printf("Canceling Thread 2...\n");
    pthread_cancel(thread2);

    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    printf("Main thread finished.\n");

    return 0;
}

```
```
~

[wizard@archlinux w10]$ ./a.out
Thread 1: 1
Thread 2: 1
Thread 1: 2
Thread 2: 2
Thread 1 exiting at i = 3
Thread 2: 3
Canceling Thread 2...
Main thread finished.
[wizard@archlinux w10]$ ^C
```
