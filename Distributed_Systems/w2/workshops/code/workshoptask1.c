#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <ctype.h>

void count_letters_in_chunk(char *chunk, int chunk_size, int *local_counts) {
    for (int i = 0; i < chunk_size; i++) {
        char c = tolower(chunk[i]);
        if (c >= 'a' && c <= 'z') {
            local_counts[c - 'a']++;
        }
    }
}

int main(int argc, char *argv[]) {
    int rank, size;
    char *filename = "../WarAndPeace.txt";  

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int global_counts[26] = {0};
    int local_counts[26] = {0};

    if (rank == 0) {
        FILE *file = fopen(filename, "r");
        if (!file) {
            printf("Failed to open file %s\n", filename);
            MPI_Abort(MPI_COMM_WORLD, 1);
        }

        fseek(file, 0, SEEK_END);
        long file_size = ftell(file);
        fseek(file, 0, SEEK_SET);

        long chunk_size = file_size / size;
        long remaining = file_size % size;

        char *buffer = (char *)malloc(chunk_size + 1); 

        for (int i = 1; i < size; i++) {
            long offset = i * chunk_size;
            if (i == size - 1) {
                chunk_size += remaining;  
            }

            fseek(file, offset, SEEK_SET);
            fread(buffer, 1, chunk_size, file);

            MPI_Send(&chunk_size, 1, MPI_LONG, i, 0, MPI_COMM_WORLD);
            MPI_Send(buffer, chunk_size, MPI_CHAR, i, 0, MPI_COMM_WORLD);
        }

        fread(buffer, 1, chunk_size, file);
        count_letters_in_chunk(buffer, chunk_size, local_counts);

        fclose(file);
        free(buffer);
    } else {

        long chunk_size;
        MPI_Recv(&chunk_size, 1, MPI_LONG, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        char *buffer = (char *)malloc(chunk_size + 1);  
        MPI_Recv(buffer, chunk_size, MPI_CHAR, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

        count_letters_in_chunk(buffer, chunk_size, local_counts);
        free(buffer);
    }

    MPI_Reduce(local_counts, global_counts, 26, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Letter counts in 'War and Peace':\n");
        for (int i = 0; i < 26; i++) {
            printf("%c: %d\n", 'a' + i, global_counts[i]);
        }
    }

    MPI_Finalize();
    return 0;
}
