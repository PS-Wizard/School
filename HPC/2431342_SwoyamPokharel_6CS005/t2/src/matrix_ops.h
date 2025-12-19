#ifndef MATRIX_OPS_H
#define MATRIX_OPS_H

#include <stdio.h>

// Memory management
double** allocMatrix(int r, int c);
void freeMatrix(double** m, int r);

// Utility
void printMatrix(FILE* f, double** M, int r, int c);
int capThreads(int requested, int row);

// Matrix operations
double** transpose(double** A, int r, int c, int threads);
double** add(double** A, double** B, int r, int c, int threads);
double** sub(double** A, double** B, int r, int c, int threads);
double** elemMul(double** A, double** B, int r, int c, int threads);
double** elemDiv(double** A, double** B, int r, int c, int threads);
double** matMul(double** A, double** B, int rA, int cA, int cB, int threads);

#endif
