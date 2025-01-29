#include <stdio.h>
#include <stdlib.h>

// Enable Logging:
#ifndef LOG
#define LOG 0
#endif

struct FileData {
    char   FileName[256];
    double sum_x,sum_y;
    double sum_x_squared;
    double sum_xy;
    size_t N_datapoints;
    double A,B;
};

// prototypes
void PopulateStruct(struct FileData* dt); 
void CalculateA(struct FileData* dt);
void CalculateB(struct FileData* dt);
void DisplayStruct(struct FileData* dt); 
void EstimateX(struct FileData* dt);
struct FileData* getUserIn(); 

struct FileData* getUserIn(){
    struct FileData* fd = calloc(1,sizeof(struct FileData));
    printf("Enter the name of the file: ");
    scanf("%255s",fd->FileName);
    return fd;
}

void PopulateStruct(struct FileData* dt){
    FILE* file = fopen(dt->FileName,"r");
    if (file == NULL) {
        printf("Error Opening the file\n");
        exit(1);
    }
    int x,y;    
    if(LOG){
        printf("| DP | X | SUM_X | SUM_X_SQUARED | Y | SUM_Y | X * Y | SUM_XY |\n");
        while((fscanf(file,"%d,%d",&x,&y) == 2)){
            dt->sum_x += (double)x;
            dt->sum_y += (double)y;
            dt->sum_x_squared += (double)(x*x);
            dt->sum_xy += (double)(x*y);
            dt->N_datapoints++;
            printf("| %zu | %lf | %lf | %d | %lf | %d | %lf |\n",dt->N_datapoints, x, dt->sum_x, dt->sum_x_squared, y, dt->sum_y, x*y,dt->sum_xy);
        }
    }else{
        while((fscanf(file,"%d,%d",&x,&y) == 2)){
            dt->sum_x += (double)x;
            dt->sum_y += (double)y;
            dt->sum_x_squared += (double)(x*x);
            dt->sum_xy += (double)(x*y);
            dt->N_datapoints++;
        }
    }
}


void CalculateA(struct FileData* dt){
    dt->A = ((dt->sum_y)*(dt->sum_x_squared) - (dt->sum_x)*(dt->sum_xy)) / ((dt->N_datapoints * dt->sum_x_squared) - (dt->sum_x * dt->sum_x));
}

void CalculateB(struct FileData* dt){
    dt->B = ((dt->N_datapoints * dt->sum_xy) - (dt->sum_x * dt->sum_y)) / ((dt->N_datapoints * dt->sum_x_squared) - (dt->sum_x * dt->sum_x));
}

void DisplayStruct(struct FileData* dt){
    printf("FileName: %s\n",dt->FileName);
    printf("Number Of Data Points: %d\n",dt->N_datapoints);
    printf("Sum x: %lf\n",dt->sum_x);
    printf("Sum y: %lf\n",dt->sum_y);
    printf("Sum (x*x): %lf\n",dt->sum_x_squared);
    printf("Sum (x*y): %lf\n",dt->sum_xy);
    printf("y = %lf*x + %lf\n",dt->B, dt->A);
}

void EstimateX(struct FileData* dt){
    double x;
    printf("Enter an X to estimate for: \n");
    scanf("%lf",&x);
    printf("y = %lf * %lf + %lf\n",dt->B, x, dt->A);
    printf("The Program Estimates: y = %lf\n", ((dt->B * x) + dt->A));
}

int main(){
    /*
     * TODO:
     * [x] Read Into Struct
     * [x] Estimate x
     * [x] Enable Logging Via A Compiler Flag
     * [x] Allow Multiple Runs
     * */
    int goAgain = 0;
    while (1) {
        struct FileData* fd = getUserIn();
        PopulateStruct(fd);
        CalculateA(fd);
        CalculateB(fd);
        DisplayStruct(fd);
        EstimateX(fd);
        free(fd);
        printf("Go again? (0/1): ") ;
        scanf("%d",&goAgain);
        if (goAgain) {
            continue;
        }
        break;
    }
}
