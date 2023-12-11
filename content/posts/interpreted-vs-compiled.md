---
title: Interpreted vs Compiled Languages
date: 2021-09-09
tags: [programming]
---

You've likely seen or heard someone talking about a language as being interpreted or as being a compiled language, but
what's the difference? When should you pick one or the other when deciding which language to use for your projects and
does it even matter? I'll do my best to explain how they differ and the advantages of either.

## History

At first, I want to explain how the languages evolved and what were the steps to even getting to something like a
compiled languages. How did we write the first programs when we didn't have any compiler, not to mention an
interpreter.

### First programs

In the beginning of the computational era, we had to use what's called a machine code, that was fed into the CPU. It
contained the individual precise instructions telling the CPU what it should be doing. Each instruction meant some
operation, for example there is an instruction for adding numbers together, or subtracting them, so on and so on.

While this is amazing for the CPU, humans can't intuitively write a program in a language like this, which is why
programming was very difficult in the early days. Programmers had to first work out the whole process of what the
program will be doing, and only then even start to think about how can they implement it purely with these
instructions. And after that was done, they had to look up the binary representations for each of the instructions
they've used and manually convert their write-up of these individual instructions into a sequence of binary data that
was then fed into the computer and CPU was able to execute these individual instructions.

### A more modern approach

Obviously, we wanted to make things easier for ourselves by automating and abstracting as many things in the
programming process as we could, so that the programmer could really only focus on the algorithm itself and the actual
conversion of the code to a machine code that the CPU can deal with should simply happen in the background.

But how could we achieve something like this? The simple answer is, to write something that will be able to take our
code and convert it into a set of instructions that the CPU will be running. This intermediate piece of code can either
be a compiler, or an interpreter.

After a piece of software like this was first written, suddenly everything became much easier, initially we were using
assembly languages that were very similar to the machine code, but they looked a bit more readable, while the
programmer still had to think in the terms of what instruction should the CPU get in order to get it to do the required
thing, the actual process of converting this code into a machine code was done automatically. The programmer just took
the text of the program in the assembly language, fed it into the computer and it returned a whole machine code.

Later on we went deeper and deeper and eventually got to a very famous language called C. This language was incredibly
versatile and allowed the programmers to finally start thinking in a bit more natural way about how should the program
be written and the tedious logic of converting this textual C implementation into something executable was left to the
compiler to deal with.

### Recap

So we now now that initially, we didn't have neither the compiler nor an interpreted and we simply wrote things in
machine code. But this was very tedious and time taking, so we wrote a piece of software (in machine code) that was
able to take our more high-level (english-like) text and convert that into this executable machine code.

## Compiled languages

All code that's written with a language that's supposed to be compiled has a piece of software called the "compiler".
This piece of software is what carries the internal logic of how to convert these instructions that followed some
language-specific syntax rules into the actual machine code, giving that us back the actual machine code.

This means that once we write our code in a compiled language, we can use the compiler to get an executable version of
our program which we can then distribute to others.

However this executable version will be specific to certain CPU architecture and if someone with a different
architecture were to obtain it, he wouldn't be able to run it. (At least not without emulation, which is a process of
simulating a different CPU architecture and running the corresponding instruction that the simulated CPU gets with an
equivalent instructions on the other architecture, even though this is a possibility, the process of emulation causes
significant slowdowns, and because we only got the executable machine code rather than the actual source-code, we can't
re-compile the program our-selves so that it would run natively for our architecture)

Some of the most famous compiled languages are: C, C++, Rust

## Interpreted Languages

Similarly to how code for compiled languages needs a compiler, interpreted languages need an interpreter. But there is
a major difference between these 2 implementations.

With interpreted languages, rather than feeding the whole source code into a compiler and getting a machine code out of
it that we can run directly, we instead feed the code into an interpreter, which is a piece of software that's already
compiled (or is also interpreted and other interpreter handles it) and this interpreter scans the code and goes line by
line and interprets each function/instruction that's than ran from within the interpreter. We can think of it as a huge
switch statement with all of the possible instructions in an interpreted language defined in it. Once we hit some
instruction, the code from inside of that switch statement is executed.

This means that with an interpreted language, we don't have any final result that is an executable file that can be
distributed alone, but rather we simply ship the code itself. However this brings it's own problems such as the fact
that each machine that would want to run such code have to have the interpreter installed, in order to "interpret" the
instructions written in that language. We also sometimes call these "scripting languages"

Some of the most famous interpreted languages are: PHP, JavaScript

## Core differences

As mentioned, with a compiled language, the source code is private and we can simply only distribute the compiled
version, whereas with an interpreted language this is completely impossible since we need the source code because
that's what's actually being ran by the interpreter, instruction after instruction. The best we can do if we really
wanted to hide the source-code with an interpreted language is to obfuscate it.

Compiled languages will also have a speed benefit to them, because they don't need additional program to interpret the
instruction within that language, but rather needs to go through an additional step of identifying the instructions and
running the code for them. Compilers often also perform certain optimizations, for example with code that would always
result in a same thing, something like `a = 10 * 120`, we could compile it and only store the result `1200`, running
the actual equation at compile time, making the running time faster.

So far it would look like compiled languages are a lot better than interpreted, but they do have many disadvantages to
them as well. One of which I've already mention, that is not being cross-platform. Once a program is compiled, it will
only ever run on the platform it was compiled for. If the compilation was happening directly to a machine code, this
would mean it would be architecture-specific.

But we usually don't do this and rather compile for something kernel-specific, because we are running under some
specific operating system that uses some kernel. The kernel is basically acting as a big interpreter for every single
program. We do this because this means that we can implement some security measures that for example disallow untrusted
programs to read or write to a memory location that doesn't belong to that program.

This alone is a pretty big disadvantage, because we will need to compile our program for every operating system it is
expected to be ran on. In the case of an interpreted language, all we need to do is have the actual interpreter to be
executable on all platforms, but the individual programs made with that language can then be ran on any platform, as
long as it has the interpreter.

From this example, we can also see another reason why we may want to use an interpreter, that is the kernel itself,
with it we can implement these security measures and somewhat restrict parts of what can be done, this is very crucial
to having a secure operating system.

Another advantage of interpreted languages is the simple fact that they don't need to be compiled, it's one less step
in the process of distributing the application and it also means that it's much easier to write automated tests for,
and for debugging in general.

## Hybrid languages

You may notice that I haven't included my favorite language, which is `Python` in the most famous interpreted
languages section, and I had a good reason not to, which is that contrary to popular belief, python actually isn't an
interpreted language, well at least not entirely.

There is another type of doing this, that's somewhere in the middle. Instead of the compile model where all the work is
done up-front, that's a bit inflexible, or the interpreted model, where all work is done on the receiving end, but is a
bit slower, we kind of combine things and do both.

Up-front, we compile it partially, to what's known as byte-code, or intermediate language. This takes things as close
to being compiled as we can, while still being portable across many platforms, and we then distribute this byte-code
rather than the full source-code and each person who runs it does the last step of taking it to machine code by running
this byte-code with an interpreter. This is also known as Just In Time (JIT) compilation.

Most languages tend to only be one or the other, but there are a fair few that follow this hybrid implementation, most
notably, these are: Java, C#, Python, VB.NET
