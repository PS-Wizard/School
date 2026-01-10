#include <stdio.h>
#include <stdlib.h>
#include "file_ops.h"

int main(int argc, char* argv[]) {
    // Validate command line arguments
    if (argc < 3) {
        fprintf(stderr, "Usage: %s <input_file> <num_threads>\n", argv[0]);
        fprintf(stderr, "Example: %s matrices.txt 4\n", argv[0]);
        return 1;
    }

    // Open input file
    FILE* in = fopen(argv[1], "r");
    if (!in) {
        fprintf(stderr, "Error: Cannot open input file '%s'\n", argv[1]);
        return 1;
    }

    // Parse thread count
    int threads = atoi(argv[2]);
    if (threads <= 0) {
        fprintf(stderr, "Error: Number of threads must be positive (got %d)\n", threads);
        fclose(in);
        return 1;
    }

    // Open output file
    FILE* out = fopen("results.txt", "w");
    if (!out) {
        fprintf(stderr, "Error: Cannot create output file 'results.txt'\n");
        fclose(in);
        return 1;
    }

    // Process all matrix pairs
    int pairCount = processMatrixPairs(in, out, threads);

    // Cleanup
    fclose(in);
    fclose(out);

    // Report results
    printf("Processing complete. Results written to results.txt\n");
    printf("Processed %d matrix pair(s)\n", pairCount);

    return 0;
}
