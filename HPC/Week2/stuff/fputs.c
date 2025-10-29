#include <stdio.h>

int main() {

   FILE *fp;
   char *sub[] = {"C Programming\n", "Python\n", "ML Fundamentals\n", "Advance Machine Vision\n"};
   fp = fopen("file_fputs.txt", "w");

   for (int i = 0; i < 4; i++) {
      fputs(sub[i], fp);
   }

   fclose(fp);
   
   return 0;
}