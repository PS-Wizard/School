#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include "matrix_ops.h"
#include "file_ops.h"

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <input_file> <num_threads>\n", argv[0]);
        return 1;
    }
    
    const char *filename = argv[1];
    int num_threads = atoi(argv[2]);
    
    if (num_threads <= 0) {
        fprintf(stderr, "Error: Number of threads must be positive\n");
        return 1;
    }
    
    omp_set_num_threads(num_threads);
    
    MatrixList *list = read_matrices_from_file(filename);
    if (!list) {
        return 1;
    }
    
    if (list->count == 0) {
        fprintf(stderr, "Error: No matrices found in file\n");
        free_matrix_list(list);
        return 1;
    }
    
    int num_pairs = list->count / 2;
    
    for (int i = 0; i < num_pairs; i++) {
        Matrix *A = list->matrices[2 * i];
        Matrix *B = list->matrices[2 * i + 1];
        
        printf("Processing pair %d: Matrix A (%dx%d) and Matrix B (%dx%d)\n",
               i + 1, A->rows, A->cols, B->rows, B->cols);
        
        write_results(A, B, i + 1);
        
        printf("Results written to results_pair%d.txt\n\n", i + 1);
    }
    
    if (list->count % 2 != 0) {
        printf("Warning: Odd number of matrices. Last matrix ignored.\n");
    }
    
    free_matrix_list(list);
    
    printf("All operations completed successfully.\n");
    
    return 0;
}
