#include <stdio.h>
#include <stdlib.h>
#include "../../lib/lodepng.h"

int main() {
    unsigned char *image;
    unsigned width, height;
    unsigned error;

    error = lodepng_decode32_file(&image, &width, &height, "../wallpaper.png");
    if (error) {
        printf("Decode error %u: %s\n", error, lodepng_error_text(error));
        return 1;
    }

    for (size_t i = 0; i < width * height * 4; i += 4) {
        image[i] = 255 - image[i];
        image[i + 1] = 255 - image[i + 1];
        image[i + 2] = 255 - image[i + 2];
        // transparency stays as is
    }

    error = lodepng_encode32_file("output.png", image, width, height);
    if (error) {
        printf("Encode error %u: %s\n", error, lodepng_error_text(error));
        free(image);
        return 1;
    }

    free(image); 
    return 0;
}
