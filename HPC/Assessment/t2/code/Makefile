all:
	mkdir -p outputs
	gcc main.c matrix_ops.c file_ops.c -o matrix_ops -fopenmp -lm

clean:
	rm -f matrix_ops
	rm -rf outputs

.PHONY: all clean
