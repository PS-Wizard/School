#include <stdio.h>
#include <stdlib.h>

#ifndef LOG
#define LOG 0
#endif

struct FileData {
    double sum_x, sum_y;
    double sum_x_squared;
    double sum_xy;
    size_t N_datapoints;
    double A, B;
};

void PopulateStruct(struct FileData* dt, const char* filename); 
void CalculateA(struct FileData* dt);
void CalculateB(struct FileData* dt);
void DisplayStruct(struct FileData* dt); 
void EstimateX(struct FileData* dt);

void PopulateStruct(struct FileData* dt, const char* filename){
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        printf("Error opening file: %s\n", filename);
        return;
    }

    int x, y;    
    if (LOG) {
        printf("| File: %s |\n", filename);
        printf("| DP | X | SUM_X | SUM_X_SQUARED | Y | SUM_Y | X * Y | SUM_XY |\n");
    }

    while (fscanf(file, "%d,%d", &x, &y) == 2) {
        dt->sum_x += x;
        dt->sum_y += y;
        dt->sum_x_squared += (x * x);
        dt->sum_xy += (x * y);
        dt->N_datapoints++;

        if (LOG) {
            printf("| %zu | %d | %lf | %lf | %d | %lf | %lf |\n", dt->N_datapoints, x, dt->sum_x, dt->sum_x_squared, y, dt->sum_y, dt->sum_xy);
        }
    }

    fclose(file);
}

void CalculateA(struct FileData* dt){
    dt->A = ((dt->sum_y * dt->sum_x_squared) - (dt->sum_x * dt->sum_xy)) / ((dt->N_datapoints * dt->sum_x_squared) - (dt->sum_x * dt->sum_x));
}

void CalculateB(struct FileData* dt){
    dt->B = ((dt->Near
                datapoints * dt->sum_xy) - (dt->sum_x * dt->sum_y)) / ((dt->N_datapoints * dt->sum_x_squared) - (dt->sum_x * dt->sum_x));
}

void DisplayStruct(struct FileData* dt){
    printf("Number Of Data Points: %zu\n", dt->N_datapoints);
    printf("Sum x: %lf\n", dt->sum_x);
    printf("Sum y: %lf\n", dt->sum_y);
    printf("Sum (x*x): %lf\n", dt->sum_x_squared);
    printf("Sum (x*y): %lf\n", dt->sum_xy);
    printf("Final Equation: y = %lf*x + %lf\n", dt->B, dt->A);
}

void EstimateX(struct FileData* dt){
    double x;
    printf("Enter an X to estimate for: ");
    scanf("%lf", &x);
    printf("Estimated y = %lf * %lf + %lf\n", dt->B, x, dt->A);
    printf("The Program Estimates: y = %lf\n", (dt->B * x) + dt->A);
}

int main(){
    const char* files[] = {
        "./data/datasetLR1.txt",
        "./data/datasetLR2.txt",
        "./data/datasetLR3.txt",
        "./data/datasetLR4.txt"
    };

    int numFiles = sizeof(files) / sizeof(files[0]);

    struct FileData fd = {0}; 

    for (int i = 0; i < numFiles; i++) {
        PopulateStruct(&fd, files[i]);
    }

    CalculateA(&fd);
    CalculateB(&fd);

    DisplayStruct(&fd);
    EstimateX(&fd);

    return 0;
}
