#include <stdio.h>
#include <stdlib.h>

struct Employee { char name[30]; float salary; int hours; };

void highestSalary(struct Employee *emps, int n) {
    float max = emps[0].salary;
    for (int i = 1; i < n; i++) if (emps[i].salary > max) max = emps[i].salary;
    printf("Highest Salary: %.2f\n", max);
}

int main() {
    int n;
    scanf("%d", &n);
    struct Employee *emps = malloc(n * sizeof(struct Employee));
    for (int i = 0; i < n; i++) scanf("%s %f %d", emps[i].name, &emps[i].salary, &emps[i].hours);
    highestSalary(emps, n);
    free(emps);
    return 0;
}

