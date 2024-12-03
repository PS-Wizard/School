#include <stdio.h>
#include <math.h>


double calcVelocity(double v, double u, double a, double t) {
    if (isnan(v)) return u + a * t;
    if (isnan(u)) return v - a * t;
    if (isnan(a)) return (v - u) / t;
    if (isnan(t)) return (v - u) / a;
    return NAN;
}

int main(){
    double v = NAN, u = 5.0, a = 0, t = 3.0;
    printf("The calculated value is: %.2lf\n", calcVelocity(v, u, a, t));
    return 0;
}

