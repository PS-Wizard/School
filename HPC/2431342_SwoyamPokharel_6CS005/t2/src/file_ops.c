#include "file_ops.h"
#include "matrix_ops.h"
#include <stdio.h>

int readMatrix(FILE* in, double** matrix, int r, int c, const char* name) {
    int elementsRead = 0;
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            if (fscanf(in, "%lf,", &matrix[i][j]) != 1) {
                fprintf(stderr, "Error: Failed to read element [%d][%d] of matrix %s\n", 
                        i, j, name);
                fprintf(stderr, "Expected %d total elements, only read %d\n", 
                        r * c, elementsRead);
                return 0;
            }
            elementsRead++;
        }
    }
    
    if (elementsRead != r * c) {
        fprintf(stderr, "Error: Matrix %s dimension mismatch. Expected %d elements, read %d\n",
                name, r * c, elementsRead);
        return 0;
    }
    return 1;
}

void performOperations(FILE* out, double** A, double** B, int r1, int c1, int r2, int c2, int threads, int pairNum) {
    fprintf(out, "===============================\n");
    fprintf(out, "MATRIX PAIR %d\n", pairNum);
    fprintf(out, "Matrix A: %d x %d\n", r1, c1);
    fprintf(out, "Matrix B: %d x %d\n", r2, c2);
    fprintf(out, "===============================\n\n");

    // Element-wise operations (require same dimensions)
    if (r1 == r2 && c1 == c2) {
        fprintf(out, "Addition - %d,%d\n", r1, c1);
        double** R = add(A, B, r1, c1, threads);
        if (R) {
            printMatrix(out, R, r1, c1);
            freeMatrix(R, r1);
        } else {
            fprintf(out, "Error: Memory allocation failed\n");
        }

        fprintf(out, "\nSubtraction - %d,%d\n", r1, c1);
        R = sub(A, B, r1, c1, threads);
        if (R) {
            printMatrix(out, R, r1, c1);
            freeMatrix(R, r1);
        } else {
            fprintf(out, "Error: Memory allocation failed\n");
        }

        fprintf(out, "\nElement-wise Multiply - %d,%d\n", r1, c1);
        R = elemMul(A, B, r1, c1, threads);
        if (R) {
            printMatrix(out, R, r1, c1);
            freeMatrix(R, r1);
        } else {
            fprintf(out, "Error: Memory allocation failed\n");
        }

        fprintf(out, "\nElement-wise Divide - %d,%d\n", r1, c1);
        R = elemDiv(A, B, r1, c1, threads);
        if (R) {
            printMatrix(out, R, r1, c1);
            freeMatrix(R, r1);
        } else {
            fprintf(out, "Error: Memory allocation failed\n");
        }
    } else {
        fprintf(out, "Addition cannot be done - different sizes\n");
        fprintf(out, "Subtraction cannot be done - different sizes\n");
        fprintf(out, "Element-wise Multiply cannot be done - different sizes\n");
        fprintf(out, "Element-wise Divide cannot be done - different sizes\n");
    }

    // Transpose operations (always valid)
    fprintf(out, "\nTranspose A - %d,%d\n", c1, r1);
    double** T = transpose(A, r1, c1, threads);
    if (T) {
        printMatrix(out, T, c1, r1);
        freeMatrix(T, c1);
    } else {
        fprintf(out, "Error: Memory allocation failed\n");
    }

    fprintf(out, "\nTranspose B - %d,%d\n", c2, r2);
    T = transpose(B, r2, c2, threads);
    if (T) {
        printMatrix(out, T, c2, r2);
        freeMatrix(T, c2);
    } else {
        fprintf(out, "Error: Memory allocation failed\n");
    }

    // Matrix multiplication (requires c1 == r2)
    if (c1 == r2) {
        fprintf(out, "\nMatrix Multiply A x B - %d,%d\n", r1, c2);
        double** R = matMul(A, B, r1, c1, c2, threads);
        if (R) {
            printMatrix(out, R, r1, c2);
            freeMatrix(R, r1);
        } else {
            fprintf(out, "Error: Memory allocation failed\n");
        }
    } else {
        fprintf(out, "\nMatrix Multiply cannot be done - A columns (%d) != B rows (%d)\n", 
                c1, r2);
    }

    fprintf(out, "\n");
}

int processMatrixPairs(FILE* in, FILE* out, int threads) {
    int pairNum = 0;
    
    while (1) {
        int r1, c1, r2, c2;
        
        // Try to read first matrix dimensions
        int result = fscanf(in, "%d,%d", &r1, &c1);
        if (result == EOF) {
            break; 
        }
        if (result != 2) {
            fprintf(stderr, "Error: Invalid header format for matrix A in pair %d\n", pairNum + 1);
            fprintf(stderr, "Expected format: rows,cols\n");
            break;
        }
        
        if (r1 <= 0 || c1 <= 0) {
            fprintf(stderr, "Error: Invalid dimensions %d,%d for matrix A in pair %d\n", r1, c1, pairNum + 1);
            break;
        }

        double** A = allocMatrix(r1, c1);
        if (!A) {
            fprintf(stderr, "Error: Failed to allocate matrix A (%d x %d) in pair %d\n", r1, c1, pairNum + 1);
            break;
        }

        if (!readMatrix(in, A, r1, c1, "A")) {
            freeMatrix(A, r1);
            break;
        }

        // Try to read second matrix dimensions
        result = fscanf(in, "%d,%d", &r2, &c2);
        if (result != 2) {
            fprintf(stderr, "Error: Invalid header format for matrix B in pair %d\n", pairNum + 1);
            freeMatrix(A, r1);
            break;
        }
        
        if (r2 <= 0 || c2 <= 0) {
            fprintf(stderr, "Error: Invalid dimensions %d,%d for matrix B in pair %d\n",
                    r2, c2, pairNum + 1);
            freeMatrix(A, r1);
            break;
        }

        double** B = allocMatrix(r2, c2);
        if (!B) {
            fprintf(stderr, "Error: Failed to allocate matrix B (%d x %d) in pair %d\n",
                    r2, c2, pairNum + 1);
            freeMatrix(A, r1);
            break;
        }

        if (!readMatrix(in, B, r2, c2, "B")) {
            freeMatrix(A, r1);
            freeMatrix(B, r2);
            break;
        }

        pairNum++;
        performOperations(out, A, B, r1, c1, r2, c2, threads, pairNum);

        freeMatrix(A, r1);
        freeMatrix(B, r2);
    }

    if (pairNum == 0) {
        fprintf(out, "No valid matrix pairs found in input file.\n");
        fprintf(stderr, "Warning: No valid matrix pairs were processed\n");
    } else {
        fprintf(out, "Processed %d matrix pair(s) successfully.\n", pairNum);
    }

    return pairNum;
}
