#include "matrix_ops.h"
#include <stdlib.h>
#include <math.h>
#include <omp.h>

Matrix* create_matrix(int rows, int cols) {
    Matrix *m = (Matrix*)malloc(sizeof(Matrix));
    if (!m) return NULL;

    m->rows = rows;
    m->cols = cols;
    m->data = (double*)malloc(rows * cols * sizeof(double));

    if (!m->data) {
        free(m);
        return NULL;
    }

    return m;
}

void free_matrix(Matrix *m) {
    if (m) {
        if (m->data) free(m->data);
        free(m);
    }
}

Matrix* matrix_add(Matrix *A, Matrix *B) {
    if (A->rows != B->rows || A->cols != B->cols) return NULL;
    
    Matrix *result = create_matrix(A->rows, A->cols);
    if (!result) return NULL;
    
    int total = A->rows * A->cols;
    int max_threads = (total < omp_get_max_threads()) ? total : omp_get_max_threads();
    
    #pragma omp parallel for num_threads(max_threads)
    for (int i = 0; i < total; i++) {
        result->data[i] = A->data[i] + B->data[i];
    }
    
    return result;
}

Matrix* matrix_subtract(Matrix *A, Matrix *B) {
    if (A->rows != B->rows || A->cols != B->cols) return NULL;
    
    Matrix *result = create_matrix(A->rows, A->cols);
    if (!result) return NULL;
    
    int total = A->rows * A->cols;
    int max_threads = (total < omp_get_max_threads()) ? total : omp_get_max_threads();
    
    #pragma omp parallel for num_threads(max_threads)
    for (int i = 0; i < total; i++) {
        result->data[i] = A->data[i] - B->data[i];
    }
    
    return result;
}

Matrix* matrix_multiply_elementwise(Matrix *A, Matrix *B) {
    if (A->rows != B->rows || A->cols != B->cols) return NULL;
    
    Matrix *result = create_matrix(A->rows, A->cols);
    if (!result) return NULL;
    
    int total = A->rows * A->cols;
    int max_threads = (total < omp_get_max_threads()) ? total : omp_get_max_threads();
    
    #pragma omp parallel for num_threads(max_threads)
    for (int i = 0; i < total; i++) {
        result->data[i] = A->data[i] * B->data[i];
    }
    
    return result;
}

Matrix* matrix_divide_elementwise(Matrix *A, Matrix *B) {
    if (A->rows != B->rows || A->cols != B->cols) return NULL;
    
    Matrix *result = create_matrix(A->rows, A->cols);
    if (!result) return NULL;
    
    int total = A->rows * A->cols;
    int max_threads = (total < omp_get_max_threads()) ? total : omp_get_max_threads();
    
    #pragma omp parallel for num_threads(max_threads)
    for (int i = 0; i < total; i++) {
        if (B->data[i] == 0.0) {
            result->data[i] = NAN;
        } else {
            result->data[i] = A->data[i] / B->data[i];
        }
    }
    
    return result;
}

Matrix* matrix_transpose(Matrix *A) {
    Matrix *result = create_matrix(A->cols, A->rows);
    if (!result) return NULL;
    
    int max_threads = (A->rows < omp_get_max_threads()) ? A->rows : omp_get_max_threads();
    
    #pragma omp parallel for num_threads(max_threads)
    for (int i = 0; i < A->rows; i++) {
        for (int j = 0; j < A->cols; j++) {
            result->data[j * A->rows + i] = A->data[i * A->cols + j];
        }
    }
    
    return result;
}

Matrix* matrix_multiply(Matrix *A, Matrix *B) {
    if (A->cols != B->rows) return NULL;
    
    Matrix *result = create_matrix(A->rows, B->cols);
    if (!result) return NULL;
    
    int max_threads = (A->rows < omp_get_max_threads()) ? A->rows : omp_get_max_threads();
    
    #pragma omp parallel for num_threads(max_threads)
    for (int i = 0; i < A->rows; i++) {
        for (int j = 0; j < B->cols; j++) {
            double sum = 0.0;
            for (int k = 0; k < A->cols; k++) {
                sum += A->data[i * A->cols + k] * B->data[k * B->cols + j];
            }
            result->data[i * B->cols + j] = sum;
        }
    }
    
    return result;
}
