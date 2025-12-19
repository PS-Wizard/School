#include "matrix_ops.h"
#include <stdlib.h>
#include <omp.h>

double** allocMatrix(int r, int c) {
    if (r <= 0 || c <= 0) {
        fprintf(stderr, "Error: Invalid matrix dimensions %d x %d\n", r, c);
        return NULL;
    }
    
    double** m = malloc(r * sizeof(double*));
    if (!m) {
        fprintf(stderr, "Error: Memory allocation failed for matrix rows\n");
        return NULL;
    }
    
    for (int i = 0; i < r; i++) {
        m[i] = malloc(c * sizeof(double));
        if (!m[i]) {
            fprintf(stderr, "Error: Memory allocation failed for matrix row %d\n", i);
            for (int j = 0; j < i; j++) 
                free(m[j]);
            free(m);
            return NULL;
        }
    }
    return m;
}

void freeMatrix(double** m, int r) {
    if (!m) return;
    for (int i = 0; i < r; i++) 
        free(m[i]);
    free(m);
}

void printMatrix(FILE* f, double** M, int r, int c) {
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            fprintf(f, "%lf", M[i][j]);
            if (j < c - 1) fprintf(f, ", ");
        }
        fprintf(f, "\n");
    }
}

int capThreads(int requested, int row) {
    if (requested > row) return row;
    return requested;
}

double** transpose(double** A, int r, int c, int threads) {
    double** T = allocMatrix(c, r);
    if (!T) return NULL;
    
    int actualThreads = capThreads(threads, r);
    #pragma omp parallel for num_threads(actualThreads)
    for (int i = 0; i < r; i++)
        for (int j = 0; j < c; j++)
            T[j][i] = A[i][j];
    
    return T;
}

double** add(double** A, double** B, int r, int c, int threads) {
    double** R = allocMatrix(r, c);
    if (!R) return NULL;
    
    int actualThreads = capThreads(threads, r);
    #pragma omp parallel for num_threads(actualThreads)
    for (int i = 0; i < r; i++)
        for (int j = 0; j < c; j++)
            R[i][j] = A[i][j] + B[i][j];
    
    return R;
}

double** sub(double** A, double** B, int r, int c, int threads) {
    double** R = allocMatrix(r, c);
    if (!R) return NULL;
    
    int actualThreads = capThreads(threads, r);
    #pragma omp parallel for num_threads(actualThreads)
    for (int i = 0; i < r; i++)
        for (int j = 0; j < c; j++)
            R[i][j] = A[i][j] - B[i][j];
    
    return R;
}

double** elemMul(double** A, double** B, int r, int c, int threads) {
    double** R = allocMatrix(r, c);
    if (!R) return NULL;
    
    int actualThreads = capThreads(threads, r);
    #pragma omp parallel for num_threads(actualThreads)
    for (int i = 0; i < r; i++)
        for (int j = 0; j < c; j++)
            R[i][j] = A[i][j] * B[i][j];
    
    return R;
}

double** elemDiv(double** A, double** B, int r, int c, int threads) {
    double** R = allocMatrix(r, c);
    if (!R) return NULL;
    
    int actualThreads = capThreads(threads, r);
    #pragma omp parallel for num_threads(actualThreads)
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            if (B[i][j] == 0)
                R[i][j] = 0.0 / 0.0; // NaN
            else
                R[i][j] = A[i][j] / B[i][j];
        }
    }
    return R;
}

double** matMul(double** A, double** B, int rA, int cA, int cB, int threads) {
    double** R = allocMatrix(rA, cB);
    if (!R) return NULL;
    
    int actualThreads = capThreads(threads, rA);
    #pragma omp parallel for num_threads(actualThreads)
    for (int i = 0; i < rA; i++)
        for (int j = 0; j < cB; j++) {
            double sum = 0;
            for (int k = 0; k < cA; k++)
                sum += A[i][k] * B[k][j];
            R[i][j] = sum;
        }
    
    return R;
}
