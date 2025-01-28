#include <stdio.h>
#include <pthread.h>

#define MAX_BUFFER_SIZE 1024
#define MAX_OUTPUT_SIZE 10000  // adjust as needed

// Structure to pass file data to threads
typedef struct {
    const char *filename;
    int count;
    char output[MAX_OUTPUT_SIZE];
} FileData;

void *countLines(void *arg) {
    FileData *fileData = (FileData *)arg;
    FILE *file = fopen(fileData->filename, "r");
    if (!file) {
        perror("Unable to open file");
        fileData->count = -1;
        return NULL;
    }

    char buffer[MAX_BUFFER_SIZE];
    fileData->count = 0;
    int offset = 0;  // track where to add new content to the buffer

    while (fgets(buffer, sizeof(buffer), file)) {
        fileData->count++;
        int len = snprintf(fileData->output + offset, MAX_OUTPUT_SIZE - offset, "%s", buffer);
        if (len >= 0 && len < (MAX_OUTPUT_SIZE - offset)) {
            offset += len;
        } else {
            // Handle overflow if the buffer size is exceeded
            printf("Warning: Output buffer size exceeded\n");
            break;
        }
    }

    fclose(file);
    return NULL;
}

int main() {
    pthread_t threads[3];
    FileData fileData[3];

    // Define file paths
    fileData[0].filename = "./task_3_files/PrimeData1.txt";
    fileData[1].filename = "./task_3_files/PrimeData2.txt";
    fileData[2].filename = "./task_3_files/PrimeData3.txt";

    // Create threads
    for (int i = 0; i < 3; i++) {
        if (pthread_create(&threads[i], NULL, countLines, &fileData[i])) {
            perror("Error creating thread");
            return 1;
        }
    }

    // Wait for threads to finish and print the output
    for (int i = 0; i < 3; i++) {
        if (pthread_join(threads[i], NULL)) {
            perror("Error joining thread");
            return 1;
        }
        // After thread finishes, print the entire buffered output
        printf("Contents of %s:\n%s\n", fileData[i].filename, fileData[i].output);
    }

    return 0;
}
