#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include "../../lib/lodepng.h"

typedef struct {
    int dx, dy;
} Neighbor;

Neighbor neighbors[] = {
    {-1, -1}, {0, -1}, {1, -1}, {-1, 0},{1, 0}, {-1, 1}, {0, 1}, {1, 1}
};

typedef struct {
    unsigned char* image;
    unsigned width;
    unsigned height;
    int start_row;
    int end_row;
} ThreadData;

int is_valid_pixel(int x, int y, unsigned width, unsigned height) {
    return x >= 0 && x < width && y >= 0 && y < height;
}

int pixel_index(int x, int y, unsigned width) {
    return (y * width + x) * 4;
}

void* apply_gaussian_blur(void* arg) {
    ThreadData* data = (ThreadData*)arg;
    unsigned char* image = data->image;
    unsigned width = data->width;
    unsigned height = data->height;
    int start_row = data->start_row;
    int end_row = data->end_row;

    for (int y = start_row; y < end_row; ++y) {
        for (int x = 0; x < width; ++x) {
            unsigned r_sum = 0, g_sum = 0, b_sum = 0;
            int valid_neighbors = 0;

            for (int i = 0; i < 8; ++i) {
                int nx = x + neighbors[i].dx;
                int ny = y + neighbors[i].dy;

                if (is_valid_pixel(nx, ny, width, height)) {
                    int idx = pixel_index(nx, ny, width);
                    r_sum += image[idx];
                    g_sum += image[idx + 1];
                    b_sum += image[idx + 2];
                    valid_neighbors++;
                }
            }

            if (valid_neighbors > 0) {
                int idx = pixel_index(x, y, width);
                image[idx] = r_sum / valid_neighbors;
                image[idx + 1] = g_sum / valid_neighbors;
                image[idx + 2] = b_sum / valid_neighbors;
            }
        }
    }

    return NULL;
}

void apply_gaussian_blur_threaded(unsigned char* image, unsigned width, unsigned height, int num_threads) {
    pthread_t* threads = malloc(num_threads * sizeof(pthread_t));
    ThreadData* thread_data = malloc(num_threads * sizeof(ThreadData));

    // Divide the work among threads
    int rows_per_thread = height / num_threads;

    for (int i = 0; i < num_threads; ++i) {
        thread_data[i].image = image;
        thread_data[i].width = width;
        thread_data[i].height = height;
        thread_data[i].start_row = i * rows_per_thread;
        thread_data[i].end_row = (i == num_threads - 1) ? height : (i + 1) * rows_per_thread;

        pthread_create(&threads[i], NULL, apply_gaussian_blur, &thread_data[i]);
    }

    for (int i = 0; i < num_threads; ++i) {
        pthread_join(threads[i], NULL);
    }

    free(threads);
    free(thread_data);
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

    int num_threads;
    printf("Enter the number of threads: ");
    scanf("%d", &num_threads);

    apply_gaussian_blur_threaded(image, width, height, num_threads);

    error = lodepng_encode32_file(output, image, width, height);
    if (error) {
        printf("Encoder error %u: %s\n", error, lodepng_error_text(error));
        return 1;
    }

    free(image);
    return 0;
}
