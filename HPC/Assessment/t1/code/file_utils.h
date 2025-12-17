#ifndef FILE_UTILS_H
#define FILE_UTILS_H

#define MAX_WORD_LENGTH 256

// Reads all words from file into a dynamic array
// Returns array of strings, sets word_count to number of words read
char** read_words_from_file(const char* filename, int* word_count);

// Prints a formatted progress message
void print_progress(const char* message);

#endif // FILE_UTILS_H
