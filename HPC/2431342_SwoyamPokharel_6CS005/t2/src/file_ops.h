#ifndef FILE_OPS_H
#define FILE_OPS_H

#include <stdio.h>

// Read a single matrix from file
int readMatrix(FILE* in, double** matrix, int r, int c, const char* name);

// Process all matrix pairs from input file and write results to output file
int processMatrixPairs(FILE* in, FILE* out, int threads);

// Perform and write all operations for a single matrix pair
void performOperations(FILE* out, double** A, double** B, 
                       int r1, int c1, int r2, int c2, 
                       int threads, int pairNum);

#endif
