#import "@preview/hetvid:0.1.0": *
#show: hetvid.with(
  title: [Week 1: Review of Matrix Operations and Derivative for Deep Learning],
  author: "Shiv Kumar Yadav",
  affiliation: "Swoyam Pokharel",
  header: "Week 1 ~ Tutorial",
  // abstract: [Abstract here],
  toc: false,
)

#line(length: 100%, stroke: 0.4pt + luma(160))

#for i in range(1, 18) {
  image("tuto.pdf", page: i)
}

= Things Mentioned:
-  Eigen Vector Problem
    - In cases where a vector has no change in direction, just magnitude.
    - $|Alpha - lambda Iota| = 0$

== Back propagation
== Derivatives
- $(f (x + h) - f (x)) / h$ 
- Univariant
- Multi Variant

==== Multivariant
- For equations like $3x^2y$, simple derivatives dont work
- We gota do partial derivatives, $(partial f(x,y))/(partial x)$
- TL;DR: Just treat the other as a constant


== Matrix
- Jacobian Matrix: A Collection Of Gradients?
- Gauss Elimination
- Gauss Jordan 
- Matrix Inversion Method
- Maximum Point, Minimum Point 

== Others
- Gradients: $gradient f = [6 x y,  3x^2]$; they are a collection of partial derivatives
  - It's also known as "nabla" -- same symbol: $nabla$
- Cost function, gradient descent, critical points, saddle point?
