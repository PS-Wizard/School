#include "file_utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char** read_words_from_file(const char* filename, int* word_count) {
    FILE* fp = fopen(filename, "r");
    if (!fp) {
        fprintf(stderr, "Error: Cannot open file '%s'\n", filename);
        exit(1);
    }
    
    // Dynamic array
    int capacity = 1000;
    int count = 0;
    char** words = malloc(capacity * sizeof(char*));
    if (!words) {
        fprintf(stderr, "Error: Memory allocation failed\n");
        exit(1);
    }
    
    char buffer[MAX_WORD_LENGTH];
    
    // Read line by line
    while (fgets(buffer, sizeof(buffer), fp)) {
        // Remove newline
        buffer[strcspn(buffer, "\n\r")] = '\0';
        
        // Skip empty lines
        if (strlen(buffer) == 0) {
            continue;
        }
        
        // Expand if needed
        if (count >= capacity) {
            capacity *= 2;
            char** temp = realloc(words, capacity * sizeof(char*));
            if (!temp) {
                fprintf(stderr, "Error: Memory reallocation failed\n");
                free(words);
                exit(1);
            }
            words = temp;
        }
        
        words[count] = strdup(buffer);
        if (!words[count]) {
            fprintf(stderr, "Error: Memory allocation failed for word\n");
            exit(1);
        }
        count++;
    }
    
    fclose(fp);
    *word_count = count;
    return words;
}

void print_progress(const char* message) {
    printf("===================\n");
    printf("%s\n", message);
    printf("===================\n");
}
