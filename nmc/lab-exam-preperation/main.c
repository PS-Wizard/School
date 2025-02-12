#include "../lib/lodepng.h"
#include <stdio.h>
#include <stdlib.h>

unsigned char* image;
unsigned char* imageCopy;
unsigned width, height;
unsigned dx, dy;

int main() {
    unsigned error;
    error = lodepng_decode32_file(&image, &width, &height, "./original.png");
    if (error) {
        printf("%s\n", lodepng_error_text(error));
        return 1;
    }

    printf("%d %d\n", width, height);
    scanf("%u %u", &dx, &dy);

    unsigned new_width = width - dx;
    unsigned new_height = height - dy;
    imageCopy = malloc(new_width * new_height * 4);  

    for (unsigned row = 0; row < new_height; row++) {
        for (unsigned col = 0; col < new_width; col++) {
            unsigned src_idx = 4 * ((row + dy) * width + (col + dx));  
            unsigned dst_idx = 4 * (row * new_width + col);

            imageCopy[dst_idx] = image[src_idx];
            imageCopy[dst_idx + 1] = image[src_idx + 1];
            imageCopy[dst_idx + 2] = image[src_idx + 2];
            imageCopy[dst_idx + 3] = image[src_idx + 3];
        }
    }

    error = lodepng_encode32_file("blacked.png", imageCopy, new_width, new_height);
    if (error) {
        printf("%s\n", lodepng_error_text(error));
        return 1;
    }

    free(image);
    free(imageCopy);
    return 0;
}
