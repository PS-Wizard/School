/*
   - Process 0 sends x to process 1 and y to processes 2. "1, MPI_INT" 
   indicates that the message consists of one integer.
   - Processes other than rank 0 wait to receive a message using MPI_Recv. 
   The "0, 0" indicates that the message is expected from process 0 and 
   should have the tag 0. The result is stored in the number variable. 
   */

#include <stdio.h>
#include <mpi.h>

int main(int argc, char** argv) {
    int size, rank;

    MPI_Init(NULL, NULL);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    if(rank ==0){
        int x = 9;
        int y = 17;
        for (int i = 1; i < size; i++) {
            if (i % 2 != 0){
                MPI_Send(&x, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
            }else{
                MPI_Send(&y, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
            }
        }
    } else {
        int number;
        MPI_Recv(&number, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("Process %d received %d\n", rank, number); 
    }
    MPI_Finalize(); 

    return 0;
}
