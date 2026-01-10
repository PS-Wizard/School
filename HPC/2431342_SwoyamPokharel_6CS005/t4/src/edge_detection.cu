#include "../assets/lodepng.h"
#include <cuda_runtime.h>
#include <stdio.h>
#include <string.h>

#define CEIL_DIV(x, y) (((x) + (y) - 1) / (y))

__constant__ int Gx[9] = { -1, 0, 1, -2, 0, 2, -1, 0, 1 };
__constant__ int Gy[9] = { -1, -2, -1, 0, 0, 0, 1, 2, 1 };

__global__ void sobelKernel(unsigned char* input, unsigned char* output, int width, int height)
{
    int col = threadIdx.x + blockIdx.x * blockDim.x;
    int row = threadIdx.y + blockIdx.y * blockDim.y;
    if (col >= width || row >= height)
        return;
    int gx_sum = 0;
    int gy_sum = 0;
    for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
            int n_row = row + ky;
            int n_col = col + kx;
            unsigned char pixel_value = 0;
            if (n_row >= 0 && n_row < height && n_col >= 0 && n_col < width) {
                pixel_value = input[n_row * width + n_col];
            }
            int kernel_idx = (ky + 1) * 3 + (kx + 1);
            gx_sum += pixel_value * Gx[kernel_idx];
            gy_sum += pixel_value * Gy[kernel_idx];
        }
    }
    float magnitude = sqrtf((float)(gx_sum * gx_sum + gy_sum * gy_sum));
    if (magnitude > 255)
        magnitude = 255;
    output[row * width + col] = (unsigned char)magnitude;
}

void processImage(const char* input_path, const char* output_path)
{
    unsigned width, height;
    unsigned char* image;

    // LOAD IMAGE
    unsigned err = lodepng_decode32_file(&image, &width, &height, input_path);
    if (err) {
        printf("Decode Error %u for %s: %s\n", err, input_path, lodepng_error_text(err));
        return;
    }
    printf("Processing: %s (%u x %u)\n", input_path, width, height);

    // CONVERT TO GRAYSCALE
    size_t num_pixels = width * height;
    unsigned char* gray = (unsigned char*)malloc(num_pixels);
    for (size_t i = 0; i < num_pixels; i++) {
        unsigned char r = image[i * 4];
        unsigned char g = image[i * 4 + 1];
        unsigned char b = image[i * 4 + 2];
        gray[i] = (r + g + b) / 3;
    }
    free(image);

    // ALLOCATE GPU MEMORY
    unsigned char *d_input, *d_output;
    size_t bytes = num_pixels * sizeof(unsigned char);
    cudaMalloc(&d_input, bytes);
    cudaMalloc(&d_output, bytes);

    // COPY TO GPU
    cudaMemcpy(d_input, gray, bytes, cudaMemcpyHostToDevice);

    // LAUNCH KERNEL
    dim3 threads(16, 16);
    dim3 blocks(CEIL_DIV(width, 16), CEIL_DIV(height, 16));
    sobelKernel<<<blocks, threads>>>(d_input, d_output, width, height);

    cudaError_t cuda_err = cudaGetLastError();
    if (cuda_err != cudaSuccess) {
        printf("CUDA Error for %s: %s\n", input_path, cudaGetErrorString(cuda_err));
        cudaFree(d_input);
        cudaFree(d_output);
        free(gray);
        return;
    }
    cudaDeviceSynchronize();

    // COPY RESULT BACK TO CPU
    unsigned char* output = (unsigned char*)malloc(num_pixels);
    cudaMemcpy(output, d_output, bytes, cudaMemcpyDeviceToHost);

    // WRITE IMAGE
    err = lodepng_encode_file(output_path, output, width, height, LCT_GREY, 8);
    if (err) {
        printf("Encode Error %u for %s: %s\n", err, output_path, lodepng_error_text(err));
    } else {
        printf("Saved: %s\n", output_path);
    }

    // FREE MEMORY
    cudaFree(d_input);
    cudaFree(d_output);
    free(gray);
    free(output);
}

char* createOutputFilename(const char* input_path)
{
    // Find the last slash or backslash
    const char* filename = strrchr(input_path, '/');
    if (!filename)
        filename = strrchr(input_path, '\\');
    if (filename)
        filename++; // Skip the slash
    else
        filename = input_path; // No path separator found

    // Allocate space for "edge_" + filename
    size_t len = strlen(filename);
    char* output = (char*)malloc(len + 6); // "edge_" = 5 chars + null terminator
    sprintf(output, "edge_%s", filename);

    return output;
}

int main(int argc, char* argv[])
{
    if (argc < 2) {
        printf("Usage: %s <image1.png> [image2.png] [...]\n", argv[0]);
        return 1;
    }

    printf("Processing %d image(s)...\n\n", argc - 1);

    for (int i = 1; i < argc; i++) {
        char* output_path = createOutputFilename(argv[i]);
        processImage(argv[i], output_path);
        free(output_path);
        printf("\n");
    }

    printf("All images processed!\n");
    return 0;
}
