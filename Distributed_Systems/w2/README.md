**Week 2: Distributed Computing**
>
# Status Object

- When we use `MPI_Recv`, it blocks until a message is received, ==but, how do you know who sent it? and how much data was actually received==
- Thats where `MPI_Status` comes in. It stores the metadata about the received message like the source, the tag, and the error code.

If we recall, in week 1 we just did `MPI_Recv(&result, 1, MPI_INT, i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);`, so to use MPI_Status correctly now, we just need to pass in a MPI_Status object,
```c
~
MPI_Status status;
MPI_Recv(buffer, count, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
```
From which, we can now extract the details like:
- `status.MPI_SOURCE`  -> who sent the message
- `status.MPI_TAG`  -> the tag of the message
- `status.MPI_ERROR`  -> any errors

---

# MPI_Get_Count
- Sometimes, you don't know how much data is actually received, (especially when you do `MPI_ANY_SOURCE` or variable-length messages)
- `MPI_Get_Count` helps with that.
```c
~

int count;
MPI_Get_count(&status, MPI_INT, &count);
printf("Received %d integers\n", count);
```

==This tells you how many items (not bytes) were received==

---

# Non blocking send and receives
- `MPI_Isend` (immediate send)
- `MPI_Irecv` (immediate receive)

These return immediately, meaning that the program can do other stuff while waiting, but you must **explicitly wait** for them to complete using `MPI_Wait` or `MPI_Test`.
```c
~

MPI_Request request;
MPI_Isend(buffer, count, MPI_INT, dest, tag, MPI_COMM_WORLD, &request);
MPI_Wait(&request, MPI_STATUS_IGNORE);  // Ensure send completes


MPI_Irecv(buffer, count, MPI_INT, source, tag, MPI_COMM_WORLD, &request);
MPI_Wait(&request, &status);  // Ensure receive completes
```

---

# Broadcast
I mean the name itself is self explanatory. **Typically, rank 0 broadcasts the data**
```c
~

MPI_Bcast(buffer, count, MPI_INT, 0, MPI_COMM_WORLD);
```
So this goes without saying that, all other processes get the same data.

---

# Scatter:
This splits an array into chunks, and sends a chunk to different processes.
```c
~
MPI_Scatter(send_buffer, count, MPI_INT, recv_buffer, recv_count, recv_type, 0, MPI_COMM_WORLD);
```
The `count` in this case, is the number of element each process will receive.

So, if `send_buffer = [1,2,3,4] & count = 1` and there are 4 processes; then:
- P0 would get `1`
- P1 would get `2`
- P2 would get `3`
- P3 would get `4`

==If there are more processes than data, some will receive garbage or nothing.==

---

# Gather
The opposite of scatter; collects data from all processes into an array
```c
MPI_Gather(toBeSentVariable, numberOfThingsToBeSent, MPI_INT, recv_buffer, count, MPI_INT, 0, MPI_COMM_WORLD);
```
If each process sends `x`, in rank 0 will store `[P0_x,P1_x,P2_x,P3_x]`

---

# All-to-All
This function lets every process send a different piece of data to every other process (including itself). It's like everyone exchanging gifts in a group.
```c
~

MPI_Alltoall(send_buffer, count, MPI_INT, recv_buffer, count, MPI_INT, MPI_COMM_WORLD);
```

# Variable All To All
This is similar to the generic all to all but each process can send different amounts of data to different processes
```c
~
MPI_Alltoallv(send_buffer, send_counts, send_displacements, MPI_INT, recv_buffer, recv_counts, recv_displacements, MPI_INT, MPI_COMM_WORLD);
```

---

# Barrier
- Forces all processes to wait at a checkpoint before moving forward
- Used for synchronization
```c
~

MPI_Barrier(MPI_COMM_WORLD);
```

==No processes continue, until all reach this barrier==

---

# Reductions
- Combines values from all processes using an operation like sum,min,max, etc
```c
~
MPI_Reduce(&send_data, &recv_data, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
```
```c
~

int local_value = rank + 1;  // Each process has a value
int global_sum;

MPI_Reduce(&local_value, &global_sum, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

if (rank == 0) {
    printf("Total sum: %d\n", global_sum);
}
```
If we run 4 processes, The results on rank 0 will be, 
`1+2+3+4 = 10`

---

==NOTE: These Methods Are Collective, as in all processes must run them simultaniously==

`MPI_Gather` (collect data to root)

`MPI_Gatherv` (collect data to root with variable amounts)

`MPI_Scatter` (scatter data from root to all processes)

`MPI_Scatterv` (scatter data with variable amounts)

`MPI_Alltoall` (send data from each process to all others)

`MPI_Reduce` (combine data from all processes to root)

`MPI_Allreduce` (combine data and make the result available to all processes)

`MPI_Barrier` (synchronize all processes)

---



==Try on haul lul==

[**Status_Object**](#status-object)
```c
~
#include <mpi.h>
#include <stdio.h>
int main(int argc, char** argv ){
    int rank,size,someValue, toSend;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    MPI_Status status;
    if (rank == 0) {
        toSend = rank * 10 + 1;
        for (int i = 1; i < size; i++) {
            MPI_Send(&toSend, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
        }
    }else{
        MPI_Recv(&someValue,1,MPI_INT,MPI_ANY_SOURCE,MPI_ANY_TAG,MPI_COMM_WORLD,&status);
        printf("Process %d Received From %d, Value: %d, Error: %d, Tag: %d\n", rank, status.MPI_SOURCE, someValue, status.MPI_ERROR, status.MPI_TAG);
    }
     
    MPI_Finalize();
}
```
```
~ Outputs:

Process 1 Received From 0, Value: 1, Error: -2143258368, Tag: 0
Process 2 Received From 0, Value: 1, Error: -73492080, Tag: 0
Process 3 Received From 0, Value: 1, Error: 1554711920, Tag: 0
```
![Confused](https://media.giphy.com/media/QfzMP70zmNQiDf5sGP/giphy.gif)

**why that error code tripping**?

---

[**Get Count:**](#mpi_get_count)

```c
~

#include <mpi.h>
#include <stdio.h>
int main(int argc, char** argv ){
    int rank,size,someValue, toSend, count;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD,&rank);
    MPI_Comm_size(MPI_COMM_WORLD,&size);

    MPI_Status status;
    if (rank == 0) {
        toSend = rank * 10 + 1;
        for (int i = 1; i < size; i++) {
            MPI_Send(&toSend, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
        }
    }else{
        MPI_Recv(&someValue,1,MPI_INT,MPI_ANY_SOURCE,MPI_ANY_TAG,MPI_COMM_WORLD,&status);
        MPI_Get_count(&status, MPI_INT, &count);
        printf("Process %d Received From %d, Value: %d, Error: %d, Tag: %d\n", rank, status.MPI_SOURCE, someValue, status.MPI_ERROR, status.MPI_TAG);
        printf("Data Count: %d\n",count);

    }
     
    MPI_Finalize();
}
```
++TLDR, this just extracts the items received from the `status` object++
```
~

[wizard@archlinux TryOnHaul]$ mpirun -np 4 ./a.out
Process 2 Received From 0, Value: 1, Error: -916138976, Tag: 0
Data Count: 1
Process 1 Received From 0, Value: 1, Error: -1109547024, Tag: 0
Data Count: 1
Process 3 Received From 0, Value: 1, Error: -1548708192, Tag: 0
Data Count: 1
```

---

[**Broadcast**](#broadcast)
```c
~

#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    int rank, size, someValue, toSend, count;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    MPI_Status status;

    if (rank == 0) {
        toSend = 69;
        MPI_Bcast(&toSend, 1, MPI_INT, 0, MPI_COMM_WORLD);  // Broadcast from process 0
    } else {
        MPI_Bcast(&someValue, 1, MPI_INT, 0, MPI_COMM_WORLD);  // Receive the broadcast
        /*MPI_Get_count(&status, MPI_INT, &count);*/
        <!--/*printf("Process %d Received From %d, Value: %d, Error: %d, Tag: %d\n", rank, status.MPI_SOURCE, someValue, status.MPI_ERROR, status.MPI_TAG);*/-->
        /*printf("Data Count: %d\n", count);*/
    }

    MPI_Finalize();
}
```

==NOTE: For rank 0,== `MPI_Bcast` ==actually broadcasts, where as any other rank, it receives==
```
~

[wizard@archlinux TryOnHaul]$ mpirun -np 4 ./a.out
Process 1 Received From 0, Value: 69
Process 2 Received From 0, Value: 69
Process 3 Received From 0, Value: 69
```
- Whats the `status` equivalent for this? since `status` only seems to be working with the `recv`; i mean granted that the broadcast will not require the tag, and since it always comes from rank `0` it shouldnt be a big issue; but then how do the error codes work?

---

[**Non-Blocking Send & Recv**](#non-blocking-send-and-receives)

```c
~

#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    int rank, size, sendValue, recvValue;
    MPI_Request requests[2];
    MPI_Status statuses[2];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    // Initialize non-blocking communication
    if (rank == 0) {
        sendValue = 100;
        MPI_Isend(&sendValue, 1, MPI_INT, 1, 0, MPI_COMM_WORLD, &requests[0]);
        printf("Process %d sent value %d to process 1\n", rank, sendValue);
    } else if (rank == 1) {
        MPI_Irecv(&recvValue, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &requests[0]);
        printf("Process %d started receiving from process 0\n", rank);
    }

    // Add some computation or task to do while communication is happening
    if (rank == 1) {
        // Do something else while waiting
        printf("Process %d doing some work before calling MPI_Wait\n", rank);
        MPI_Wait(&requests[0], &statuses[0]);  // Wait for the receive to complete
        printf("Process %d received value %d from process 0\n", rank, recvValue);
    }

    MPI_Finalize();
}
```
```
~

[wizard@archlinux TryOnHaul]$ mpirun -np 4 ./a.out
Process 0 sent value 100 to process 1
Process 1 started receiving from process 0
Process 1 doing some work before calling MPI_Wait
Process 1 received value 100 from process 0
[wizard@archlinux TryOnHaul]$
```
---

---
