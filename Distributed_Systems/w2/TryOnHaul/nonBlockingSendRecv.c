#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    int rank, size, sendValue, recvValue;
    MPI_Request requests[2];
    MPI_Status statuses[2];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // Initialize non-blocking communication
    if (rank == 0) {
        sendValue = 100;
        MPI_Isend(&sendValue, 1, MPI_INT, 1, 0, MPI_COMM_WORLD, &requests[0]);
        printf("Process %d sent value %d to process 1\n", rank, sendValue);
    } else if (rank == 1) {
        MPI_Irecv(&recvValue, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &requests[0]);
        printf("Process %d started receiving from process 0\n", rank);
    }

    // Add some computation or task to do while communication is happening
    if (rank == 1) {
        // Do something else while waiting
        printf("Process %d doing some work before calling MPI_Wait\n", rank);
        MPI_Wait(&requests[0], &statuses[0]);  // Wait for the receive to complete
        printf("Process %d received value %d from process 0\n", rank, recvValue);
    }

    MPI_Finalize();
}
