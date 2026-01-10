#include <crypt.h>
#include <cuda_runtime.h>
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TOTAL_PASSWORDS (26 * 26 * 10 * 10) // aa00 to zz99
#define THREADS_PER_BLOCK 256
#define SALT "$6$AS$"
#define MAX_HASH_LEN 128
#define MAX_TARGETS 10000

// Structure to hold password data
typedef struct {
    char original[5]; // e.g., "aa00"
    char transformed[11]; // 10-char transformed + null terminator
    char hashed[128]; // SHA-512 hash result (crypt output is ~100 chars)
} PasswordTriple;

// CUDA kernel to transform passwords
__global__ void cudaCryptKernel(PasswordTriple* passwords, int n)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx >= n)
        return;

    // Generate the original password from index
    int digit2 = idx % 10;
    int digit1 = (idx / 10) % 10;
    int letter2 = (idx / 100) % 26;
    int letter1 = (idx / 10 * 100 * 26) % 26;

    char rawPassword[4];
    rawPassword[0] = 'a' + letter1;
    rawPassword[1] = 'a' + letter2;
    rawPassword[2] = '0' + digit1;
    rawPassword[3] = '0' + digit2;

    // Store original password
    passwords[idx].original[0] = rawPassword[0];
    passwords[idx].original[1] = rawPassword[1];
    passwords[idx].original[2] = rawPassword[2];
    passwords[idx].original[3] = rawPassword[3];
    passwords[idx].original[4] = '\0';

    // Apply transformation
    char newPassword[10];
    newPassword[0] = rawPassword[0] + 2;
    newPassword[1] = rawPassword[0] - 2;
    newPassword[2] = rawPassword[0] + 1;
    newPassword[3] = rawPassword[1] + 3;
    newPassword[4] = rawPassword[1] - 3;
    newPassword[5] = rawPassword[1] - 1;
    newPassword[6] = rawPassword[2] + 2;
    newPassword[7] = rawPassword[2] - 2;
    newPassword[8] = rawPassword[3] + 4;
    newPassword[9] = rawPassword[3] - 4;

    // Apply wrapping logic
    for (int i = 0; i < 10; i++) {
        if (i < 6) {
            // Letters (a-z: 97-122)
            if (newPassword[i] > 122) {
                newPassword[i] = (newPassword[i] - 122) + 97;
            } else if (newPassword[i] < 97) {
                newPassword[i] = (97 - newPassword[i]) + 97;
            }
        } else {
            // Digits (0-9: 48-57)
            if (newPassword[i] > 57) {
                newPassword[i] = (newPassword[i] - 57) + 48;
            } else if (newPassword[i] < 48) {
                newPassword[i] = (48 - newPassword[i]) + 48;
            }
        }
    }

    // Store transformed password
    for (int i = 0; i < 10; i++) {
        passwords[idx].transformed[i] = newPassword[i];
    }
    passwords[idx].transformed[10] = '\0';
}

// CUDA kernel to search for matching hashes
__global__ void searchHashesKernel(PasswordTriple* passwords, int n_passwords, char* target_hashes, int n_targets, int* match_indices)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx >= n_passwords)
        return;

    // Compare this password's hash against all target hashes
    for (int i = 0; i < n_targets; i++) {
        char* target = target_hashes + (i * MAX_HASH_LEN);
        char* candidate = passwords[idx].hashed;

        // String comparison
        bool match = true;
        for (int j = 0; j < MAX_HASH_LEN; j++) {
            if (target[j] != candidate[j]) {
                match = false;
                break;
            }
            if (target[j] == '\0' && candidate[j] == '\0') {
                break;
            }
        }

        if (match) {
            // Found a match! Store the password index at the target index
            match_indices[i] = idx;
        }
    }
}

// Hash the transformed passwords using SHA-512 (CPU function with OpenMP)
void hash_transformed_passwords(PasswordTriple* passwords, int n)
{
    printf("Hashing %d transformed passwords with SHA-512...\n", n);

#pragma omp parallel
    {
        // Thread-local crypt_data for crypt_r (thread-safe version)
        struct crypt_data data;
        data.initialized = 0;

#pragma omp for schedule(static)
        for (int i = 0; i < n; i++) {
            // Apply crypt_r with SHA-512 (thread-safe)
            char* encrypted = crypt_r(passwords[i].transformed, SALT, &data);

            // Copy the hash result - optimized memcpy
            size_t len = 0;
            while (encrypted[len] != '\0' && len < 127)
                len++;
            memcpy(passwords[i].hashed, encrypted, len);
            passwords[i].hashed[len] = '\0';
        }
    }

    printf("Hashing complete!\n");
}

// Load target hashes from file
int load_target_hashes(const char* filename, char* hashes, int max_hashes)
{
    FILE* fp = fopen(filename, "r");
    if (!fp) {
        fprintf(stderr, "Error: Could not open %s\n", filename);
        return -1;
    }

    int count = 0;
    char line[MAX_HASH_LEN];

    while (fgets(line, sizeof(line), fp) && count < max_hashes) {
        // Remove newline
        line[strcspn(line, "\n")] = '\0';

        // Copy to hash array
        size_t len = strlen(line);
        if (len >= MAX_HASH_LEN)
            len = MAX_HASH_LEN - 1;
        memcpy(hashes + (count * MAX_HASH_LEN), line, len);
        hashes[count * MAX_HASH_LEN + len] = '\0';
        count++;
    }

    fclose(fp);
    return count;
}

int main(int argc, char* argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <password_encrypted.txt>\n", argv[0]);
        return 1;
    }

    printf("Password Cracker - Generating rainbow table and searching...\n");
    printf("Total passwords: %d\n", TOTAL_PASSWORDS);

    // Allocate host memory
    PasswordTriple* h_passwords = (PasswordTriple*)malloc(TOTAL_PASSWORDS * sizeof(PasswordTriple));
    if (!h_passwords) {
        fprintf(stderr, "Failed to allocate host memory\n");
        return 1;
    }

    // Allocate device memory
    PasswordTriple* d_passwords;
    cudaMalloc(&d_passwords, TOTAL_PASSWORDS * sizeof(PasswordTriple));

    // Calculate grid dimensions
    int blocks = (TOTAL_PASSWORDS + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK;

    printf("Generating transformations on GPU...\n");
    cudaCryptKernel<<<blocks, THREADS_PER_BLOCK>>>(d_passwords, TOTAL_PASSWORDS);
    cudaDeviceSynchronize();

    // Copy results back to host
    printf("Copying results from GPU to host...\n");
    cudaMemcpy(h_passwords, d_passwords, TOTAL_PASSWORDS * sizeof(PasswordTriple), cudaMemcpyDeviceToHost);

    // Hash the transformed passwords on CPU
    printf("Hashing transformed passwords...\n");
    hash_transformed_passwords(h_passwords, TOTAL_PASSWORDS);

    // Copy hashed passwords back to GPU
    printf("Copying hashed passwords to GPU...\n");
    cudaMemcpy(d_passwords, h_passwords, TOTAL_PASSWORDS * sizeof(PasswordTriple), cudaMemcpyHostToDevice);

    // Load target hashes
    printf("Loading target hashes from %s...\n", argv[1]);
    char* h_target_hashes = (char*)malloc(MAX_TARGETS * MAX_HASH_LEN);
    int n_targets = load_target_hashes(argv[1], h_target_hashes, MAX_TARGETS);

    if (n_targets <= 0) {
        fprintf(stderr, "Failed to load target hashes\n");
        cudaFree(d_passwords);
        free(h_passwords);
        free(h_target_hashes);
        return 1;
    }

    printf("Loaded %d target hashes\n", n_targets);

    // Copy target hashes to GPU
    char* d_target_hashes;
    cudaMalloc(&d_target_hashes, MAX_TARGETS * MAX_HASH_LEN);
    cudaMemcpy(d_target_hashes, h_target_hashes, MAX_TARGETS * MAX_HASH_LEN, cudaMemcpyHostToDevice);

    // Allocate match tracking array (one slot per target hash)
    int* d_match_indices;
    int* h_match_indices = (int*)malloc(n_targets * sizeof(int));

    // Initialize to -1 (no match)
    for (int i = 0; i < n_targets; i++) {
        h_match_indices[i] = -1;
    }

    cudaMalloc(&d_match_indices, n_targets * sizeof(int));
    cudaMemcpy(d_match_indices, h_match_indices, n_targets * sizeof(int), cudaMemcpyHostToDevice);

    // Search for matches on GPU
    printf("Searching for matches on GPU...\n");
    searchHashesKernel<<<blocks, THREADS_PER_BLOCK>>>(d_passwords, TOTAL_PASSWORDS, d_target_hashes, n_targets, d_match_indices);
    cudaDeviceSynchronize();

    // Copy results back
    cudaMemcpy(h_match_indices, d_match_indices, n_targets * sizeof(int), cudaMemcpyDeviceToHost);

    // Write matches to file
    FILE* fp = fopen("cracked_passwords.txt", "w");
    if (fp) {
        for (int i = 0; i < n_targets; i++) {
            if (h_match_indices[i] != -1) {
                int idx = h_match_indices[i];
                fprintf(fp, "%s:%s:%s\n", h_passwords[idx].hashed, h_passwords[idx].transformed, h_passwords[idx].original);
            }
        }
        fclose(fp);
        printf("Results saved to cracked_passwords.txt\n");
    }

    cudaFree(d_passwords);
    cudaFree(d_target_hashes);
    cudaFree(d_match_indices);
    free(h_passwords);
    free(h_target_hashes);
    free(h_match_indices);

    return 0;
}
