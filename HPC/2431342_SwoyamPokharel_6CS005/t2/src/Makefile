CC = gcc
CFLAGS = -Wall -Wextra -O2 -fopenmp

TARGET = matrix_program

all:
	$(CC) $(CFLAGS) *.c -o $(TARGET)

clean:
	rm -f $(TARGET) results.txt

.PHONY: all clean
