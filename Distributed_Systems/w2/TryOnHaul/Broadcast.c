#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    int rank, size, someValue, toSend, count;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Status status;

    if (rank == 0) {
        toSend = 69;
        MPI_Bcast(&toSend, 1, MPI_INT, 0, MPI_COMM_WORLD);  // Broadcast from process 0
    } else {
        MPI_Bcast(&someValue, 1, MPI_INT, 0, MPI_COMM_WORLD);  // Receive the broadcast
        printf("Process %d Received From 0, Value: %d\n", rank, someValue);
        /*MPI_Get_count(&status, MPI_INT, &count);*/
        /*printf("Data Count: %d\n", count);*/
    }

    MPI_Finalize();
}
