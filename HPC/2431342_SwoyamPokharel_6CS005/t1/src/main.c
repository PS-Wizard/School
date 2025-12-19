#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include "trie.h"
#include "file_utils.h"

// Thread Data
typedef struct {
    TrieNode* root;        // Shared trie root
    char** words;          // All words from file
    int total_words;       // Total word count
    int thread_id;         // This thread's ID
    int num_threads;       // Total number of threads
} ThreadData;

void* count_words_in_thread(void* arg);

int main(int argc, char* argv[]) {
    //  Parse Command Line Arguments
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <num_threads> <input_file>\n", argv[0]);
        fprintf(stderr, "Example: %s 4 input.txt\n", argv[0]);
        return 1;
    }
    
    int num_threads = atoi(argv[1]);
    char* input_filename = argv[2];
    
    if (num_threads <= 0) {
        fprintf(stderr, "Error: Number of threads must be positive\n");
        return 1;
    }
    
    printf("  Multithreaded Word Counter (Trie)\n");
    printf("-----------\n");
    printf("Threads: %d\n", num_threads);
    printf("Input File: %s\n", input_filename);
    printf("Output File: result.txt\n");
    
    print_progress("Reading words from file...");
    int total_words;
    char** words = read_words_from_file(input_filename, &total_words);
    printf("Read %d words\n\n", total_words);
    
    print_progress("Creating shared trie structure...");
    TrieNode* root = create_trie_node();
    printf("Trie root created\n\n");
    
    print_progress("Setting up threads...");
    pthread_t* threads = malloc(num_threads * sizeof(pthread_t));
    ThreadData* thread_data = malloc(num_threads * sizeof(ThreadData));
    
    if (!threads || !thread_data) {
        fprintf(stderr, "Error: Memory allocation failed\n");
        return 1;
    }
    
    for (int i = 0; i < num_threads; i++) {
        thread_data[i].root = root;
        thread_data[i].words = words;
        thread_data[i].total_words = total_words;
        thread_data[i].thread_id = i;
        thread_data[i].num_threads = num_threads;
    }
    printf("Created %d thread data structures\n\n", num_threads);
    
    print_progress("Launching threads for word counting...");
    for (int i = 0; i < num_threads; i++) {
        pthread_create(&threads[i], NULL, count_words_in_thread, &thread_data[i]);
    }
    printf("All threads launched\n\n");
    
    print_progress("Waiting for threads to finish...");
    for (int i = 0; i < num_threads; i++) {
        pthread_join(threads[i], NULL);
    }
    printf("All threads completed\n\n");
    
    print_progress("Writing results to result.txt...");
    FILE* output = fopen("result.txt", "w");
    if (!output) {
        fprintf(stderr, "Error: Cannot open output file\n");
        return 1;
    }
    
    char prefix[MAX_WORD_LENGTH];
    write_trie_to_file(root, prefix, 0, output);
    fclose(output);
    
    destroy_trie(root);
    for (int i = 0; i < total_words; i++) {
        free(words[i]);
    }

    free(words);
    free(threads);
    free(thread_data);
    
    printf("results written to ./result.txt\n");
    
    return 0;
}

void* count_words_in_thread(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    
    int words_processed = 0;
    
    // Round-robin distribution
    // Thread 0: words 0, 4, 8, 12, ...
    // Thread 1: words 1, 5, 9, 13, ...
    for (int i = data->thread_id; i < data->total_words; i += data->num_threads) {
        insert_word_into_trie(data->root, data->words[i]);
        words_processed++;
    }
    
    printf("  Thread %d: Processed %d words\n", 
           data->thread_id, words_processed);
    
    return NULL;
}
