#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <omp.h>

double** allocMatrix(int r, int c) {
    double** m = malloc(r * sizeof(double*));
    for (int i = 0; i < r; i++)
        m[i] = malloc(c * sizeof(double));
    return m;
}

void freeMatrix(double** m, int r) {
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

double** transpose(double** A, int r, int c, int threads) {
    double** T = allocMatrix(c, r);

    #pragma omp parallel for num_threads(threads)
    for (int i = 0; i < r; i++)
        for (int j = 0; j < c; j++)
            T[j][i] = A[i][j];

    return T;
}

double** add(double** A, double** B, int r, int c, int threads) {
    double** R = allocMatrix(r, c);

    #pragma omp parallel for num_threads(threads)
    for (int i = 0; i < r; i++)
        for (int j = 0; j < c; j++)
            R[i][j] = A[i][j] + B[i][j];

    return R;
}

double** sub(double** A, double** B, int r, int c, int threads) {
    double** R = allocMatrix(r, c);

    #pragma omp parallel for num_threads(threads)
    for (int i = 0; i < r; i++)
        for (int j = 0; j < c; j++)
            R[i][j] = A[i][j] - B[i][j];

    return R;
}

double** elemMul(double** A, double** B, int r, int c, int threads) {
    double** R = allocMatrix(r, c);

    #pragma omp parallel for num_threads(threads)
    for (int i = 0; i < r; i++)
        for (int j = 0; j < c; j++)
            R[i][j] = A[i][j] * B[i][j];

    return R;
}

double** elemDiv(double** A, double** B, int r, int c, int threads) {
    double** R = allocMatrix(r, c);

    #pragma omp parallel for num_threads(threads)
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

    #pragma omp parallel for num_threads(threads)
    for (int i = 0; i < rA; i++)
        for (int j = 0; j < cB; j++) {
            double sum = 0;
            for (int k = 0; k < cA; k++)
                sum += A[i][k] * B[k][j];
            R[i][j] = sum;
        }

    return R;
}

int main(int argc, char* argv[]) {
    if (argc < 3) {
        printf("Usage: ./matrix <file> <threads>\n");
        return 1;
    }

    FILE* in = fopen(argv[1], "r");
    if (!in) {
        printf("Cannot open input file.\n");
        return 1;
    }

    int threads = atoi(argv[2]);
    FILE* out = fopen("results.txt", "w");

    while (1) {
        int r1, c1, r2, c2;

        if (fscanf(in, "%d,%d", &r1, &c1) != 2) break;
        double** A = allocMatrix(r1, c1);

        for (int i = 0; i < r1; i++)
            for (int j = 0; j < c1; j++)
                fscanf(in, "%lf,", &A[i][j]);

        if (fscanf(in, "%d,%d", &r2, &c2) != 2) break;
        double** B = allocMatrix(r2, c2);

        for (int i = 0; i < r2; i++)
            for (int j = 0; j < c2; j++)
                fscanf(in, "%lf,", &B[i][j]);

        fprintf(out, "\n===============================\n");
        fprintf(out, "NEW MATRIX PAIR\n");
        fprintf(out, "===============================\n\n");

        if (r1 == r2 && c1 == c2) {
            fprintf(out, "Addition (%d x %d)\n", r1, c1);
            double** R = add(A, B, r1, c1, threads);
            printMatrix(out, R, r1, c1);
            freeMatrix(R, r1);

            fprintf(out, "\nSubtraction (%d x %d)\n", r1, c1);
            R = sub(A, B, r1, c1, threads);
            printMatrix(out, R, r1, c1);
            freeMatrix(R, r1);

            fprintf(out, "\nElement-wise Multiply (%d x %d)\n", r1, c1);
            R = elemMul(A, B, r1, c1, threads);
            printMatrix(out, R, r1, c1);
            freeMatrix(R, r1);

            fprintf(out, "\nElement-wise Divide (%d x %d)\n", r1, c1);
            R = elemDiv(A, B, r1, c1, threads);
            printMatrix(out, R, r1, c1);
            freeMatrix(R, r1);
        } else {
            fprintf(out, "Addition not possible (different sizes)\n");
            fprintf(out, "Subtraction not possible (different sizes)\n");
            fprintf(out, "Element-wise operations not possible (different sizes)\n");
        }

        fprintf(out, "\nTranspose A (%d x %d)\n", c1, r1);
        double** T = transpose(A, r1, c1, threads);
        printMatrix(out, T, c1, r1);
        freeMatrix(T, c1);

        fprintf(out, "\nTranspose B (%d x %d)\n", c2, r2);
        T = transpose(B, r2, c2, threads);
        printMatrix(out, T, c2, r2);
        freeMatrix(T, c2);

        if (c1 == r2) {
            fprintf(out, "\nMatrix Multiply A x B (%d x %d)\n", r1, c2);
            double** R = matMul(A, B, r1, c1, c2, threads);
            printMatrix(out, R, r1, c2);
            freeMatrix(R, r1);
        } else {
            fprintf(out, "\nMatrix Multiply not possible (Acols != Brows)\n");
        }

        freeMatrix(A, r1);
        freeMatrix(B, r2);
    }

    fclose(in);
    fclose(out);
    return 0;
}

