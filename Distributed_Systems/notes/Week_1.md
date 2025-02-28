Thu Feb 27 07:28:19 AM +0545 2025
>

# Blah Blah:
### **Definition List:**
- Moore's Law[^1]
- Flynn's Taxonomy thing[^2]
### **Distributed Systems**
- In an organization, one system, different people use it together type shit </ol>
- Has 2 Frameworks ? if thats even the correct word for this:
- MPI (Message passing interface)
- Actor Model
### **Elements of Distributed System:**
- Resource sharing
- Accessibility
- Concurrency
- Scalabilitiy
- Fault tolerance
- Transparency: How much access does a node have to locate and communicate with anothe node. (Which i dont know how that makes sense but still )
### **Grid Computing**
- Happens geographically
- Same project, different people from different geographical locations? 

---

# MPI ( Message Passing Interface ):
MPI is a standard for parallel computing that allows multiple processes (on or across same or different machines) to communicate with one another. It defines a set of functions for sending and receiving messages, synchronizing tasks, and managing data in a distributed environment.
- It's just a ++specification++, not an actual implementation
- Used for distributed-memory parallel processing (each process has its own memory)
- Supports point-to-point communication ( `MPI_Send` `MPI_Recv`) and collective communication ( `MPI_Cast` `MPI_Reduce` )

>

## **MPICH (MPI Chameleon):**
MPICH is ++one of the implementation++ of the MPI standard. 
- It's open source
- Designed for portability, so it works on clusters, super-computers or just regular machines

>
==Installation:==

```
~ Yay:

[wizard@archlinux]$ yay -S mpich


// This builds from source on arch kinda annoying ngl, it will take a long time ~40 ish minutes 
// Wish there was a prebuilt thing on arch considering the Ubuntu WSL Took like 30 seconds so im assuming thats prebuilt
```

>
==Usage:==

Well firstly a refresher on how command line arguments work on c:
```c
~ 

#include <stdio.h>
int main(int argc, char** argv) {
    printf("Total Argument Count: %d\n",argc);
    for (int i = 0; i < argc; i++) {
        printf("%d) %s: \n" ,i, argv[i]);
    }
}
```
`argv` is an array of string: 
- `char*` -> is a pointer to a `char`, which is how C represents strings.
- `char**` -> A pointer to a pointer `char*` which means an array of strings
- This implys that it could also be written as `char* argv[]`

```
~ Output:

Total Argument Count: 4
0) ./a.out:
1) something:
2) somethingelse:
3) something:

// So basically:
argv[0]: ./program
argv[1]: arg1
argv[2]: arg2
...
```
Aight, back to MPICH:
```c
~

#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);  // Initialize MPI

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);  // Get process ID (rank)
    MPI_Comm_size(MPI_COMM_WORLD, &size);  // Get total number of processes

    printf("Hello from process %d out of %d\n", rank, size);

    MPI_Finalize();  // Clean up MPI
    return 0;
}
```
>
1. `MPI_Init(&argc, &argv)`
    - Signature: `int MPI_Init(int *argc, char*** argv)`
    - Purpose: Initialize the MPI environment. **++This is mandatory++** before callign any other MPICH functions

2.  `MPI_Comm_rank(MPI_COMM_WORLD, &rank)`{#rank}
    - Signature: `int MPI_Comm_rank(MPI_COMM comm, int *rank)`
    - Purpose: Gets the ++**rank(ID)**++ of the current process within the communicator `MPI_COMM_WORLD` 
    
3.  `MPI_Comm_size(MPI_COMM_WORLD, &size)`
    - Signature: `int MPI_Comm_rank(MPI_COMM comm, int *size)`
    - Purpose: Gets the ++**total number of processes**++ running in the communicator `MPI_COMM_WORLD`

4. `MPI_Finalize()`:
    - Signature: `int MPI_Finalize(void)` 
    - Purpose: Cleans up the MPI enviroment.
    
```
~ Outputs:


[wizard@archlinux w1]$ mpicc main.c
[wizard@archlinux w1]$ mpirun -np 4 ./a.out
Hello from process 0 out of 4
Hello from process 1 out of 4
Hello from process 2 out of 4
Hello from process 3 out of 4


It's kinda trippy seeing the command line argument being passed as `-np 4` before the program name but oh well, atleast i dont have to convert the 4 which originally is prolly a string back to int so, we take those.
```
>
==NOTE:==
**Its worth noting that one can also do `mpirun -np 4 5 6 ./a.out`, MPICH will only parse the `4` but `5,6` can still be accessed from `argv` as usual**

>

```c

#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);  

    int world_rank, world_size;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);  // Get rank of process
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);  // Get total number of processes

    int number;  // This will hold the number to be squared
    if (world_rank == 0) {
        // Master process: send a number to each worker
        printf("Master: Sending numbers to all workers...\n");

        for (int i = 1; i < world_size; i++) {
            number = i * 10;  
            MPI_Send(&number, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
            printf("Master: Sent %d to process %d\n", number, i);
        }

        // Receive the squared results from all workers
        for (int i = 1; i < world_size; i++) {
            int result;
            MPI_Recv(&result, 1, MPI_INT, i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            printf("Master: Received squared value %d from process %d\n", result, i);
        }
    } else {
        // Worker process: receive a number, compute its square, and send the result back to master
        MPI_Recv(&number, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("Process %d: Received number %d from master\n", world_rank, number);

        int squared = number * number;
        MPI_Send(&squared, 1, MPI_INT, 0, 0, MPI_COMM_WORLD);
        printf("Process %d: Sent squared value %d back to master\n", world_rank, squared);
    }

    MPI_Finalize();  // Finalize MPI
    return 0;
}
```
> 
1. `MPI_Send(&number, 1, MPI_INT, i, 0, MPI_COMM_WORLD)`
    - Signature: `int MPI_Send(void *data, int count, MPI_Datatype datatype, int dest, int tag, MPI_Comm comm)`
    - Parameters:
        - `data`: Pointer to the data we are sending, could be an array or a single value.
        - `count`: Number of items you are sending. For arrays this would be the number of elements in the array
        - `datatype`: Type of data being sent ( `MPI_INT` `MPI_FLOAT` )
        - `dest`: [Rank](#rank) of the destination Process.
        - `tag`: An integer identifier for the message. It helps distinguish between different messages.
        - `comm`: The communicator (usually `MPI_COMM_WORLD` for basic programs)
    - `MPI_Send` sends data to another process. The data is transmitted asynchronously. It doesn’t block the sender.

2. `MPI_Recv(&result, 1, MPI_INT, i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE)`
    - Signature: `int MPI_Recv(void *data, int count, MPI_Datatype datatype, int source, int tag, MPI_Comm comm, MPI_Status *status);`
    - Parameters:
        - `data`: Pointer to the buffer where the received data will be stored.
        - `count`: Max number of items you can receive.
        - `datatype`: Type of data being  received ( `MPI_INT` `MPI_FLOAT` )
        - `source`: [Rank](#rank) of the process you are expecting data from. ( You can use `MPI_ANY_SOURCE` if you don't care about which process sends the message)
        - `tag`: Tag of the message you're expecting. ( You can use `MPI_ANY_TAG` if you dont care about the tag)
        - `comm`: The communicator (usually `MPI_COMM_WORLD` for basic programs)
        - `status`: A Pointer to `MPI_Status` struct, which gives you information about the message ( such as its source, rank, tag, error code ...)
    
>
==NOTE:== Typically, `MPI_Send` ++**isn't blocking**++ whereas `MPI_Recv` **++is blocking++**. But Sometimes, you'd want to continue processing while waiting for the data. For that, you can use the non-blocking versions:
- `MPI_Isend`: Non-blocking send. ( But wait, wasnt `MPI_Send` non-blocking?; ... Well kinda, its blocking until the message is transferred out of the buffer; but this returns immediately and the sender doesn't wait for the message to be transsfered )
- `MPI_Irecv`: Non-blocking recv

These functions allow the process to continue executing while the message is being sent/received. But you'd have to make sure the communication is completed before using the data, typically with `MPI_Wait` or `MPI_Test`.

[^1]:The notion that the number of transistors on a microchip doubles every 2 years where as it's cost is halved
[^2]: Classifies Computer architectures based on how they handle instructions and data.
    - SISD: Single Instruction Single Data:  Classic sequential processing (normal CPU).
    - SIMD: Single Instruction Multiple Data:  One instruction operates on multiple data at once. (vector processing, GPUs)
    - MISD: Multiple Instruction Single Data:  Rare, Multiple instructions work on the same data (gpt says its used in some fault-tolerant systems).
    - MIMD: Multiple Instruction  Multiple Data:  Each processor runs different instructions on different data.
