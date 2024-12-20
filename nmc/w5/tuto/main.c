#include <stdio.h>

typedef struct {
    float x, y;
} Point;

Point midpoint(Point p1, Point p2) {
    Point m;
    m.x = (p1.x + p2.x) / 2;
    m.y = (p1.y + p2.y) / 2;
    return m;
}

int main() {
    Point p1, p2, m;
    
    printf("Enter coordinate 1: ");
    scanf("%f %f", &p1.x, &p1.y);
    printf("enter coordinate 2: ");
    scanf("%f %f", &p2.x, &p2.y);
    
    m = midpoint(p1, p2);
    
    printf("Midpoint: (%.2f, %.2f)\n", m.x, m.y);
    
    return 0;
}

