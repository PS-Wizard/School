#ifndef MATRIX_OPS_H
#define MATRIX_OPS_H

typedef struct {
    double *data;
    int rows;
    int cols;
} Matrix;

Matrix* create_matrix(int rows, int cols);
void free_matrix(Matrix *m);

Matrix* matrix_add(Matrix *A, Matrix *B);
Matrix* matrix_subtract(Matrix *A, Matrix *B);
Matrix* matrix_multiply_elementwise(Matrix *A, Matrix *B);
Matrix* matrix_divide_elementwise(Matrix *A, Matrix *B);
Matrix* matrix_transpose(Matrix *A);
Matrix* matrix_multiply(Matrix *A, Matrix *B);

#endif
