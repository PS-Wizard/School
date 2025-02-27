Thu Feb 27 07:28:19 AM +0545 2025
>

Things Mentioned During the Lecture/Tutorial/Workshops:

1. Moore's Law[^1]
2. Flynn's Taxonomy thing[^2]
>
## Elements of Distributed System:
- Resource sharing
- Accessibility
- Concurrency
- Scalabilitiy
- Fault tolerance
- Transparency: How much access does a node have to locate and communicate with anothe node. (Which i dont know how that makes sense but still )

>
++**Grid Computing:**++
- Happens geographically
- Same project, different people from different geographical locations? 

++**Distributed System:**++
- In an organization, one system, different people use it together type shit </ol>
- Has 2 Frameworks ? if thats even the correct word for this:
    - MPI (Message passing interface)
    - Actor Model

---

# MPI (Message Passing Interface):
==MPI in in of itself is just a specification and not an implementation==

Basically a standard for parallel computing that allows multiple processes ( on the same machine or across different machines ) to communicate with one another.

>

## ++MPICH:++
`MPICH` is *++one of the implementation++* of the MPI standard.  
- Open-source
- Designed for portability

>
***TLDR: MPI is the rules of chess and MPICH is the damn game engine***

[^1]:The notion that the number of transistors on a microchip doubles every 2 years where as it's cost is halved
[^2]: Classifies Computer architectures based on how they handle instructions and data.
    - SISD: Single Instruction Single Data:  Classic sequential processing (normal CPU).
    - SIMD: Single Instruction Multiple Data:  One instruction operates on multiple data at once. (vector processing, GPUs)
    - MISD: Multiple Instruction Single Data:  Rare, Multiple instructions work on the same data (gpt says its used in some fault-tolerant systems).
    - MIMD: Multiple Instruction  Multiple Data:  Each processor runs different instructions on different data.
