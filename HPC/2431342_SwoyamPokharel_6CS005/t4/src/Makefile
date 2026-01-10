# Compiler
NVCC = nvcc

# Files
CUDA_SRC = ./edge_detection.cu
LODEPNG_OBJ = ../assets/lodepng.o
EXECUTABLE = ./edge_detector

# Build target
make:
	$(NVCC) $(CUDA_SRC) $(LODEPNG_OBJ) -o $(EXECUTABLE)

# Run the program
run:
	$(EXECUTABLE)

# Clean build files
clean:
	rm -f $(EXECUTABLE) edge_*.png

.PHONY: make run clean
