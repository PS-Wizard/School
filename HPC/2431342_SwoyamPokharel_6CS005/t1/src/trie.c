#include "trie.h"
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>

TrieNode* create_trie_node() {
    // Initialize all children to NULL (calloc does this)
    TrieNode* node = calloc(1, sizeof(TrieNode));
    if (!node) {
        fprintf(stderr, "Error: Memory allocation failed\n");
        exit(1);
    }

    pthread_mutex_init(&node->lock, NULL);
    return node;
}

void insert_word_into_trie(TrieNode* root, const char* word) {
    TrieNode* current = root;
    
    // Walk through each letter of the word
    for (int i = 0; word[i] != '\0'; i++) {
        char c = tolower(word[i]);
        
        // Skip non-alphabetic characters
        if (c < 'a' || c > 'z') {
            continue;
        }
        
        int index = c - 'a';  // Convert 'a'-'z' to 0-25
        
        // If child doesn't exist, create it
        if (current->children[index] == NULL) {
            // Need to lock here to prevent race condition
            // Multiple threads might try to create the same child
            pthread_mutex_lock(&current->lock);
            
            // Double-check (another thread might have created it)
            if (current->children[index] == NULL) {
                current->children[index] = create_trie_node();
            }
            
            pthread_mutex_unlock(&current->lock);
        }
        
        // Move to child node
        current = current->children[index];
    }
    
    // End of word - increment count (lock only this final node)
    pthread_mutex_lock(&current->lock);
    current->count++;
    pthread_mutex_unlock(&current->lock);
}

void write_trie_to_file(TrieNode* node, char* prefix, int depth, FILE* fp) {
    // If this node marks end of a word, write it
    if (node->count > 0) {
        prefix[depth] = '\0';  // Null-terminate the string
        fprintf(fp, "%s: %d\n", prefix, node->count);
    }
    
    // Recursively traverse all children (in alphabetical order a-z)
    for (int i = 0; i < ALPHABET_SIZE; i++) {
        if (node->children[i] != NULL) {
            prefix[depth] = 'a' + i;  // Add current letter to prefix
            write_trie_to_file(node->children[i], prefix, depth + 1, fp);
        }
    }
}

void destroy_trie(TrieNode* node) {
    if (node == NULL) {
        return;
    }
    
    // Recursively destroy all children
    for (int i = 0; i < ALPHABET_SIZE; i++) {
        if (node->children[i] != NULL) {
            destroy_trie(node->children[i]);
        }
    }
    
    // Destroy mutex and free node
    pthread_mutex_destroy(&node->lock);
    free(node);
}
