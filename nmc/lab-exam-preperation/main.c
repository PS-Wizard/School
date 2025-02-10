#include <stdio.h>
#include <stdlib.h>

struct Student {
    char name[100];
    int roll,marks;
};


void read(struct Student* a,int size){
    for (int i = 0; i < size; i++) {
        printf("Enter Name Roll Marks: ");
        /*scanf("%s %d %d",(*(a+i)->name), &((*a+i).name), &((*a+i).marks));*/
        scanf("%s %d %d", a[i].name,&(a[i].roll),&(a[i].marks));
    }
}

void print(struct Student* a, int size){
    for (int i = 0; i < size; i++) {
        printf("%s %d %d",a[i].name, a[i].roll, a[i].marks);
    }
}

int main() {
    int n;
    scanf("%d",&n);
    struct Student* a = malloc(n*sizeof(struct Student));
    read(a,n);
    print(a,n);


}

