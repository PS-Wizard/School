#include <stdio.h>
#include <mpi.h>

#define NUMDATA 10000


int main(int argc, char *argv[]) {
    int rank, size;
    int local_sum = 0, global_sum = 0;
    int local_data[NUMDATA];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int chunk_size = NUMDATA / size;
    for (int i = 0; i < chunk_size; i++) {
        local_data[i] = 1;
    }
    
    for (int i = 0; i < chunk_size; i++) {
        local_sum += local_data[i];
    }

    MPI_Reduce(&local_sum, &global_sum, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("The total sum of data is %d\n", global_sum);
    }

    MPI_Finalize();
    return 0;
}
