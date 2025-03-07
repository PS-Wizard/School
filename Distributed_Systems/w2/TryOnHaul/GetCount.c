#include <mpi.h>
#include <stdio.h>
int main(int argc, char** argv ){
    int rank,size,someValue, toSend, count;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    MPI_Status status;
    if (rank == 0) {
        toSend = rank * 10 + 1;
        for (int i = 1; i < size; i++) {
            MPI_Send(&toSend, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
        }
    }else{
        MPI_Recv(&someValue,1,MPI_INT,MPI_ANY_SOURCE,MPI_ANY_TAG,MPI_COMM_WORLD,&status);
        MPI_Get_count(&status, MPI_INT, &count);
        printf("Process %d Received From %d, Value: %d, Error: %d, Tag: %d\n", rank, status.MPI_SOURCE, someValue, status.MPI_ERROR, status.MPI_TAG);
        printf("Data Count: %d\n",count);

    }
     
    MPI_Finalize();
}
