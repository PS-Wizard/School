#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[]) {
    int rank, received = 0;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    
    if (rank == 0) {
        for (int i = 0; i < 10; i++) {
            printf("Process 0 sent: %d", received);
            MPI_Send(&received, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
            MPI_Recv(&received, 1, MPI_INT, 1, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            printf("; Process 0 received: %d\n", received);
        }
    } else if (rank == 1) {
        for (int i = 0; i < 10; i++) {
            MPI_Recv(&received, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            printf("Process 1 received: %d", received);
            received++;
            MPI_Send(&received, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
            printf("; Process 1 sent: %d\n", received);
        }
    }
    
    MPI_Finalize();
    return 0;
}
