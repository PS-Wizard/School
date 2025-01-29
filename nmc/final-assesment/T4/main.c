#include <stdio.h>
#include <stdlib.h>
#include "../../lib/lodepng.h"

void apply_gaussian_blur(int x, int y, unsigned char* image, unsigned char* output_image, int width, int height) {
    int r_sum = 0, g_sum = 0, b_sum = 0;
    int count = 0;

    // List of relative positions for the surrounding 8 pixels
    int offsets[] = {-width-1, -width, -width+1, -1, 1, width-1, width, width+1};

    for (int i = 0; i < 8; i++) {
        int nx = x + offsets[i];
        // Make sure it's within bounds
        if (nx >= 0 && nx < width * height && (nx / width == (x + offsets[i]) / width)) {
            r_sum += image[nx * 4];
            g_sum += image[nx * 4 + 1];
            b_sum += image[nx * 4 + 2];
            count++;
        }
    }

    // Add the current pixel itself
    r_sum += image[x * 4];
    g_sum += image[x * 4 + 1];
    b_sum += image[x * 4 + 2];
    count++;

    // Set the blurred color to the output image
    output_image[x * 4] = r_sum / count;
    output_image[x * 4 + 1] = g_sum / count;
    output_image[x * 4 + 2] = b_sum / count;
    output_image[x * 4 + 3] = image[x * 4 + 3]; // Keep alpha as is
}

int main() {
    const char* input_filename = "./background.png";
    const char* output_filename = "output.png";

    unsigned char* image; 
    unsigned width, height;

    // Decode the image
    unsigned error = lodepng_decode32_file(&image, &width, &height, input_filename);
    if (error) {
        printf("Decoder error %u: %s\n", error, lodepng_error_text(error));
        return 1;
    }

    printf("Decoded PNG: %ux%u pixels\n", width, height);

    // Prepare output image (same size as input)
    unsigned char* output_image = malloc(width * height * 4); // 4 bytes per pixel (RGBA)

    // Apply Gaussian blur (excluding borders)
    for (int y = 1; y < height - 1; y++) {
        for (int x = 1; x < width - 1; x++) {
            apply_gaussian_blur(x + y * width, y, image, output_image, width, height);
        }
    }

    // Encode the image back to a PNG file
    error = lodepng_encode32_file(output_filename, output_image, width, height);
    if (error) {
        printf("Encoder error %u: %s\n", error, lodepng_error_text(error));
        free(image); 
        free(output_image);
        return 1;
    }

    printf("Saved PNG to %s\n", output_filename);

    // Free allocated memory
    free(image);
    free(output_image);

    return 0;
}
