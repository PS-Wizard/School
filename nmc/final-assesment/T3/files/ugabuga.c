#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
#include <ctype.h>

#define FILE_COUNT 3
const char *files[] = {"PrimeData1.txt", "PrimeData2.txt", "PrimeData3.txt"};

int is_prime(int n) {
    if (n < 2) return 0;
    if (n == 2) return 1;
    if (n % 2 == 0) return 0;
    for (int i = 3; i * i <= n; i += 2) {
        if (n % i == 0) return 0;
    }
    return 1;
}

int count_primes_in_file(const char *filename) {
    int fd = open(filename, O_RDONLY);
    if (fd < 0) {
        perror("open");
        return 0;
    }

    struct stat sb;
    if (fstat(fd, &sb) == -1) {
        perror("fstat");
        close(fd);
        return 0;
    }

    char *data = mmap(NULL, sb.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
    if (data == MAP_FAILED) {
        perror("mmap");
        close(fd);
        return 0;
    }

    int count = 0;
    char *end = data + sb.st_size, *ptr = data;
    while (ptr < end) {
        while (ptr < end && !isdigit(*ptr)) ptr++;
        if (ptr >= end) break;
        
        int num = strtol(ptr, &ptr, 10);
        if (is_prime(num)) count++;
    }

    munmap(data, sb.st_size);
    close(fd);
    return count;
}

int main() {
    int total_count = 0;
    for (int i = 0; i < FILE_COUNT; i++) {
        total_count += count_primes_in_file(files[i]);
    }
    printf("Total primes: %d\n", total_count);
    return 0;
}

