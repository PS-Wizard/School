
#include <stdio.h>
#define d(x) double x;

void equations(double a, double b, double c, double d, double e, double f) {
    double x = (e*c - b*f) / (a*e - b*d);
    double y = (a*f-d*c) / (a*e - b*d);
    printf("x: %.3f, y: %.3f",x,y);
}

int main(){
    equations(5.0,6.0,7.0,8.0,9.0,10.0);
}

