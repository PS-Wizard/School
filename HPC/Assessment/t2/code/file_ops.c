#include "file_ops.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

MatrixList* read_matrices_from_file(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (!file) {
        fprintf(stderr, "Error: Cannot open file '%s'\n", filename);
        return NULL;
    }
    
    MatrixList *list = (MatrixList*)malloc(sizeof(MatrixList));
    if (!list) {
        fclose(file);
        return NULL;
    }
    
    list->matrices = NULL;
    list->count = 0;
    
    int capacity = 10;
    list->matrices = (Matrix**)malloc(capacity * sizeof(Matrix*));
    if (!list->matrices) {
        free(list);
        fclose(file);
        return NULL;
    }
    
    char line[4096];
    while (fgets(line, sizeof(line), file)) {
        // Remove newline
        line[strcspn(line, "\n\r")] = '\0';
        
        // Skip empty lines
        if (strlen(line) == 0) {
            continue;
        }
        
        // Read header: rows,cols
        int rows, cols;
        if (sscanf(line, "%d,%d", &rows, &cols) != 2) {
            fprintf(stderr, "Error: Invalid matrix header '%s'\n", line);
            free_matrix_list(list);
            fclose(file);
            return NULL;
        }
        
        if (rows <= 0 || cols <= 0) {
            fprintf(stderr, "Error: Invalid matrix dimensions %dx%d\n", rows, cols);
            free_matrix_list(list);
            fclose(file);
            return NULL;
        }
        
        Matrix *m = create_matrix(rows, cols);
        if (!m) {
            fprintf(stderr, "Error: Memory allocation failed\n");
            free_matrix_list(list);
            fclose(file);
            return NULL;
        }
        
        // Read data rows
        int values_read = 0;
        for (int row = 0; row < rows; row++) {
            if (!fgets(line, sizeof(line), file)) {
                fprintf(stderr, "Error: Unexpected end of file (expected %d rows)\n", rows);
                free_matrix(m);
                free_matrix_list(list);
                fclose(file);
                return NULL;
            }
            
            // Parse comma-separated values
            char *ptr = line;
            for (int col = 0; col < cols; col++) {
                double val;
                int consumed;
                if (sscanf(ptr, "%lf%n", &val, &consumed) != 1) {
                    fprintf(stderr, "Error: Invalid value at row %d, col %d\n", row, col);
                    free_matrix(m);
                    free_matrix_list(list);
                    fclose(file);
                    return NULL;
                }
                m->data[row * cols + col] = val;
                ptr += consumed;
                
                // Skip comma
                if (col < cols - 1) {
                    while (*ptr == ',' || *ptr == ' ') ptr++;
                }
                values_read++;
            }
        }
        
        if (values_read != rows * cols) {
            fprintf(stderr, "Error: Expected %d values, got %d\n", rows * cols, values_read);
            free_matrix(m);
            free_matrix_list(list);
            fclose(file);
            return NULL;
        }
        
        if (list->count >= capacity) {
            capacity *= 2;
            Matrix **new_matrices = (Matrix**)realloc(list->matrices, capacity * sizeof(Matrix*));
            if (!new_matrices) {
                free_matrix(m);
                free_matrix_list(list);
                fclose(file);
                return NULL;
            }
            list->matrices = new_matrices;
        }
        
        list->matrices[list->count++] = m;
    }
    
    fclose(file);
    return list;
}

void free_matrix_list(MatrixList *list) {
    if (list) {
        if (list->matrices) {
            for (int i = 0; i < list->count; i++) {
                free_matrix(list->matrices[i]);
            }
            free(list->matrices);
        }
        free(list);
    }
}

void write_matrix(FILE *file, const char *op_name, Matrix *m) {
    if (!m) return;
    
    fprintf(file, "%s - %d,%d\n", op_name, m->rows, m->cols);
    for (int i = 0; i < m->rows; i++) {
        for (int j = 0; j < m->cols; j++) {
            double val = m->data[i * m->cols + j];
            if (isnan(val)) {
                fprintf(file, "NaN");
            } else {
                fprintf(file, "%.6f", val);
            }
            if (j < m->cols - 1) fprintf(file, ",");
        }
        fprintf(file, "\n");
    }
    fprintf(file, "\n");
}

void write_results(Matrix *A, Matrix *B, int pair_num) {
    char filename[100];
    sprintf(filename, "outputs/results_pair%d.txt", pair_num);
    
    FILE *file = fopen(filename, "w");
    if (!file) {
        fprintf(stderr, "Error: Cannot create results file '%s'\n", filename);
        return;
    }
    
    fprintf(file, "=== Pair %d Results ===\n\n", pair_num);
    
    // Addition
    Matrix *result = matrix_add(A, B);
    if (result) {
        write_matrix(file, "Addition", result);
        free_matrix(result);
    } else {
        fprintf(file, "Addition cannot be done (shapes differ).\n\n");
    }
    
    // Subtraction
    result = matrix_subtract(A, B);
    if (result) {
        write_matrix(file, "Subtraction", result);
        free_matrix(result);
    } else {
        fprintf(file, "Subtraction cannot be done (shapes differ).\n\n");
    }
    
    // Element-wise multiplication
    result = matrix_multiply_elementwise(A, B);
    if (result) {
        write_matrix(file, "Element-wise Multiplication", result);
        free_matrix(result);
    } else {
        fprintf(file, "Element-wise Multiplication cannot be done (shapes differ).\n\n");
    }
    
    // Element-wise division
    result = matrix_divide_elementwise(A, B);
    if (result) {
        write_matrix(file, "Element-wise Division", result);
        free_matrix(result);
    } else {
        fprintf(file, "Element-wise Division cannot be done (shapes differ).\n\n");
    }
    
    // Transpose A
    result = matrix_transpose(A);
    if (result) {
        write_matrix(file, "Transpose A", result);
        free_matrix(result);
    }
    
    // Transpose B
    result = matrix_transpose(B);
    if (result) {
        write_matrix(file, "Transpose B", result);
        free_matrix(result);
    }
    
    // Matrix multiplication
    result = matrix_multiply(A, B);
    if (result) {
        write_matrix(file, "Matrix Multiplication", result);
        free_matrix(result);
    } else {
        fprintf(file, "Matrix Multiplication cannot be done (incompatible dimensions).\n\n");
    }
    
    fclose(file);
}
