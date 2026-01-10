passwords:
	gcc -o password_gen password_generator.c -lcrypt

cracker:
	nvcc -o password_cracker cracker.cu -lcrypt -arch=sm_89 -O3 --use_fast_math -Xcompiler "-O3 -march=native -mtune=native -fopenmp -ffast-math -funroll-loops" -Xlinker -lgomp
clean:
	rm *.txt password_*

.PHONY: passwords passwords-large
