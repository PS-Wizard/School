#ifndef FILE_OPS_H
#define FILE_OPS_H

#include "matrix_ops.h"

typedef struct {
    Matrix **matrices;
    int count;
} MatrixList;

MatrixList* read_matrices_from_file(const char *filename);
void free_matrix_list(MatrixList *list);
void write_results(Matrix *A, Matrix *B, int pair_num);

#endif
