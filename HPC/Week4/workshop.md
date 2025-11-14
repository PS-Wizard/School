## Write a multithreaded C program to print out all the prime numbers between 1 to 10000. Use exactly 3 threads.

```c
#include <stdio.h>
#include <pthread.h>
#include <math.h>

#define MAX 10000
#define THREADS 3

struct Range {
    int start;
    int end;
};

int is_prime(int n) {
    if (n < 2) return 0;
    for (int i = 2; i <= sqrt(n); i++) {
        if (n % i == 0) return 0;
    }
    return 1;
}

void* check_range(void* arg) {
    struct Range* r = (struct Range*)arg;
    for (int i = r->start; i <= r->end; i++) {
        if (is_prime(i)) {
            printf("%d\n", i);
        }
    }
    return NULL;
}

int main() {
    pthread_t threads[THREADS];
    struct Range ranges[THREADS];

    int chunk = MAX / THREADS;

    for (int i = 0; i < THREADS; i++) {
        ranges[i].start = i * chunk + 1;
        ranges[i].end = (i == THREADS - 1) ? MAX : (i + 1) * chunk;
        pthread_create(&threads[i], NULL, check_range, &ranges[i]);
    }

    for (int i = 0; i < THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    return 0;
}
```

---

## Convert this program to prompt the user for a number and then to create the number of threads the user has specified to find the prime numbers.


```c
#include <stdio.h>
#include <pthread.h>
#include <math.h>

struct Range {
    int start;
    int end;
};

int is_prime(int n) {
    if (n < 2) return 0;
    for (int i = 2; i <= sqrt(n); i++) {
        if (n % i == 0) return 0;
    }
    return 1;
}

void* check_range(void* arg) {
    struct Range* r = (struct Range*)arg;
    for (int i = r->start; i <= r->end; i++) {
        if (is_prime(i)) {
            printf("%d\n", i);
        }
    }
    return NULL;
}

int main() {
    int max, n;

    printf("Enter max number: ");
    scanf("%d", &max);

    printf("Enter number of threads: ");
    scanf("%d", &n);

    pthread_t threads[n];
    struct Range ranges[n];

    int chunk = max / n;

    for (int i = 0; i < n; i++) {
        ranges[i].start = i * chunk + 1;
        ranges[i].end = (i == n - 1) ? max : (i + 1) * chunk;
        pthread_create(&threads[i], NULL, check_range, &ranges[i]);
    }

    for (int i = 0; i < n; i++) {
        pthread_join(threads[i], NULL);
    }

    return 0;
}
```

---

## Convert the program in (2) so that each thread returns the number of prime numbers that it has found using pthread_exit() and for main program to print out the number of prime number that each thread has found.


```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <math.h>

struct Range {
    int start;
    int end;
};

int is_prime(int n) {
    if (n < 2) return 0;
    for (int i = 2; i <= sqrt(n); i++) {
        if (n % i == 0) return 0;
    }
    return 1;
}

void* check_range(void* arg) {
    struct Range* r = (struct Range*)arg;
    int* count = (int*)malloc(sizeof(int));   
    *count = 0;

    for (int i = r->start; i <= r->end; i++) {
        if (is_prime(i)) {
            printf("%d\n", i);
            (*count)++;
        }
    }

    pthread_exit(count);
}

int main() {
    int max, n;

    printf("Enter max number: ");
    scanf("%d", &max);

    printf("Enter number of threads: ");
    scanf("%d", &n);

    pthread_t threads[n];
    struct Range ranges[n];

    int chunk = max / n;

    for (int i = 0; i < n; i++) {
        ranges[i].start = i * chunk + 1;
        ranges[i].end = (i == n - 1) ? max : (i + 1) * chunk;

        pthread_create(&threads[i], NULL, check_range, &ranges[i]);
    }

    for (int i = 0; i < n; i++) {
        void* ret;
        pthread_join(threads[i], &ret);

        int count = *((int*)ret);
        printf("Thread %d found %d prime numbers.\n", i, count);

        free(ret);
    }

    return 0;
}
```

---

## Convert the program in (3) to use pthread_cancel() to cancel all threads as soon as the 5th prime number has been found.

```c
#include <stdio.h>
#include <pthread.h>
#include <math.h>
#include <unistd.h>

struct Range {
    int start;
    int end;
    int id;
};

pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
int global_prime_count = 0;
pthread_t *thread_list;
int thread_count;

int is_prime(int n) {
    if (n < 2) return 0;
    for (int i = 2; i <= sqrt(n); i++) {
        if (n % i == 0) return 0;
    }
    return 1;
}

void* check_range(void* arg) {
    struct Range* r = (struct Range*)arg;

    pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL); // Makes this thread cancellable

    pthread_setcanceltype(PTHREAD_CANCEL_DEFERRED, NULL); // Defer till it hits cancel point

    for (int i = r->start; i <= r->end; i++) {
        pthread_testcancel();  // cancel point

        if (is_prime(i)) {
            pthread_mutex_lock(&lock);

            if (global_prime_count < 5) {
                global_prime_count++;
                printf("Thread %d found prime %d (global count = %d)\n",
                       r->id, i, global_prime_count);

                if (global_prime_count == 5) {
                    for (int t = 0; t < thread_count; t++) {
                        if (pthread_self() != thread_list[t])
                            pthread_cancel(thread_list[t]);
                    }
                    pthread_mutex_unlock(&lock);
                    pthread_exit(NULL);
                }
            }
            pthread_mutex_unlock(&lock);
        }
    }

    return NULL;
}

int main() {
    int max;

    printf("Enter max number: ");
    scanf("%d", &max);

    printf("Enter number of threads: ");
    scanf("%d", &thread_count);

    pthread_t threads[thread_count];
    thread_list = threads;

    struct Range ranges[thread_count];
    int chunk = max / thread_count;

    for (int i = 0; i < thread_count; i++) {
        ranges[i].start = i * chunk + 1;
        ranges[i].end   = (i == thread_count - 1) ? max : (i + 1) * chunk;
        ranges[i].id    = i;

        pthread_create(&threads[i], NULL, check_range, &ranges[i]);
    }

    for (int i = 0; i < thread_count; i++) {
        pthread_join(threads[i], NULL);
    }

    printf("Final global prime count: %d\n", global_prime_count);
    return 0;
}
```

---

## In a banking system, multiple users can access and modify their accounts concurrently. Each user has a balance, and they can deposit or withdraw money. Modify the code below to use a mutex to prevent race conditions during balance updates and ensure that multiple users can't simultaneously update the balance of the same account.

```c
typedef struct {
    int accountNumber;
    double balance;
} Account;

Account accounts[10];

void *withdraw(void *p) {
    int accountId = *(int *)p;
    double amount = 100;  // Withdraw amount
    accounts[accountId].balance -= amount;
}

void *deposit(void *p) {
    int accountId = *(int *)p;
    double amount = 100;  // Deposit amount
    accounts[accountId].balance += amount;
}

int main() {
    pthread_t threads[20];
    int ids[10];
    // Create multiple threads to simulate transactions on the same account
    for (int i = 0; i < 10; i++) {
        ids[i] = i;
        pthread_create(&threads[i], NULL, withdraw, &ids[i]);
        pthread_create(&threads[i + 10], NULL, deposit, &ids[i]);
    }
    for (int i = 0; i < 20; i++) {
        pthread_join(threads[i], NULL);
    }
    // Print final balance
    for (int i = 0; i < 10; i++) {
        printf("Account %d balance = %.2f\n", i, accounts[i].balance);
    }
}

```

==Thread Safe Version:==
```c

#include <stdio.h>
#include <pthread.h>

typedef struct {
    int accountNumber;
    double balance;
    pthread_mutex_t lock;   // mutex for this specific account
} Account;

Account accounts[10];

void *withdraw(void *p) {
    int accountId = *(int *)p;
    double amount = 100;

    pthread_mutex_lock(&accounts[accountId].lock);   // lock the account
    accounts[accountId].balance -= amount;
    pthread_mutex_unlock(&accounts[accountId].lock);

    return NULL;
}

void *deposit(void *p) {
    int accountId = *(int *)p;
    double amount = 100;

    pthread_mutex_lock(&accounts[accountId].lock);   // lock the account
    accounts[accountId].balance += amount;
    pthread_mutex_unlock(&accounts[accountId].lock);

    return NULL;
}

int main() {
    pthread_t threads[20];
    int ids[10];

    // initialize accounts + mutexes
    for (int i = 0; i < 10; i++) {
        accounts[i].accountNumber = i;
        accounts[i].balance = 1000.0;  // initial balance
        pthread_mutex_init(&accounts[i].lock, NULL);
    }

    // create withdraw + deposit threads
    for (int i = 0; i < 10; i++) {
        ids[i] = i;
        pthread_create(&threads[i], NULL, withdraw, &ids[i]);
        pthread_create(&threads[i + 10], NULL, deposit, &ids[i]);
    }

    for (int i = 0; i < 20; i++) {
        pthread_join(threads[i], NULL);
    }

    // print results
    for (int i = 0; i < 10; i++) {
        printf("Account %d balance = %.2f\n", i, accounts[i].balance);
        pthread_mutex_destroy(&accounts[i].lock);
    }

    return 0;
}
```
---

## A printer is shared among multiple users. Each user can either print a document or wait if the printer is in use. There are only 2 printers in the office. Use semaphores to manage the printer access, ensuring that no more than 2 users can print at the same time.


```c
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>

sem_t printer_sem; 

void* print_document(void* arg) {
    int userId = *(int*)arg;

    sem_wait(&printer_sem);   // get a printer

    printf("User %d is using a printer...\n", userId);
    sleep(1);  // simulate printing time
    printf("User %d finished printing.\n", userId);

    sem_post(&printer_sem);   // release printer

    return NULL;
}

int main() {
    pthread_t threads[10];
    int ids[10];

    // initialize semaphore to 2 printers
    sem_init(&printer_sem, 0, 2);

    // create user threads
    for (int i = 0; i < 10; i++) {
        ids[i] = i;
        pthread_create(&threads[i], NULL, print_document, &ids[i]);
    }

    // wait for all users
    for (int i = 0; i < 10; i++) {
        pthread_join(threads[i], NULL);
    }

    sem_destroy(&printer_sem);

    return 0;
}
```
