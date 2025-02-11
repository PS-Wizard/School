#include "../lib/lodepng.h"
#include <stdio.h>
#include <stdlib.h>

unsigned char* image;
unsigned char* imageCopy;
unsigned width,height;
unsigned dx, dy;

int main(){
    unsigned error; 
    error = lodepng_decode32_file(&image,&width,&height,"./original.png");
    if (error){
        printf("%s",lodepng_error_text(error));
        return 1;
    }
    imageCopy = malloc(width*height*4);
    printf("%d %d\n",width,height);
    scanf("%u %u",&dx,&dy);

    for (int row = 0; row  < height-dy; row ++) {
        for (int col = 0; col < width-dx; col++) {
            imageCopy[4*(row*width + col)] = image[4*(row*width + col)];
            imageCopy[4*(row*width + col)+1] = image[4*(row*width + col)+1];
            imageCopy[4*(row*width + col)+2] = image[4*(row*width + col)+2];
            imageCopy[4*(row*width + col)+3] = image[4*(row*width + col)+3];
        }
    }
    error = lodepng_encode32_file("blacked.png",imageCopy,width-dx,height-dy);
    if (error){
        printf("%s",lodepng_error_text(error));
        return 1;
    }

    free(image);
    free(imageCopy);
}
