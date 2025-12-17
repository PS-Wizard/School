CC = gcc
CFLAGS = -Wall -Wextra -O2
TARGET = a.out
SRCS = $(wildcard *.c)

all: $(TARGET)

$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(SRCS) -o $(TARGET)

run: $(TARGET)
	./$(TARGET) 4 ../assets/WordOccurrenceDataset.txt

clean:
	rm -f $(TARGET) ./result.txt
