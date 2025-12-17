#ifndef TRIE_H
#define TRIE_H

#include <pthread.h>
#include <stdio.h>

#define ALPHABET_SIZE 26

// Each node represents a letter in the alphabet
typedef struct TrieNode {
    struct TrieNode* children[ALPHABET_SIZE];   // a-z children
    int count;                                  // Word count (0 if not a word)
    pthread_mutex_t lock;                       // Lock for this specific node
} TrieNode;

// Creates a new trie node with initialized values
TrieNode* create_trie_node();

// Inserts a word into the trie (thread-safe)
void insert_word_into_trie(TrieNode* root, const char* word);

// Writes all words in trie to file (alphabetically sorted)
void write_trie_to_file(TrieNode* node, char* prefix, int depth, FILE* fp);

// Frees all memory used by the trie
void destroy_trie(TrieNode* node);

#endif
