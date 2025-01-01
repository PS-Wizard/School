#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *sumf = fopen("sum.txt","a");
    for( int a, sum = 0; scanf("%d", &a) == 1; fprintf(sumf, "%d + %d = %d\n", a, (sum-a), (sum += a)));
    fclose(sumf);
}

