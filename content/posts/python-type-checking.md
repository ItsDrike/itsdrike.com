---
title: A guide to type checking in python
date: 2024-10-04
tags: [programming, python, typing]
sources:
  - https://dev.to/decorator_factory/type-hints-in-python-tutorial-3pel
  - https://docs.basedpyright.com/#/type-concepts
  - https://mypy.readthedocs.io/en/stable/
  - https://typing.readthedocs.io/en/latest/spec/special-types.html
---

Python is often known for its dynamic typing, which can be a drawback for those who prefer static typing due to its
benefits in catching bugs early and enhancing editor support. However, what many people don't know is that Python does
actually support specifying the types and it is even possible to enforce these types and work in a statically
type-checked Python environment. This article is an introduction to using Python in this way.

## Regular python

In regular python, you might end up writing a function like this:

```python
def add(x, y):
  return x + y
```

In this code, you have no idea what the type of `x` and `y` arguments should be. So, even though you may have intended
for this function to only work with numbers (ints), it's actually entirely possible to use it with something else. For
example, running `add("hello", "world)` will return `"helloworld"` because the `+` operator works on strings too.

The point is, there's nothing telling you what the type of these parameters should be, and that could lead to
misunderstandings. Even though in some cases, you can judge what the type of these variables should be just based on
the name of that function, in most cases, it's not that easy to figure out and often requires looking through docs, or
just going over the code of that function.

Annoyingly, python doesn't even prevent you from passing in types that are definitely incorrect, like: `add(1, "hi")`.
Running this would cause a `TypeError`, but unless you have unit-tests that actually run that code, you won't find out
about this bug until it actually causes an issue and at that point, it might already be too late, since your code has
crashed a production app.

Clearly then, this isn't ideal.

## Type-hints

While python doesn't require it, it does have support for specifying "hints" that indicate what type should a given
variable have. So, when we take a look at the function above, adding type-hints to it would look like this:

```python
def add(x: int, y: int) -> int:
  return x + y
```

We've now made the types very explicit to the programmer, which means they'll no longer need to spend a bunch of time
looking through the implementation of that function, or going through the documentation just to know how to use this
function. Instead, the type hints will tell just you.

This is incredibly useful, because most editors will be able to pick up these type hints, and show them to you while
calling the function, so you know what to pass right away, without even having to look at the function definition where
the type-hints are defined.

Not only that, specifying a type-hint will greatly improve the development experience in your editor / IDE, because
you'll get much better auto-completion. The thing is, if you have a parameter like `x`, but your editor doesn't know
what type it should have, it can't really help you if you start typing `x.remove`, looking for the `removeprefix`
function. However, if you tell your editor that `x` is a string (`x: str`), it will now be able to go through all of
the methods that strings have, and show you those that start with `remove` (being `removeprefix` and `removesuffix`).

This makes type-hints great at saving you time while developing, even though you have to do some additional work when
specifying them.

## Run-time behavior

Even though type-hints are a part of the Python language, the Python interpreter doesn't actually care about them. That
means that there isn't any optimizations or checking performed when you're running your code, so even with type hints
specified, they will not be enforced! This means that you can actually just choose to ignore them, and call the
function with incorrect types, like: `add(1, "hi")` without it causing any immediate runtime errors.

Most editors are configured very loosely when it comes to type-hints. That means they will show you these hints when
you're working with the function, but they won't produce warnings. That's why they're called "type hints", they're only
hints that can help you out, but they aren't actually enforced.

## Static type checking tools

Even though python on it's own indeed doesn't enforce the type-hints you specify, there are tools that can run static
checks against your code to check for type correctness.

{{< notice tip >}}
A static check is a check that works with your code in it's textual form. It will read the contents of your python
files without actually running that file and analyze it purely based on that text content.
{{< /notice >}}

Using these tools will allow you to analyze your code for typing mistakes before you ever even run your program. That
means having a function call like `add(1, "hi")` anywhere in your code would be detected and reported as an issue. This
is very similar to running a linter like [`flake8`](https://flake8.pycqa.org/en/latest/) or
[`ruff`](https://docs.astral.sh/ruff/).

Since running the type-checker manually could be quite annoying, so most of them have integrations with editors / IDEs,
which will allow you to see these errors immediately as you code. This makes it much easier to immediately notice any
type inconsistencies, which can help you catch or avoid a whole bunch of bugs.

### Most commonly used type checkers

- [**Pyright**](https://github.com/microsoft/pyright): Known for its speed and powerful features, it's written in
  TypeScript and maintained by Microsoft.
- [**MyPy**](https://mypy.readthedocs.io/en/stable/): The most widely used type-checker, developed by the official
  Python community. It's well integrated with most IDEs and tools, but it's known to be slow to adapt new features.
- [**PyType**](https://google.github.io/pytype/): Focuses on automatic type inference, making it suitable for codebases
  with minimal type annotations.
- [**BasedPyright**](https://docs.basedpyright.com/): A fork of pyright with some additional features and enhancements,
  my personal preference.

## When to use type hints?

Like you saw before with the `add` function, you can specify type-hints on functions, which allows you to describe what
types can be passed as parameters of that function alongside with specifying a return-type:

```python
def add(x: int, y: int) -> int:
  ...
```

You can also add type-hints directly to variables:

```python
my_variable: str = "hello"
```

That said, doing this is usually not necessary, since most type-checkers can "infer" what the type of `my_variable`
should be, based on the value it's set to have. However, in some cases, it can be worth adding the annotation, as the
inference might not be sufficient. Let's consider the following example:

```python
my_list = []
```

In here, a type-checker can infer that this is a `list`, but they can't recognize what kind of elements will this list
contain. That makes it worth it to specify a more specific type:

```python
my_list: list[int] = []
```

Now the type-checker will recognize that the elements inside of this list will be integers.

## Special types

While in most cases, it's fairly easy to annotate something with the usual types, like `int`, `str`, `list`, `set`, ...
in some cases, you might need some special types to represent certain types.

### None

This isn't very special at all, but it may be surprising for beginners at first. You've probably seen the `None` type
in python before, but what you may not realize is that if you don't add any return statements into your function, it
will automatically return a `None` value. That means if your function doesn't return anything, you should annotate it
as returning `None`:

```python
def my_func() -> None:
    print("I'm a simple function, I just print something, but I don't explicitly return anything")


x = my_func()
assert x is None
```

### Union

A union type is a way to specify that a type can be one of multiple specified types, allowing flexibility while still
enforcing type safety.

There are multiple ways to specify a Union type. In modern versions of python (3.10+), you can do it like so:

```python
x: int | str = "string"
```

If you need to support older python versions, you can also using `typing.Union`, like so:

```python
from typing import Union

x: Union[int, str] = "string"
```

As an example this function takes a value that can be of various types, and parses it into a bool:

```python
def parse_bool_setting(value: str | int | bool) -> bool:
    if isinstance(value, bool):
        return value

    if isinstance(value, int):
      if value == 0:
          return False
      if value == 1:
          return True
      raise ValueError(f"Value {value} can't be converted to boolean")

    # value can only be str now
    if value.lower() in {"yes", "1", "true"}:
        return True
    if value.lower() in {"no", "0", "false"}:
        return False
    raise ValueError(f"Value {value} can't be converted to boolean")
```

One cool thing to notice here is that after the `isinstance` check, the type-checker will narrow down the type, so that
when inside of the block, it knows what type `value` has, but also outside of the block, the type-checker can narrow
the entire union and remove one of the variants since it was already handled. That's why at the end, we didn't need the
last `isinstance` check, the type checker knew the value was a string, because all the other options were already
handled.

### Any

In some cases, you might want to specify that your function can take in any type. This can be useful when annotating a
specific type could be way too complex / impossible, or you're working with something dynamic where you just don't care
about the typing information.

```python
from typing import Any

def foo(x: Any) -> None:
    # a type checker won't warn you about accessing unknown attributes on Any types,
    # it will just blindly allow anything
    print(x.foobar)
```

{{< notice warning >}}
Don't over-use `Any` though, in vast majority of cases, it is not the right choice. I will touch more on it in the
section below, on using the `object` type.
{{< /notice >}}

The most appropriate use for the `Any` type is when you're returning some dynamic value from a function, where the
developer can confidently know what the type will be, but which is impossible for the type-checker to figure out,
because of the dynamic nature. For example:

```python
from typing import Any

global_state = {}

def get_state_variable(name: str) -> Any:
    return global_state[name]


global_state["name"] = "Ian"
global_state["surname"] = "McKellen"
global_state["age"] = 85


###


# Notice that we specified the annotation here manually, so that the type-checker will know
# what type we're working with. But we only know this type because we know what we stored in
# our dynamic state, so the function itself can't know what type to give us
full_name: str = get_state_variable("name") + " " + get_state_variable("surname")
```

### object

In many cases where you don't care about what type is passed in, people mistakenly use `typing.Any` when they should
use `object` instead. Object is a class that every other class subclasses. That means every value is an `object`.

The difference between doing `x: object` and `x: Any` is that with `Any`, the type-checker will essentially avoid
performing any checks whatsoever. That will mean that you can do whatever you want with such a variable, like access a
parameter that might not exist (`y = x.foobar`) and since the type-checker doesn't know about it, `y` will now also be
considered as `Any`. With `object`, even though you can still assign any value to such a variable, the type checker
will now only allow you to access attributes that are shared to all objects in python. That way, you can make sure that
you don't do something that not all types support, when your function is expected to work with all types.

For example:

```python
def do_stuff(x: object) -> None:
    print(f"The do_stuff function is now working with: {x}")

    if isinstance(x, str):
        # We can still narrow the type down to a more specific type, now the type-checker
        # knows `x` is a string, and we can do some more things, that strings support, like:
        print(x.removeprefix("hello"))

    if x > 5:  # A type-checker will mark this as an error, because not all types support comparison against ints
        print("It's bigger than 5")
```

### Collection types

Python also provides some types to represent various collections. We've already seen the built-in `list` collection
type before. Another such built-in collection types are `tuple`, `set`, `forzenset` and `dict`. All of these types are
what we call "generic", which means that we can specify an internal type, which in this case represents the items that
these collections can hold, like `list[int]`.

Here's a quick example of using these generic collection types:

```python
def print_items(lst: list[str]) -> None:
    for index, item in enumerate(lst):
        # The type-checker knows `item` variable is a string now
        print(f"-> Item #{index}: {item.strip()}")

print_items(["hi", "  hello ", "hey   "])
```

That said, in many cases, instead of using these specific collection types, you can use a less specific collection, so
that your function will work with multiple kinds of collections. Python has abstract classes for general collections
inside of the `collections.abc` module. One example would be the `Sequence` type:

```python
from collections.abc import Sequence

def print_items2(lst: Sequence[str]) -> None:
    for index, item in enumerate(lst):
        # The type-checker knows `item` variable is a string now
        print(f"Item #{index}: {item.strip()}")

print_items(["a", "b", "c"]) # fine
print_items(("a", "b", "c")) # nope

print_items2(["a", "b", "c"]) # works
print_items2(("a", "b", "c")) # works
print_items2({"a", "b", "c"}) # works
```

You may think that you could also just use a union like: `list[str] | set[str] | tuple[str, ...]`, however that still
wouldn't quite cover everything, since people can actually make their own custom classes that have `__getitem__` and
work like a sequence, yet doesn't inherit from `list` or any of the other built-in types. By specifying
`collections.abc.Sequence` type-hint, even these custom classes that behave like sequences will work with your function.

There are various other collections classes like these and it would take pretty long to explain them all here, so you
should do some research on them on your own to know what's available.

{{< notice warning >}}
It is important to note that the built-in collection types like `list` weren't subscriptable in earlier versions of
python (before 3.9). If you still need to maintain compatibility with such older python versions, you can instead use
`typing.List`, `typing.Tuple`, `typing.Set` and `typing.Dict`. These types will support being subscripted even in those
older versions.

Similarly, this also applies to the `collections.abc` abstract types, like `Sequence`, which also wasn't subscriptable
in these python versions. These also have alternatives in `typing` module: `typing.Sequence`, `typing.Mapping`,
`typing.MutableSequence`, `typing.Iterable`, ...
{{< /notice >}}

#### Tuple type

Python tuples are a bit more complicated than the other collection types, since we can specify which type is at which
position of the tuple. For example: `tuple[int, str, float]` will represent a tuple like: `(1, "hi", 5.3)`. The tricky
thing here is that specifying `tuple[int]` will not mean a tuple of integers, it will mean a tuple with a single
integer: `(1, )`. If you do need to specify a tuple with any amount of items of the same type, what you actually need
to do is: `tuple[int, ...]`. This annotation will work for `(1, )` or `(1, 1, 1)` or `(1, 1, 1, 1, 1)`.

The reason for this is that we often use tuples to allow returning multiple values from a function. Yet these values
usually don't have the same type, so it's very useful to be able to specify these types individually:

```python
def some_func() -> tuple[int, str]:
    return 1, "hello"
```

That said, a tuple can also be useful as a sequence type, with the major difference between it and a list being that
tuples are immutable. This can make them more appropriate for storing certain sequences than lists.

## Type casts

Casting is a way to explicitly specify the type of a variable, overriding the type inferred by the type-checker.

This can be very useful, as sometimes, we programmers have more information than the type-checker does, especially when
it comes to some dynamic logic that is hard to statically evaluate. The type checker's inference may end up being too
broad or sometimes even incorrect.

For example:

```python
from typing import cast

my_list: list[str | int] = []
my_list.append("Foo")
my_list.append(10)
my_list.append("Bar")

# We know that the first item in the list is a string
# the type-checker would otherwise infer `x: str | int`
x = cast(str, my_list[0])
```

Another example:

```python
from typing import cast

def foo(obj: object, type_name: str) -> None:
    if type_name == "int":
        obj = cast(int, obj)
        ...  # some logic
    elif type_name == "str":
        obj = cast(str, obj)
        ...  # some logic
    else:
        raise ValueError(f"Unknown type name: {type_name}")
```

{{< notice warning >}}
It is important to mention that unlike the casts in languages like Java or C#, in Python, type casts do not perform any
runtime checks to ensure that the variable really is what we claim it to be. Casts are only used as a hint to the
type-checker, and on runtime, the `cast` function just returns the value back without any extra logic.

If you do wish to also perform a runtime check, you can use assertions to narrow the type:

```python
def foo(obj: object) -> None:
    print(obj + 1)  # can't add 'object' and 'int'
    assert isinstance(obj, int)
    print(obj + 1)  # works
```

Alternatively, you can just check with if statements:

```python
def foo(obj: object) -> None:
    print(obj + 1)  # can't add 'object' and 'int'
    if not isinstance(obj, int):
        raise TypeError("Expected int")
    print(obj + 1)  # works
```

{{< /notice >}}

## Closing notes

In summary, Python’s type hints are a powerful tool for improving code clarity, reliability, and development
experience. By adding type annotations to your functions and variables, you provide valuable information to both your
IDE and fellow developers, helping to catch potential bugs early and facilitating easier code maintenance.

Type hints offer significant benefits:

- Enhanced Readability: Clearly specifies the expected types of function parameters and return values, making the code
  more self-documenting.
- Improved Development Experience: Provides better auto-completion and in-editor type checking, helping you avoid
  errors and speeding up development.
- Early Error Detection: Static type checkers can catch type-related issues before runtime, reducing the risk of bugs
  making it into production.

For further exploration of Python’s type hints and their applications, you can refer to additional resources such as:

- The [Type Hinting Cheat Sheet](https://mypy.readthedocs.io/en/stable/cheat_sheet_py3.html) from mypy for a quick
  reference on various type hints and their usage.
- My other articles on more advanced typing topics like [TypeVars]({{< ref "posts/type-vars" >}}) and [Generics]({{< ref
  "posts/generics-and-variance" >}}) for deeper insights into Python's typing system.

Embracing type hints can elevate your Python programming experience, making your code more robust and maintainable in
the long run.
