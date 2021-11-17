---
title: Concurrency and Parallelism
date: 2021-11-17
tags: [programming]
---

Concurrency is an exciting topic that's becoming more and more important, yet I see so many people that aren't very
familiar with topic and it's possibilities. I'll try to explain the differences between threading, multiprocessing and
asynchronous run. I'll also show some examples when concurrency should be avoided, and when it makes sense.

I'll be talking about concurrency with python language in mind, but even if you don't use python, I still think that
you can learn a lot from this article if you aren't that familiar with key concurrency concepts. My hope is that after
you read this article, you will confidently know the differences between the various concurrency methods and their
individual advantages or disadvantages when compared to each other.

## Why concurrency?

In programming, we often have the need to do things very quickly so that our program isn't slow. But we also often need
to perform complex operations which take some time to actually compute. To cope with this, we can sometimes perform
certain tasks at the same time.

As an example, we can think about concurrency as the amount of lanes on a highway. If we have a highway with just one
single lane, all cars on it would have to use that lane and they would travel only as quickly as the slowest car in
front of them. But once we bring in another lane, we can already see huge improvements because the cars can go at their
own speeds on separate lanes and we can physically fit in more cars.

Similarly to this example, when we use concurrency, we allocate multiple physical CPUs/cores to a process, essentially
giving it more clock cycles, however not every task is suited for concurrent run, consider this example:

```py
x = my_function()
y = my_other_function(x)
```

We can clearly see that `my_other_function` is completely dependent on the result of `my_function`, this means that it
wouldn't make any sense to run these concurrently on 2 cores, because `my_other_function` would just wait for
`my_function` and only after it's finished will it start running. We just used 2 cores and did something slower than
with one core. It was slower because it took some time to send the result of `my_function` to `my_other_function`
running in a separate process.

This shows us that not all tasks are suited to run concurrently, but there are some that really could benefit from this
form of run. For example if we wanted to read the content of 200 different files, reading them one-by-one would take a
lot of time, but if we were able to read all 200 concurrently, it would only take us the duration of reading 1 file,
yet we would get the content of all 200 files. (Of course we're assuming that our disk would support reading 200 things
at once).

Even though this sounds good, it's never as simple as it first sounds. Even though it is true, on most machines, we
won't actually be able to run 200 things at once because we don't have 200 CPUs/cores. Concurrency like this will
always be limited by the hardware of the computer your software is running on. If you have a computer with 8 logical
CPUs/cores we can only run 8 things at once. Even though it obviously won't be as good as running 200 tasks at once, it
will still be way better than running single task at once. In our example, we would be able to get the results of all
200 tasks in the amount of time it would take to run 25 tasks sequentially, this is still a huge improvement.

## Threads vs Processes

Understanding the concept of concurrency is one thing, but how do we actually run our code on multiple cores/CPUs?
Luckily for us, this is all handled by the operating system that we're running. The kernel of this OS has to manage
thousands of processes with their threads that all have to run and all of those constantly fight to get as much CPU
clock cycles as they can. It is up to the OS to determine which processes are more important then others and to
interchange these processes so that each process gets enough CPU time, having multiple cores helps a lot because rather
than constantly swapping processes around on a single core, we can run n processes at once and the OS has less overall
swapping to do. But what are these processes and the threads attached to hem?

But what are Threads? The concept of a process is probably not a hard one to understand, it's just a separate program
that we started, but a thread is a bit more interesting than that. Threads are essentially a way for a single process
to do 2 things concurrently, yet keep existing in the shared-state of a single process. This means we don't have any
communication overhead and it's very easy to pass information along. However this property can often be disadvantage,
since threads work on a single shared state, we often need to use locks to properly communicate without causing issues.
(I'll explain the importance of locks with some examples later, but essentially, we need locks to prevent data loss
when 2 threads make a change to the same place in memory at once.)

As you were probably able to figure out, the advantage of processes is that they don't have these shared states,
processes are fully independent, however this is also a disadvantage because it is hard to communicate between these
processes. Since we don't have this shared state, if processes want to talk to each other, they need to find take the
objects from memory, serialize them and move them across a raw socket to another process, where it can get
deserialized. (This will most likely be done with `pickle` library in python.) This means processes have huge
communication cost compared to threads.

## Why do we need locks?

Consider this code:

```py
>>> import sys
>>> a = []
>>> b = a
>>> sys.getrefcount(a)
3
```

In the example here, we can see that python keeps a reference count for the empty list object, and in this case, it was
3. The list object was referenced by a, b and the argument passed to `sys.getrefcount`. If we didn't have locks,
threads could attempt to increase the reference count at once, this is a problem because what would actually happen
would go something like this:

> Thread 1: Read the current amount of references from memory (for example 5) <br>
> Thread 2: Read the current amount of references from memory (same as above - 5) <br>
> Thread 1: Increase this amount by 1 (we're now at 6) <br>
> Thread 2: Increase this amount by 1 (we're also at 6 in the 2nd thread) <br>
> Thread 1: Store the increased amount back to memory (we store this increased amount of 6 back to memory) <br>
> Thread 2: Store the increased amount back to memory (we store the increased amount of 6 to memory?) <br>

[Treat sections of 2 lines as things happening concurrently]

You can see that because threads 1 and 2 both read the reference amount from memory  at the same time, they read the
same number, then they've increased it and stored it back without ever knowing that some other thread is also in the
process of increasing the reference count but it read the same amount from memory as this process, so even though the
first thread stored the updated amount, the 2nd thread also stored the updated amount, except they were the same
amounts.

Suddenly we have no solid way of knowing how many references there actually are to our list which means it may get
removed by automated garbage collection because we've hit 0 references when we actually still have an active reference.
There is a way to circumvent this though, and that is with the use of locks

Dummy internal code:

```py
lock.acquire()
references = sys.getrefcount()
references += 1
update_references(references)
lock.release()
```

Here, before we even started to read the amount of references, we've acquired a lock, preventing other threads from
continuing and causing them to wait until a lock is released so that another thread can acquire it. With this code,
it wold go something like this:

> Thread 1: Try to acquire a shared lock between threads (lock is free, Thread 1 now has the lock) <br>
> Thread 2: Try to acquire a shared lock between threads (lock is already acquired by Thread 1, we're waiting) <br>
> Thread 1: Read the current amount of references from memory (for example 5) <br>
> Thread 2: Try to acquire the lock (still waiting) <br>
> Thread 1: Increase this amount by 1 (we're now at 6) <br>
> Thread 2: Try to acquire the lock (still waiting) <br>
> Thread 1: Store the increased amount back to memory (we now have 6 in memory) <br>
> Thread 2: Try to acquire the lock (still waiting) <br>
> Thread 1: Release the lock <br>
> Thread 2: Try to acquire the lock (success, Thread 2 now has the lock) <br>
> Thread 1: Finished (died) <br>
> Thread 2: Read the current amount of references from memory (read value 6 from memory) <br>
> Thread 2: Increase this amount by 1 (we're now at 7) <br>
> Thread 2: Store the increased amount back to memory (we now have 7 in memory) <br>
> Thread 2: Release the lock <br>
> Thread 2: Finished (died) <br>

We can immediately see that this is a lot more complex than having lock-free code, but it did fix our problem, we
managed to correctly increase the reference count across multiple threads. The question is, at what cost?

It takes a while to acquire or release a lock and these additional instructions slow down our code a lot, not to
mention that thread 2 was completely blocked while thread 1 had the lock and it was spending CPU cycles by sleeping and
waiting for the 1st thread to finish and release the lock. This is why threading can be quite complicated to deal with
and why some tasks should really stay single-threaded.

In this small example, it may be easy to understand what's going on, but if you add enough locks, it becomes
increasingly difficult to know whether there will be any "dead-locks" (this can happen when a thread acquires a lock
but never releases it, often the case if we forcefully kill a thread), to test your code, etc. Managing locks can
become a nightmare in a complex enough code-base.

Another problem about locks is, that they don't actually lock anything. Lock is essentially just a signal that can be
checked for and if it's active the thread can choose to wait until that signal is gone (the lock is released). But this
only happens if we actually check and if we decide to respect it, the threads are supposed to respect them, but there's
absolutely nothing preventing these threads from actually running anyway. If these threads forget to acquire a lock
they can do something that they shouldn't have been able to do. This means that even if we have a large code-base with
a lot of locks written correctly, it may not stay correct over time. Small adjustments to the code can cause it to
become incorrect in a way that's hard to see during code reviews.

## Debugging multi-threaded code

As an example, this is a multi-threaded code that will pass all tests and yet it is full of bugs:
```py
import threading

counter = 0

def foo():
    global counter
    counter += 1
    print(f"The count is {counter}")
    print("----------------------")

print("Starting")
for _ in range(5):
    threading.Thread(target=foo).start()
print("Finished")
```
When you run this code, you will most likely get a result that you would expect, but it is possible that you could also
get a complete mess, it's just not very likely because the code runs very quickly. This means you can write code
multi-threaded code that will pass all tests and still fail in production, which is very dangerous.

To actually debug this code, we can use a technique called "fuzzing". With it, we essentially add a random sleep delay
behind every instruction to ensure that it is safe if a switch happens during that time. But even with this technique,
it is advised to run the code multiple times because there is a chance of getting the correct result even with this
method since it always is one of the possibilities, this is why multi-threaded code can introduce a lot of problems.
This would be the code with this "fuzzing" method applied:
```py
import threading
import time
import random

def fuzz():
    time.sleep(random.random())

counter = 0

def foo():
    global counter

    fuzz()
    old_counter = counter
    fuzz()
    counter = old_counter + 1
    fuzz()
    print(f"The count is {counter}")
    fuzz()
    print("----------------------")

print("Starting")
for _ in range(5):
    threading.Thread(target=foo).start()
print("Finished")
```
You may also notice that I didn't just add `fuzz()` call to every line, I've also split the line that incremented
counter into 2 lines, one that reads the counter and another one that actually increments it, this is because
internally, that's what would be happening it would just be hidden away, so to add a delay between these instructions
I had to actually split the code like this. This makes it almost impossible to test multi-threaded code, which is a big
problem.

It is possible to fix this code with the use of locks, which would look like this:
```py
import threading

counter_lock = threading.Lock()
printer_lock = threading.Lock()

counter = 0

def foo():
    global counter
    with counter_lock:
        counter += 1
        with printer_lock:
            print(f"The count is {counter}")
            print("----------------------")

with printer_lock:
    print("Starting")

worker_threads = []
for _ in range(5):
    t = threading.Thread(target=foo)
    worker_threads.append(t)
    t.start()

for t in worker_threads:
    t.join()

with printer_lock:
    print("Finished")
```
As we can see, this code is a lot more complex than the previous one, it's not terrible, but you can probably imagine
that with a bigger codebase, this wouldn't be fun to manage.

Not to mention that there is a core issue with this code.  Even though the code will work and doesn't actually have any
bugs, it is still wrong. Why? When we use enough locks in our multi-threaded code, we may end up making it full
sequential, which is what happened here. Our code is running synchronously, with huge amount of overhead from the locks
that didn't need to be there and the actual code that would've been sufficient looks like this:
```py
counter = 0
print("Starting")
for _ in range(5)
    counter += 1
    print(f"The count is {counter}")
    print("----------------------")
print("Finished")
```
While in this particular case, it may be pretty obvious that there was no need to use threading at all, there are a lot
of cases in which it isn't as clear and I have seen some projects with code that could've been sequential but they were
already using threading for something else and so they made use of locks and added some other functionality, which made
the whole code completely sequential and they didn't even realize.

## Global Interpreter Lock in Python

As I said, this article is mainly based around the Python language, if you aren't interested in python, this part
likely won't be very relevant to you. However it is still pretty interesting to know how it works and why it isn't such
a huge issue as many claim it is. I also explain something about how threads are managed by the OS here which may be
interesting for you too.

Concurrency in python is a bit complicated because it has something called the "Global Interpreter Lock" (GIL), or at
least, that's what many people think, I actually quite like the GIL, this is what it does and why it actually isn't as
bad as many people think it is:

GIL solves the problem of needing countless locks all across the standard library. These locks would force the threads
to wait for some other thread that currently has the lock acquired which is inevitable at some places, as explained in
the above section. Removing the global lock and introducing this many smaller locks isn't even that complicated, just
time-taking, the real problem about it is that acquiring and releasing locks is expensive and takes some time, so not
only does removing GIL introduce a lot of additional complexity of dealing locks all over the standard library, it also
makes python a lot slower.

What's actually bad about GIL is the fact that it completely prevents 2 threads from being able to run parallel with
each other. 1 thread running at 1 core and 2nd thread running along the 1st one on another core. But this isn't as big
of an issue as it may sound. Even though we can't run more threads at once, i.e. there's no actual parallelism
involved, it doesn't prevent concurrency. Instead, these threads are constantly being switched around first we're at
thread 1, then thread 2, then thread 1, then back to thread 2, etc. The lock is constantly moving from one thread to
another.

But this interchanging of threads is happening in languages without any interpreter-wide lock. Every machine will have
limited amount of cores/CPUs at it's disposal and it is actually up to the OS itself to manage when a thread is
scheduled to run. The OS needs to determine the importance of each process and it's threads and decide which should run
and when. Sometimes it may happen that the OS will schedule 2 threads of the same process at once to be ran, which
wouldn't be possible with python due to GIL, but if other processes occupy the cores, every other thread on the system
is paused and waiting for the OS to start it again. This switching between the threads itself can happen at any
arbitrary instruction and we don't have control over it anyway.

So when would it make sense to even use threads if they can't run in parallel? Even though we don't have control over
when these switches happen, we do have control over when the GIL is passed, and the OS is clever enough to not schedule
in a thread that is currently waiting to acquire a lock, it will schedule to active thread that is actually doing
something. The advantage of threads is just that they can cleverly take turns to speed up the overall process. Say
you have a `time.sleep(10)` operation in one thread, we can pass the GIL over to another thread, that isn't currently
waiting and constantly check if the first thread is done yet, once it is, we can switch around between them at
arbitrary order, until again it makes more sense to run one thread over another, such as when a thread is sleeping.

## Threads vs Asynchronous run

As I explained in the last paragraph of the previous section about GIL, threads are always being interchanged for us,
we don't need any code that explicitly causes this switching, which is an advantage of threading. This interchanging
allows for some speed-ups and we don't need to worry about the switching ourselves at all!

But the cost to this convenience is that you have to assume a switch can happen at any time, this means we can hop over
to another thread after the first one finished reading data from memory, but it didn't yet store them back. This is why
we need locks. Threads switch preemptively, the system decides for us.

The limit on threads is the total CPU power we have minus the cost of task switches and synchronization overhead
(locks).

With asynchronous processing, we switch cooperatively, i.e. we use explicit code (`await` keyword in python) to cause a
task switch manually. This means that locks and other synchronization is no longer necessary. (In practice we actually
do still have locks even in async code, but they're much less common and many people don't even know about them because
they're simply not necessary in most cases)

With python's asyncio, the cost of task switches is incredibly low, because they internally use generators (awaitables)
and it is much quicker to restart a generator that stores it's all of it's state, than calling a pure python function
which has to build up a whole new stack frame on every call whereas a generator already has a stack frame and picks up
where it left off, this makes asyncio task switching the cheapest way to handle task-switching in python by far. In
comparison, you can run hundreds of threads, but tens of thousands of async tasks per second.

This makes async easier to get done than threads, and much faster and lighter-weight in comparison.
But nothing can be perfect, and async has it's downside too, one downside is that we have to perform the switches
cooperatively, so we need to add the `await` keyword to our code, but that's not very hard. The much more relevant
downside is that everything we now do has to be non-blocking. We can no longer simply read from a file, we need to
launch a task to read from a file, let it start reading and when the data is available, go back and pick it up. This
means we can't even use regular `time.sleep` anymore, instead, we need it's async alternative `await asyncio.sleep`.

This means that we need a huge ecosystem of support tools that adds the support for asynchronous alternatives to every
blocking synchronous operation, which increases the learning curve.

### Comparison

- Async maximizes CPU utilization because it has less overhead than threads
- Threading typically works with existing code and tools as long as locks are added around critical sections
- For complex systems, async is much easier to get right than threads with locks
- Threads require very little tooling (locks and queues)
- Async needs a lot of tooling (futures, event loops, non-blocking versions of everything)

## Conclusion

- If you need to run something in parallel, you will need to use multiprocessing because GIL prevents parallel threads
- If you need to run something concurrently, but not necessarily in parallel, you can either use threads or async
- Threads make more sense if you already have a huge code-base because they don't require rewriting everything to
  non-blocking versions you will just need to add some locks and queues
- Async make more sense if you know you will need concurrency from the start, since it helps to keep everything a lot
  more manageable and it's quicker than threads.
