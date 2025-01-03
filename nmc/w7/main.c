#include <stdio.h>
#include <stdlib.h>
#include "../lib/lodepng.h"

int main() {
    const char* input_filename = "./wallpaper.png";
    const char* output_filename = "output.png";

    unsigned char* image; 
    unsigned width, height; 

    unsigned error = lodepng_decode32_file(&image, &width, &height, input_filename);
    if (error) {
        printf("Decoder error %u: %s\n", error, lodepng_error_text(error));
        return 1;
    }

    printf("Decoded PNG: %ux%u pixels\n", width, height);

    for(int ros = 0; ros < height; ros++) {
        for (int col = 0; col < width * 4; col++) {
            printf("%d", image[ros*width*4+col]);
            if((col + 1) %4 == 0){
                printf("| ");
            }
        }
        printf("\n");
    }

    error = lodepng_encode32_file(output_filename, image, width, height);
    if (error) {
        printf("Encoder error %u: %s\n", error, lodepng_error_text(error));
        free(image); 
        return 1;
    }

    printf("Saved PNG to %s\n", output_filename);

    free(image);

    return 0;
}

