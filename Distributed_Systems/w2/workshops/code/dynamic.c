#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char **argv) {
    int size, rank, tag = 0, count;
    MPI_Status status;

    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    srand(time(NULL) + rank);
    if (rank == 0) {
        for (int i = 0; i < size - 1; i++) {

            // Probe allows to see who sent; without actually like receiving it while still allowing the status
            MPI_Probe(MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
            MPI_Get_count(&status, MPI_INT, &count);

            int *data = (int *)malloc(count * sizeof(int));
            MPI_Recv(data, count, MPI_INT, status.MPI_SOURCE, status.MPI_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            printf("Node ID: %d; tag: %d; Received count: %d\n", status.MPI_SOURCE, status.MPI_TAG, count);

            free(data); 
        }
    } else {
        count = rand() % 100; 
        int *data = (int *)malloc(count * sizeof(int));
        MPI_Send(data, count, MPI_INT, 0, tag, MPI_COMM_WORLD);
        free(data);
    }

    MPI_Finalize();
    return 0;
}
