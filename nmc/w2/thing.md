# Write a program to find out the midpoint of any two points.

```c
~

# include <stdio.h>
void findMidpoint(double a, double b, double c , double d){
    printf("Midpoints: (%.2f, %.2f)\n",((a+b)/2),((c+d)/2));
}

int main(){
    findMidpoint(1,3,5,7);
    return 0;
}
```
```
~

[wizard@archlinux w2]$ ./a.out 
Midpoints: (2.00, 6.00)
[wizard@archlinux w2]$ 
```

> 

# Write a program to find the greatest amongst two numbers.

```c
~

# include <stdio.h>

void findGreater(int a, int b){
    printf("The Greater Value is %d",(a>b? a:b));
}

int main(){
    findGreater(1,2);
    return 0;
}
```
```
~

[wizard@archlinux w2]$ ./a.out 
The Greater Value is 2
[wizard@archlinux w2]$ 
```

# Write a program to find the triangular numbers upto n^th^ term:

```c
~

# include <stdio.h>


void triangular (int n){
    for (int i = 1; i <=n ; i++) {
        printf("%d, ", (i * (i+1) )/2);
    }
}

int main(){
    triangular(5);
    return 0;
}

```
```
~

[wizard@archlinux w2]$ ./a.out 
1, 3, 6, 10, 15, 
[wizard@archlinux w2]$ 
```

# Write a program to calculate velocity:
```c
~

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

```
```
~

[wizard@archlinux w2]$ ./a.out 
The calculated value is: 5.00
[wizard@archlinux w2]$ 
```


