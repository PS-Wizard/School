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
