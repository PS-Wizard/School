#include "../../lib/lodepng.h"
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <stdio.h>
unsigned char* image, *imageCopy;
unsigned height,width;

typedef struct {
    int dx, dy;  
    int weight;   
} Neighbor;

/*Neighbor neighbors[] = {*/
/*    {-1, -1, 1}, {0, -1, 2}, {1, -1, 1},  */
/*    {-1, 0, 2}, {0, 0, 4}, {1, 0, 2},       */
/*    {-1, 1, 1}, {0, 1, 2}, {1, 1, 1}        */
/*};*/

// 5x5 Kernel Size with appropriate weights because the 3x3 is barely noticable
Neighbor neighbors[] = {
    {-2, -2, 1}, {-1, -2, 4}, {0, -2, 6}, {1, -2, 4}, {2, -2, 1},
    {-2, -1, 4}, {-1, -1, 16}, {0, -1, 24}, {1, -1, 16}, {2, -1, 4},
    {-2, 0, 6}, {-1, 0, 24}, {0, 0, 36}, {1, 0, 24}, {2, 0, 6},
    {-2, 1, 4}, {-1, 1, 16}, {0, 1, 24}, {1, 1, 16}, {2, 1, 4},
    {-2, 2, 1}, {-1, 2, 4}, {0, 2, 6}, {1, 2, 4}, {2, 2, 1}
};

struct thread_info {
    unsigned start;
    unsigned end;
    pthread_t id;
};

int isValid(unsigned row, unsigned col){
    return (row >= 0 && row < height && col >= 0 && col < width);
}

void* applyBlur(void* args){
    struct thread_info* ranges = (struct thread_info*)args;
    printf("Start: %u\n End:%u\n",ranges->start,ranges->end);
    for(unsigned row = ranges->start;  row < ranges->end; row++ ){
        for(unsigned col = 0 ; col<width; col++ ){
            unsigned r_sum = 0, g_sum = 0, b_sum = 0, kernel_sum = 0;
            unsigned our_index = 4 * (row * width + col);
            for(int i = 0; i < 25; i++){
                int n_row = row + neighbors[i].dx;
                int n_col = col + neighbors[i].dy;
                if (isValid(n_row, n_col)){
                    unsigned possible_neighbour = 4*(n_row * width + n_col);
                    r_sum += image[possible_neighbour] * neighbors[i].weight;
                    g_sum += image[possible_neighbour + 1] * neighbors[i].weight;
                    b_sum += image[possible_neighbour + 2] * neighbors[i].weight;
                    kernel_sum += neighbors[i].weight;
                }
            }
            imageCopy[our_index] = r_sum / kernel_sum;
            imageCopy[our_index + 1] = g_sum / kernel_sum;
            imageCopy[our_index + 2] = b_sum / kernel_sum;
        }
    }
}


int main(){
    const char* input = "./background.png";
    unsigned err;
    err = lodepng_decode32_file(&image,&width,&height,input);

    if (err){
        printf("Error %u: %s\n",err,lodepng_error_text(err));
        return 1;
    }

    imageCopy = malloc(width*height*4);
    memcpy(imageCopy,image,width*height*4);

    printf("%u %u",width,height);

    struct thread_info* thread_info = malloc(height / 4 * sizeof(struct thread_info));
    if (!thread_info){
        printf("Thread info allocation failed\n");
        return 1;
    }

    int numThreads = height/4;
    for (int i = 0; i < numThreads ; i++ ) {
        thread_info[i].start = i*4;
        thread_info[i].end = (i == numThreads - 1)? height: (i+1) * 4;
        pthread_create(&thread_info[i].id,NULL,applyBlur,(void*)&thread_info[i]);
    }

    for (int i = 0; i < height / 4; i++) {
        pthread_join(thread_info[i].id,NULL);
    }

    err = lodepng_encode32_file("./gaussian_blurred_hopefully.png",imageCopy,width,height);
    free(image);
    free(imageCopy);
    free(thread_info);


}

/*w*r + c*/
