---
title: Interpreted vs Compiled Languages
date: 2021-09-09
lastmod: 2024-06-05
tags: [programming]
changelog:
  2024-06-05:
    - Improve wording
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

But how could we achieve something like this? The simple answer is to write something that will be able to take our
code and convert it into a set of instructions that the CPU will be running. This intermediate piece of code can either
be a compiler, or an interpreter.

After a piece of software like this was first written, suddenly everything became much easier. Initially we were using
assembly languages that were very similar to the machine code, but they looked a bit more readable, giving actual names
to the individual CPU instructions (opcodes), and allowed defining symbols (constants) and markers for code positions.
So, while the programmer still had to think in the terms of what instruction should the CPU get in order to get it to
do the required thing, the actual process of writing this code was a lot simpler, as you didn't have to constantly look
at a table just to find the number of the opcode you wanted to use, and instead, you just wrote something like `LDA
$50` (load the value at the memory address 0x50 into the accumulator register), instead of `0C50`, assuming `0C` was
the byte representing `LDA` opcode.

Since converting this assembly code into a machine code was done automatically. The programmer just took the text of
the program in the assembly language, fed it into the compiler and it returned the actual machine code, which could
then be understood by the CPU.

Later on we went deeper and deeper and eventually got to a very famous language called C. This language was incredibly
versatile and allowed the programmers to finally start thinking in a bit more natural way, one with named variables,
functions, loops, and a bunch of other helpful abstractions. All the while the tedious logic of converting this textual
C implementation into something executable was left for the compiler to deal with.

### Recap

So we now know that initially, we didn't have neither the compiler nor an interpreted and we simply wrote things in
machine code. But this was very tedious and time taking, so we wrote a piece of software (in machine code) that was
able to take our more high-level (english-like) text and convert that into this executable machine code.

## Compiled languages

All code that's written with a language that's supposed to be compiled has a piece of software called the "compiler".
This piece of software is what carries the internal logic of converting these instructions that followed some
language-specific syntax rules into the actual machine code, giving that us back an executable program.

However this executable version will be specific to certain CPU architecture. This is because each architecture has
their own set of instructions, with different opcodes, registers, etc. So if someone with a different architecture were
to obtain it, they still wouldn't be able to run it, simply because the CPU wouldn't understand those machine code
instructions.

Some of the most famous compiled languages are: C, C++, Rust, Zig

## Interpreted Languages

Similarly to how code for compiled languages needs a compiler, interpreted languages need an interpreter. But there is
a major difference between these 2 implementations.

With interpreted languages, rather than feeding the whole source code into a compiler and getting a machine code out of
it that we can run directly, we instead feed the code into an interpreter, which is a piece of software that's already
compiled (or is also interpreted and other interpreter handles it - _interpreterception_) and this interpreter scans
the code and goes line by line and interprets each function/instruction. We can think of it as a huge switch statement
with all of the possible instructions of the interpreted language defined in it. Once we hit some instruction, the code
from inside of that switch statement's case is executed.

This means that with an interpreted language, we don't have any final result that is an executable file, which could be
distributed on it's own, but rather we simply ship the code itself. To run it, the client is then expected to
install the interpreter program, compiled for their machine, run it, and feed it the code we shipped.

Some of the most famous interpreted languages are: PHP, JavaScript

{{< notice tip >}}
Remember how I mentioned that when a program (written in a compiled language) is compiled, it will only be possible to
run it on the architecture it was compiled for? Well, that's not necessarily entirely correct.

It is actually possible to run a program compiled for a different CPU architecture, by using **emulation**.

Emulation is a process of literally simulating a different CPU. It is a program which takes in the machine instructions
as it's input, and processes those instructions as if it was a CPU, setting the appropriate internal registers (often
represented as variables), keeping track of memory, and a whole bunch of other things. This program is then compiled
for your CPU architecture, so that it can run on your machine. This is what's called an **Emulator**.

With an emulator, we can simply feed it the compiled program for the CPU it emulates, and it will do exactly what a
real CPU would do, running this program.

That said, emulators are usually very slow, as they're programs which run on a real CPU, having to keep track of the
registers, memory, and a bunch of other things inside of itself, rather than inside the actual physical CPU we're
running on, as our CPU might not even have such a register/opcode, so it needs to execute a bunch of native
instructions to execute just the single foreign instruction.

Notice that an emulator is actually an interpreter, making compiled machine code for another CPU it's interpreted
language!
{{< /notice >}}

## Compilation for operating systems

So far, we only talked about compiled languages that output machine code, specific to some CPU architecture. However in
vast majority of cases, that's not actually what the compiler will output anymore (at least not entirely).

Nowadays, we usually don't make programs that run on their own. Instead, we're working under a specific operating
system, which then potentially handles a whole bunch of programs running inside of it. All of these operating systems
contain something called a "kernel", which is the core part of that system, which contains a bunch of so called
"syscalls".

Syscalls are basically small functons that the kernel exposes for us. These are things like opening and reading a file,
creating a network socket, etc. These syscalls are incredibly useful, as the kernel contains the logic (drivers) for a
whole bunch of different hardware devices (such as network cards, audio speakers/microphones, screens, keyboards, ...),
and the syscalls it exposes are an abstraction, that gives us the same kind of interface for each device of a certain
type (i.e. every speaker will be able to output a tone at some frequency), which we can utilize, without having to care
about exactly how that specific device works (different speakers might need different voltages sent to them to produce
the requested frequency).

For this reason, programs running under an OS will take advantage of this, and instead of outputting pure machine code,
they output an executable file, in a OS-specific format (such as an .exe on Windows, or an ELF file on Linux). The
instructions in this file will then also contain a special "SYSCALL" instruction, which the kernel will respond to and
run the appropriate function.

This however makes the outputted executable not only CPU architecture dependant, but also OS dependant, making it even
less portable across various platforms.

## Core differences

Compiled languages will have almost always have speed benefit to them, because they don't need additional program to
interpret the instruction within that language when being ran, instead, this program is ran by the programmer only
once, producing an executable that can run on it's own.

Compilers often also perform certain optimizations, for example, if they find code that would always result in a same
thing, like say: `a = 10 * 120`, we could do this calculation in the compiler, and only store the result `1200`,
into the final program, making the run-time faster.

Yet another advantage of compiled languages is that the original source code can be kept private, since we can simply
only distribute the pre-compiled binaries. At most, people can look at the resulting machine code, which is however
very hard to understand. In comparison, an interpreted language needs the interpreter to read the code to run it, which
means when distributing, we would have to provide the full source-code. The best we can do if we really wanted to hide
what the code is doing is to obfuscate it.

So far it would look like compiled languages are a lot better than interpreted, but they do have a significant
disadvantage to them as well. One of which that I've already mentioned is not being cross-platform. Once a program is
compiled, it will only be runnable on the platform it was compiled for. That is, not only on the same CPU architecture,
but also only on the same operating system, meaning we'll need to be compiling for every os on every architecture.

The process of compiling for all of these various platforms might not be easy, as cross-compiling (the process of
compiling for a program for different CPU architecture than that which you compile on) is often hard to set up, or even
impossible because the tooling simply isn't available on your platform. So you may need to actually get a machine
running on the platform you want to compile for, and do so directly on it, which is very tedious.

However with an interpreted language, the same code will run on any platform, as long as the interpreter itself is
available (compiled) for that platform. This means rather than having to distribute dozens of versions for every single
platform, it would be enough to ship out the source code itself, and it will run (almost) anywhere.

Interpreted languages are also usually a bit easier to write, as they can afford to be a bit more dynamic. For example,
in C, we need to know exactly how big a number can get, and choose the appropriate number type (int, long, long long,
short, not to mention all of these can be signed/unsigned), so that the compiler can work with this information and do
some optimizations based on it, however in an interpreted language, a number can often grow dynamically, sort of like a
vector, taking up more memory as needed. (It would be possible to achieve the same in a compiled language, but it would
be at an expense of a bunch of optimizations that the compiler wouldn't be able to do anymore, so it's usually not done).

## Hybrid languages

You may notice that I haven't included my favorite language, which is `Python` in the most famous interpreted
languages section, and I had a good reason not to, which is that contrary to popular belief, python actually isn't an
interpreted language, well at least not entirely.

There is another type of doing this, that's somewhere in the middle. Instead of the compile model where all the work is
done up-front, that's a bit inflexible, or the interpreted model, where all work is done on the receiving end, but is a
bit slower, we kind of combine things and do both.

Up-front, we compile it partially, to what's known as byte-code, or intermediate language. This takes things as close
to being compiled as we can, while still being portable across many platforms. We can then make some optimizations to
this byte-code, just like a regular compiler might, though usually this won't be nowhere near as powerful, because the
byte-code is still pretty abstract.

Once we get our byte-code (optimized, or not), there are 2 options of what happens next:

### Byte code interpreter

The first option is that the language has an interpreter program, which takes in this byte-code, and runs it from that.
If this is the case, a program in such language could be distributed as this byte-code, instead of as pure source-code,
as a way to keep the source-code private. While this byte-code will be easier to understand than pure machine code if
someone were to attempt to reverse-engineer it, it is still a better option than having to ship the real source-code.

This therefore combines the advantages of an interpreted language, of being able to run anywhere, with those of a
compiled language, of not having to ship the plaintext source-code, and of doing some optimizations, to minimize the
run-time of the code.

Examples of languages like these are: Python, ...

Most languages tend to only be one or the other, but there are a fair few that follow this hybrid implementation, most
notably, these are: Java, C#, Python, VB.NET

### Byte code in compiled languages

As a second option,

The approach of generating byte-code isn't unique to hybrid languages though. Even pure compiled languages actually
often generate byte-code first, and then let the compiler compile this byte-code, rather than going directly from
source code to machine code.

This is actually very beneficial, because it means multiple vastly different languages, like C/C++ and Rust can end up
being first compiled into the same kind of byte-code, which is then fed into yet another compiler, a great example of
this is LLVM, which then finally compiles it into the machine code. But many languages have their own JIT.

The reason languages often like to use this approach is that they can rely on a well established compiler, like LLVM,
to do a bunch of complex optimizations of their code, or compilation for different architectures, without having to
write out their own logic to do so. Instead, all they have to write is a much smaller compiler that turns their
language into LLVM compatible byte-code, and let it deal with optimizing the rest.
