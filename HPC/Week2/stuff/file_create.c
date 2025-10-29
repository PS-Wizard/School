#include <stdio.h>
#include <stdlib.h>
void main() 
{
  FILE *fptr;  
  char filename[]= "file01.txt";
  fptr = fopen(filename,"w");
  if (fptr == NULL) {
    printf("Error creating file %s\n", filename);  
    exit(-1);
  }
  else {
    printf("Success creating file %s\n", filename);  
  }
  fclose(fptr);
}
