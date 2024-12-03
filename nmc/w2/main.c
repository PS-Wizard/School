#include <stdio.h>

void equations(double a, double b, double c, double d, double e, double f) {
    double x = (e*c - b*f) / (a*e - b*d);
    double y = (a*f-d*c) / (a*e - b*d);
    printf("x: %f, y: %f",x,y);
}

int main(){
    equations(5.0,6.0,7.0,8.0,9.0,10.0);
}
