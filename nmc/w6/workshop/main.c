#include <stdio.h>
#include <string.h>

int main() {
    FILE *odd = fopen("odd.txt","w");
    FILE *even = fopen("even.txt","w");
    int n;
    char c[4];
    while (1) {
        printf("Enter character or no stop: ");
        if (scanf("%d",&n) == 1) {
            fprintf(n % 2 == 0? even:odd, "%d\n", n);
        } else {
            scanf("%s",c);
            if (strcmp(c,"no") == 0) break;
        }
    }
    fclose(odd);
    fclose(even);
    return 0;
}

