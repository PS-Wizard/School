// ========== DARK MODE ==========
#set page(fill: rgb("#282828"))
#set text(fill: rgb("#c0b196"))  // your kitty fg

// ========== LIGHT MODE ==========
// #set page(fill: rgb("#fbf1c7"))
// #set text(fill: rgb("#3c3836"))
#import "@preview/hetvid:0.1.0": *
#show: hetvid.with(
  title: [Linear Algebra],
  author: "Swoyam Pokharel",
  affiliation: "AI Stuff",
  header: "Linear Algebra",
  date-modified: datetime.today().display(),
  toc: true,
  body-font: ("Libertinus Serif", "New Computer Modern", "FreeSerif"),
  heading-font: ("New Computer Modern", "Libertinus Serif", "FreeSans"),
  raw-font: ("DejaVu Sans Mono", "JetBrainsMono NF"),
  math-font: "New Computer Modern Math",
  emph-font: ("Libertinus Serif", "New Computer Modern"),
  bib-style: (
    en: "harvard-cite-them-right",
    zh: "gb-7714-2015-numeric",
  ),
)

#line(length: 100%, stroke: 0.4pt + luma(160))

= Spans & Basis

== Linear Combination

"Linearly combined" means that when we combine two vectors, say:

$
1/2 arrow(u) + 2 arrow(v) = mat(delim: "[", 4.5;2.5)
$

The only operations that are allowed are:
- additions betwen vectors
- and scalar multiplication of a vector

== Linear Dependence

If we can write one vector $arrow(V)$ as a linear combination of another vector, it's linearly dependent.

#line(length: 100%, stroke: 0.4pt + luma(160))

= Span 

The span of a vector(s) is the set of all the points that can be reached using linear combination. 


