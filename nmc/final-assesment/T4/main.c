#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "../../lib/lodepng.h"

typedef struct {
    int dx, dy;
} Neighbor;

Neighbor neighbors[] = {
    {-1, -1}, {0, -1}, {1, -1}, {-1, 0},{1, 0}, {-1, 1}, {0, 1}, {1, 1}
};

int is_valid_pixel(int x, int y, unsigned width, unsigned height) {
    return x >= 0 && x < width && y >= 0 && y < height;
}

int pixel_index(int x, int y, unsigned width) {
    return (y * width + x) * 4;
}

void apply_gaussian_blur(unsigned char* image, unsigned width, unsigned height) {
    unsigned char* new_image = malloc(width * height * 4);
    for (unsigned y = 0; y < height; y++) {
        for (unsigned x = 0; x < width; x++) {
            int r_sum = 0, g_sum = 0, b_sum = 0, count = 0;

            for (int i = 0; i < 9; i++) {
                int nx = x + neighbors[i].dx;
                int ny = y + neighbors[i].dy;

                if (is_valid_pixel(nx, ny, width, height)) {
                    int idx = pixel_index(nx, ny, width);
                    r_sum += image[idx];
                    g_sum += image[idx + 1];
                    b_sum += image[idx + 2];
                    count++;
                }
            }

            int new_idx = pixel_index(x, y, width);
            new_image[new_idx] = r_sum / count;
            new_image[new_idx + 1] = g_sum / count;
            new_image[new_idx + 2] = b_sum / count;
            new_image[new_idx + 3] = image[new_idx + 3]; 
        }
    }
    
    memcpy(image, new_image, width * height * 4);
    free(new_image);
}

int main() {
    const char* input = "./background.png";
    const char* output = "./gaussian_blurred.png";

    unsigned char* image; 
    unsigned width, height; 

    unsigned error = lodepng_decode32_file(&image, &width, &height, input);
    if (error) {
        printf("Decoder error %u: %s\n", error, lodepng_error_text(error));
        return 1;
    }
    apply_gaussian_blur(image, width, height);

    error = lodepng_encode32_file(output, image, width, height);
    if (error) {
        printf("Encoder error %u: %s\n", error, lodepng_error_text(error));
        return 1;
    }

    free(image);
    return 0;
}
