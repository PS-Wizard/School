#include <stdio.h>

int main() {
    FILE *f = fopen("txt.txt", "r");
    char c, line[100];
    
    while ((c = fgetc(f)) != EOF)  
        putchar(c);

    fseek(f, 0, SEEK_SET);

    while ((c = getc(f)) != EOF)   
        putchar(c);

    fseek(f, 0, SEEK_SET);

    while (fgets(line, sizeof(line), f)) 
        puts(line);

    fseek(f, 0, SEEK_SET);

    while (scanf("%s", line) != EOF)
        printf("%s\n", line);

    fclose(f);
    return 0;
}

