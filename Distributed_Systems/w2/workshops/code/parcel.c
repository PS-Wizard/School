#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, size, received = 1;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        MPI_Send(&received, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
        MPI_Recv(&received, 1, MPI_INT, size - 1, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("Finalized, and got back: %d\n", received);
    } else {
        MPI_Recv(&received, 1, MPI_INT, rank - 1, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        received++; 

        if (rank < size - 1) {
            MPI_Send(&received, 1, MPI_INT, rank + 1, 0, MPI_COMM_WORLD);
        } else {
            MPI_Send(&received, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
        }
    }

    MPI_Finalize();
    return 0;
}
