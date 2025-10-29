#include <stdio.h>
#include <string.h>
int main() {

   FILE *fp;
   char * string = "Example of fputc function.";
   int i;
   char ch;

   fp = fopen("file_fputc.txt", "w");

   for (i = 0; i < strlen(string); i++) {
      ch = string[i];
      if (ch == EOF)
         break;
      fputc(ch, fp);
   }
   printf ("\n");
   fclose(fp);
   
   return 0;
}