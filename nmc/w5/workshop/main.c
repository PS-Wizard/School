#include <stdio.h>
#include <stdlib.h>

struct Employee {
    char name[30];
    float salary;
    int hours;
};

void highest_salary(struct Employee* e, int n) {
    float max = 0;
    for (int i = 1; i < n; i++) if (e[i].salary > max) max = e[i].salary;
    printf("Highest salary: %.2f\n", max);
}

int main() {
    int n;
    scanf("%d", &n);
    struct Employee* e = malloc(n * sizeof(struct Employee));
    for (int i = 0; i < n; i++) scanf("%s %f %d", e[i].name, &e[i].salary, &e[i].hours);
    highest_salary(e, n);
    free(e);
    return 0;
}

