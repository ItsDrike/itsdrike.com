---
title: Type variables in python typing
date: 2024-10-04
tags: [programming, python, typing]
sources:
  - https://mypy.readthedocs.io/en/stable/generics.html#generic-functions
  - https://docs.basedpyright.com/#/type-concepts-advanced?id=value-constrained-type-variables
  - https://dev.to/decorator_factory/typevars-explained-hmo
  - https://peps.python.org/pep-0695/
  - https://typing.readthedocs.io/en/latest/spec/generics.html
---

Python’s type hinting system offers great flexibility, and a crucial part of that flexibility comes from **Type
Variables**. These allow us to define [generic types]({{< ref "posts/generics-and-variance" >}}), enabling us to write
functions and classes that work with different types while maintaining type safety. Let’s dive into what type variables
are, how to use them effectively, and why they are useful.

_**Pre-requisites**: This article assumes that you already have a [basic knowledge of python typing]({{< ref
"posts/python-type-checking" >}})._

## What's a Type Variable

A type variable (or a `TypeVar`) is basically representing a variable type. It essentially acts as a placeholder for a
specific type within a function or a class. Instead of locking down a function to operate on a specific type, type
variables allow it to adapt to whatever type is provided.

For example:

```python
from typing import TypeVar

T = TypeVar("T")

def identity(item: T) -> T:
    """
    Return the same item that was passed in, without modifying it.
    The type of the returned item will be the same as the input type.
    """
    return item
```

In this example, `T` is a type variable, meaning that the function `identity` can take any type of argument and will return
an object of that same type. If you pass an integer, it returns an integer; if you pass a string, it returns a string.
The function adapts to the type of input while preserving the type in the output.

```python
identity(5)  # Returns 5 (int)
identity("hello")  # Returns "hello" (str)
identity([1, 2, 3])  # Returns [1, 2, 3] (list)
```

Whenever the function is called, the type-var gets "bound" to the type used in that call, that allows the type checker
to enforce the type consistency across the function with this bound type.

## Type Variables with Upper Bounds

You can also restrict a type variable to only types that are subtypes of a specific type by using the `bound` argument.
This is useful when you want to ensure that the type variable is always a subclass of a particular type.

```python
from typing import TypeVar
from collections.abc import Sequence

T = TypeVar("T", bound=Sequence)

def split_sequence(seq: T, chunks: int) -> list[T]:
    """ Split a given sequence into n equally sized chunks of itself.

    If the sequence can't be evenly split, the last chunk will contain
    the additional elements.
    """
    new = []
    chunk_size = len(seq) // chunks
    for i in range(chunks):
        start = i * chunk_size
        end = i * chunk_size + chunk_size
        if i == chunks - 1:
            # On last chunk, include all remaining elements
            new.append(seq[start:])
        else:
            new.append(seq[start:end])
    return new
```

In this example, `T` is bounded by `Sequence`, so `split_sequence` can work with any type of sequence, such as lists or
tuples. The return type will be a list with elements being slices of the original sequence, so the list items will
match the type of the input sequence, preserving it.

If you pass a `list[int]`, you'll get a `list[list[int]]`, and if you pass a `tuple[str]`, you'll get a
`list[tuple[str]]`.

## Type Variables with Specific Type Restrictions

Type variables can also be restricted to specific types, which can be useful when you want to enforce that a type
variable can only be one of a predefined set of types.

One common example is `AnyStr`, which can be either `str` or `bytes`. In fact, this type is so common that the `typing`
module actually contains it directly (`typing.AnyStr`). Here is an example of how to define this type-var:

```python
from typing import TypeVar

AnyStr = TypeVar("AnyStr", str, bytes)


def concat(x: AnyStr, y: AnyStr) -> AnyStr:
    return x + y

concat("a", "b")   # valid
concat(b"a", b"b") # valid
concat(1, 2)       # error
```

**Why not just use `Union[str, bytes]`?**

You might wonder why we don’t just use a union type, like this:

```python
from typing import Union

def concat(x: Union[str, bytes], y: Union[str, bytes]) -> Union[str, bytes]:
    return x + y
```

While this might seem similar, the key difference lies in type consistency. A Union would allow one of the variables to
be `str` while the other is `bytes`, however, combining these isn't possible, meaning this would break at runtime!

```python
concat(b"a", "b")  # No type error, but implementation fails!
```

**How about `TypeVar("T", bound=Union[str, bytes])`?**

This actually results in the same issue. The thing is, type-checkers are fairly smart and if you call `concat(b"a",
"b")`, it will use the narrowest type from that top `Union[str, bytes]` type bound when binding the type var. This
narrowest type will end up being the union itself, so the type-var will essentially become the union type, leaving you
with the same issue.

For that reason, it can sometimes be useful to use specific type restrictions with a type-var, rather than just binding
it to some common top level type.

## New TypeVar syntax

In python 3.12, it's now possible to use a new, much more convenient syntax for generics, which looks like this:

```python
def indentity[T](x: T) -> T:
  return x
```

To specify a bound for a type var like this, you can do:

```python
def car_identity[T: Car](car: T) -> T:
  return car
```

This syntax also works for generic classes:

```python
class Foo[T]:
  def __init__(self, x: T):
    self.x = x
```

## TypeVarTuple

A `TypeVarTuple` is defined similarly to a regular `TypeVar`, but it is used to represent a variable-length tuple. This
can be useful when you want to work with functions or classes that need to preserve a certain shape of tuples, or
modify it in a type-safe manner.

```python
from typing import TypeVar, TypeVarTuple, reveal_type, cast

T = TypeVar("T")
Ts = TypeVarTuple("Ts")

def tuple_append(tup: tuple[*Ts], val: T) -> tuple[*Ts, T]:
  return (*tup, val)

x = (2, "hi", 0.8)
y = tuple_append(x, 10)
reveal_type(y)  # tuple[int, str, float, int]
```

Or with the new 3.12 syntax:

```python
from typing import cast, reveal_type

def tuple_sum[*Ts](*tuples: tuple[*Ts]) -> tuple[*Ts]:
  summed = tuple(sum(tup) for tup in zip(*tuples))
  reveal_type(summed) # tuple[int, ...]
  # The type checker only knows that the sum function returns an int here, but this is way too dynamic
  # for it to understand that summed will end up being tuple[*Ts]. For that reason, we can use a cast
  return cast(tuple[*Ts], summed)

x = (10, 15, 20.0)
y = (5, 10, 15.0)
z = (1, 2, 3.2)
res = tuple_sum(x, y, z)
print(res)  # (16, 27, 38.2)
reveal_type(res)  # tuple[int, int, float]
```

## ParamSpec

In addition to `TypeVar`, Python 3.10 introduced `ParamSpec` for handling type variables related to function parameters.
Essentially, a `ParamSpec` is kind of like having multiple type-vars for all of your parameters, but stored in a single
place. It is mainly useful in function decorators:

```python
from typing import TypeVar, ParamSpec
from collections.abc import Callable

P = ParamSpec('P')
R = TypeVar('R')

def decorator(func: Callable[P, R]) -> Callable[P, R]:
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> R:
        print("Before function call")
        result = func(*args, **kwargs)
        print("After function call")
        return result
    return wrapper

@decorator
def say_hello(name: str) -> str:
    return f"Hello, {name}!"

print(say_hello("Alice"))
print(say_hello(55))  # error: 'int' type can't be assigned to parameter name of type 'str'
```

In this example, the `ParamSpec` is able to fully preserve the input parameters of the decorated function, just like
the `TypeVar` here preserves the single return type parameter.

With the new 3.12 syntax, `ParamSpec` can also be specified like this:

```python
from collections.abc import Callable

def decorator[**P, R](func: Callable[P, R]) -> Callable[P, R]:
    ...
```

### Concatenate

In many cases, `ParamSpec` is used in combination with `typing.Concatenate`, which can allow for consuming or adding
function parameters, for example by specifying: `Callable[Concatenate[int, P], str]` we limit our decorator to only
accept functions that take an int as the first argument and return a string. This also allows the decorator to remove
that argument after decoration, by specifying the return type as `Callable[P, str]`:

```python
from typing import ParamSpec, Concatenate
from collections.abc import Callable

P = ParamSpec('P')

def id_5(func: Callable[Concatenate[int, P], str]) -> Callable[P, str]:
    def wrapper(*args: P.args, **kwargs: P.kwargs) -> str:
        return func(5, *args, **kwargs)
    return wrapper

@id_5
def log_event(id: int, event: str) -> str:
    return f"Got an event on {id=}: {event}!"
```
