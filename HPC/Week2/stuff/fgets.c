# include <stdio.h>

int main(){
    FILE *fptr;
    char *line;

    fptr = fopen("file_fputs.txt","r");

    while (!feof(fptr))
    {
        fgets(line,100,fptr);//reads at most 99 characters from the file.(remaining one for null character)
        printf ("%s",line);
    }
    fclose(fptr);
    return 0;
}