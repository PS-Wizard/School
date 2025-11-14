### **Write a multithreaded C program to print out all the prime numbers between 1 to 10000. Use exactly 3 threads.**
We:
- Divide the number 10000 into 3 threads, with the first 2 taking (10000/3) and the last one taking the remaining threads
- We create a range using that division, and each thread calls the `is_prime` function. 
- The `is_prime` function checks if a number is prime, returns `1` if true, else `0`
    - If true, the thread that called the function `is_prime` prints the number

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

### **Convert this program to prompt the user for a number and then to create the number of threads the user has specified to find the prime numbers.**
We:
- Ask the user for a maximum number to check for primes and the number of threads they want to use.
- Divide the range `1..max` into `n` chunks based on the number of threads.
- Each chunk is (max / n) numbers, except the last thread gets any remainder.
- Each thread runs `check_range`, calling `is_prime `for each number in its chunk.
- If a number is prime, the thread prints it.
- All threads run concurrently, then main waits for all of them to finish with `pthread_join`.

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

### **Convert the program in (2) so that each thread returns the number of prime numbers that it has found using pthread_exit() and for main program to print out the number of prime number that each thread has found.**
We:

- Same setup as (2), but now each thread keeps a count of the prime numbers it finds.
- The thread allocates an int on the heap for the count (malloc) so it can safely return it.
- For every prime it finds, it prints the number and increments its counter.
- The thread exits with `pthread_exit(count)` returning its prime count to main.
- main collects each thread’s count via `pthread_join` and prints how many primes each thread found.
- We free the memory allocated by each thread after reading the count.

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

### **Convert the program in (3) to use pthread_cancel() to cancel all threads as soon as the 5th prime number has been found.**

We:

- Use a global counter `global_prime_count` with a mutex to track the total number of primes found.
- Each thread is cancellable (`pthread_setcancelstate`) and checks for cancellation at safe points (`pthread_testcancel`).
- Each thread loops through its assigned range, calling `is_prime`.
- When a thread finds a prime:
    - It locks the mutex, increments the global count, and prints the prime.
    - If the global count hits 5, it cancels all other threads and exits.
- main waits for all threads to finish (`pthread_join`) and prints the final global prime count.

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

```bash
[wizard@archlinux stuff]$ gcc e.c -lm
[wizard@archlinux stuff]$ ./a.out
Enter max number: 100
Enter number of threads: 3
Thread 0 found prime 2 (global count = 1)
Thread 1 found prime 37 (global count = 2)
Thread 1 found prime 41 (global count = 3)
Thread 1 found prime 43 (global count = 4)
Thread 2 found prime 67 (global count = 5)
Final global prime count: 5
[wizard@archlinux stuff]$
```
---

### **In a banking system, multiple users can access and modify their accounts concurrently. Each user has a balance, and they can deposit or withdraw money. Modify the code below to use a mutex to prevent race conditions during balance updates and ensure that multiple users can't simultaneously update the balance of the same account.**
We:

- Each account has a pthread_mutex_t lock to prevent simultaneous updates.
- When a thread deposits or withdraws:
    - It locks the account’s mutex, updates the balance, then unlocks.
    - This ensures no race conditions even when multiple threads operate on the same account.
- main initializes accounts and mutexes, runs multiple threads for deposits and withdrawals, waits for all threads, prints final balances, and destroys mutexes.
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

### **A printer is shared among multiple users. Each user can either print a document or wait if the printer is in use. There are only 2 printers in the office. Use semaphores to manage the printer access, ensuring that no more than 2 users can print at the same time.**
We:
- There are 2 printers, controlled by a semaphore `printer_sem` initialized to 2.
- Each user (thread) waits on the semaphore (`sem_wait`) before printing.
- When a user starts printing, they hold a printer. Printing is simulated with sleep.
- After finishing, the user releases the printer (`sem_post`).
- This ensures no more than 2 users can print at the same time.
- main creates multiple user threads, waits for them all (pthread_join), then destroys the semaphore.

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

```bash
[wizard@archlinux stuff]$ gcc f.c
[wizard@archlinux stuff]$ ./a.out
User 0 is using a printer...
User 1 is using a printer...
User 0 finished printing.
User 1 finished printing.
User 2 is using a printer...
User 3 is using a printer...
User 3 finished printing.
User 2 finished printing.
User 4 is using a printer...
User 5 is using a printer...
User 4 finished printing.
User 5 finished printing.
User 7 is using a printer...
User 8 is using a printer...
User 8 finished printing.
User 7 finished printing.
User 6 is using a printer...
User 9 is using a printer...
User 6 finished printing.
User 9 finished printing.
[wizard@archlinux stuff]$ ^C
[wizard@archlinux stuff]$
```

