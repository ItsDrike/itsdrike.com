---
title: Typing generics (covariance, contravariance and invariance)
date: 2021-10-04
tags: [programming]
---

In many programming languages where typing matters we often need to define certain properties for some types so that
they can work properly. Specifically, when we use a sequence of certain types, say of type x that is a child class of
an integer, can that sequence also contain pure integers? This conception is known as contravariance. There's also a bit
more commonly used one where if we have say a sequence of integers, can it contain elements of the type x, that has
the integer class as a parent? This one is known as covariance.

It can often be very hard to distinguish these and to really understand which is which. In this post, I'll do my best to
try and explain these concepts with some examples so that it'll be a bit easier to understand what it means when someone
says that an immutable sequence is covariant in the element type while a mutable sequence is invariant in the element
type.

For simplicity, I'll be using python in the examples, even though python isn't a strictly typed language, because of
tools such as mypy, pyright or many others, python does have optional support for typing that can even be checked for on
compiler level by using these tools. However here I'll just be using simple type-hints to explain these concepts.

Do note that this post is a bit more advanced than the other ones I made and if you don't already feel comfortable with
using type-hints in python, it may not be very clear what's going on in here so I'd suggest learning something about
python type-hints before reading this.

## Generic Types

In order to easily explain these concepts, you'll first need to understand what is a generic type. There is a lot that
I could talk about here, but essentially, it defines that something inside of our generic type is of some other type.
A good example would be for example a list of integers: `list[int]` (or in older python versions: `typing.List[int]`).
We've specified that our list will only be holding elements of `int` type.

Generics like this can be used for many things, for example with a dict, we actually provide 2 types, first is the type
of the keys and second is the type of the values: `dict[str, int]` would be a dict with `str` keys and `int` values.

Here's a list of some of the generic types that are currently present in python 3.9:

| Type              | Description                                 |
|-------------------|---------------------------------------------|
| list[str]         | List of `str` objects                       |
| tuple[int, int]   | Tuple of two `int` objects                  |
| tuple[int, ...]   | Tuple of arbitrary number of `int`          |
| dict[str, int]    | Dictionary with `str` keys and `int` values |
| Iterable[int]     | Iterable object containing ints             |
| Sequence[bool]    | Sequence of booleans (immutable)            |
| Mapping[str, int] | Mapping from `str` keys to `int` values     |


In python, we can even make up our own generics with the help of `typing_extensions.Protocol`:

```py
from typing import TypeVar
from typing_extensions import Protocol

T = TypeVar("T")

# If we specify a type-hint for our building like Building[Student]
# It will be a building with an attribute inhabitants of tyle list[Student]
class Building(Protocol[T]):
    inhabitants: list[T]
```

We'll look into creating our own generics after we learn the differences between covariance, contravariance and invariance.

## Covariance

As I've very quickly explained above, covariance is a concept where if we have a generic of some type, we can
assign it to a generic type of some subtype.

I know that this definition can sound really complicated, but it's not that bad. As an example, I'll use a `tuple`,
which is an immutable sequence in python. If we have a tuple of `Car` type and a tuple of `WolkswagenCar` (
`WolkswagenCar` being a subclass of `Car`), we can assign this tuple of a subtype (`WolkswagenCar`) to a tuple of the
supertype (`Car`), because every `WolkswagenCar` is also a `Car`.

```py
from typing import Tuple

class Car: ...
class WolkswagenCar(Car): ...

my_generic_car_1 = Car()
my_generic_car_2 = Car()
my_wolkswagen_car_1 = WolkswagenCar()
my_wolkswagen_car_2 = WolkswagenCar()

cars: Tuple[Car, ...] = (my_generic_car_1, my_generic_car_2)
wolkswagen_cars: Tuple[WolkswagenCar, ...] = (my_wolkswagen_car_1, my_wolkswagen_car_2)

# This assignment sets Tuple[Car, ...] to Tuple[WolkswagenCar, ...]
# this makes sense because a tuple of cars can hold wolkswagen cars
# since they're also cars
wolkswagen_cars = cars

# Assuming the above statement didn't happen, in this statement we
# try to assign a Tuple[WolkswagenCar, ...] to a Tuple[Car, ...]
# this however doesn't make sense because wolkswagen cars can have some
# additional functionality that regular cars don't have, so a type checker
# would raise an error in this case
cars = wolkswagen_cars
```

Another example of a covariant type would be the return value of a `Callable`. In python, the `typing.Callable` type is
initialized like `Callable[[argument_type1, argument_type2], return_type]`. In this case, the return type for our
function is also covariant, because we can return a more specific type (subtype) as a return type, since it will be
fully compatible with the less specific type (supertype).

```py
def buy_car() -> Car:
    # The type of this function is Callable[[], Car]
    return Car()

def buy_wolkswagen_car() -> WolkswagenCar:
    # The type of this function is Callable[[], WolkswagenCar]
    return WolkswagenCar()


some_car: Car = buy_car()

# A type of some_car is Car, which means we can safely swap the buy_car() function
# for a more specific buy_wolkswagen_car() function, since it also returns a Car,
# except in that case, it's a bit more specific car, however it has all of the
# features of our generic car class.
some_car: Car = buy_wolkswagen_car()

# However swapping that wouldn't work. We can't take a wolkswagen car from a function
# that gives us a generic car, because wolkswagen car may have some more specific attributes
# which aren't present in all of the cars.
wolkswagen_car: WolkswagenCar = buy_car()
```

## Contravariance

Another concept is known as **contravariance**. It is essentially a complete opposite of **covariance** in the sense
that rather than being able to take a generic of some type and assign it a generic of some subtype, we can take instead
assign this generic of given type a generic of some other supertype to that type.

This one is probably even more confusing if you only look at this definition. Why would we ever need something that can
take the type itself, or any subtypes of that type? Well, let's look at the other portion of the `typing.Callable` type
which contains the arguments

```py
class Car: ...
class WolkswagenCar(Car): ...
class AudiCar(Car): ...

def drive_car(car: Car) -> None:
    # The type of this function is Callable[[Car], None]
    print("Driving a car")

def drive_wolkswagen_car(wolkswagen_car: WolkswagenCar) -> None:
    # The type of this function is Callable[[WolkswagenCar], None]
    print("Driving a wolkswagen car")

def drive_audi_car(audi_car: AudiCar) -> None:
    # The type of this function is Callable[[AudiCar], None]
    print("Driving an audi car")


# In here, we try to assign a function that takes a regular car
# to a function that takes a specific, wolkswagen car
# i.e.: Callable[[Car], None] to Callable[[WolkswagenCar], None]
# However in this case, this doesn't make sense, if we would do this
# it would make it possible to use drive_wolkswagen_car with an audi car
# which doesn't make sense since audi car doesn't need to be compatible
# with a wolkswagen car
drive_car = drive_wolkswagen_car
```

So from this it's already clear that the `Callable` type for the arguments portion can't be covariant, but let's see
another a bit different example to reinforce this.

```py
# This is a constructor function that calls a passed function
# with a given argument for us
def make_drive_car(
    car: Car,
    drive_function: Callable[[Car], None]
) -> None:
    drive_function(car)

wolkswagen_car = WolkswagenCar()
make_drive_car(wolkswagen_car, drive_audi_car)
# It's probably obvious that this shouldn't work, we can't just use a specific
# Callable[[AudiCar], None] as a subtype for a more generic Callable[[Car], None],
# because this specific function doesn't need to work with arguments of more generic types.
# In this case, if this were the case, it would allow us to use a drive function for audi cars
# with the wolkswagen cars, which doesn't make sense
```

I believe it's now quite clear why Callable type for the arguments portion isn't covariant, but what does it mean for
it to actually be contravariant then?

```py
def make_drive_audi_car():
    audi_car: AudiCar,
    run_function: Callable[[AudiCar], None]
) -> None:
    run_function(audi_car)


my_car = AudiCar()
make_drive_audi_car(my_car, drive_car)
# In this case, we tried to use a car of a specific type with a general drive_car function
# Logically, this does actually make sense because we can use a more specific car in a
# function which actually takes a general car, since the more specific car will still have
# all of the attributes of a general car.
```

This kind of behavior, where we can pass a more general types (supertypes) of a given type (subtype) is precisely what
it means for a type to be covariant.

## Invariance

Invariance is probably the easiest of these types to understand, and by now you can probably already figure out what it
means. Simply, a type is invariant when it's neither covariant nor contravariant. That leaves us with only one
possibility, which is that we can't use neither subtypes of the given type nor supertypes, rather we can simply only
use the given type itself and nothing else.

What can be a bit surprising is that the elements of `list` datatype is actually an example of invariance. While an
immutable sequence such as a `tuple` will have covariant elements. This may seem weird, but there is a good reason for
that.

```py
class Person:
    def eat() -> None: ...
class Adult(Person):
    def work() -> None: ...
class Child(Person):
    def study() -> None: ...


person1 = Person()
person2 = Person()
adult1 = Adult()
adult2 = Adult()
child1 = Child()
child2 = Child()

people: List[Person] = [person1, person2]
adults: List[Adult] = [adult1, adult2]

# At first, it is important to establish that list isn't contravariant. This is perhaps quite intuitive, but it is
# important nevertheless. In here, we're setting adults, which is a list of Adult elements to a list of Person elements
# this will obviously fail, because the adult class can contain more attributes than a Person.
adults = people
```

Now that we've established that list type's elements aren't contravariant, let's see why it would be a bad idea to make
them covariant (like tuples). Essentially, the main difference here is the fact that a tuple is immutable, list isn't.
This means that you can add new elements to lists, but you can't do that with tuples, if you want to add a new element
there, you'd have to make a new tuple with those elements rather than altering an existing one.

Why does that matter? Well let's see this in an actual example

```py
def append_adult(adults: List[Person]) -> None:
    new_adult = Adult()
    adults.append(adult)

child1 = Child()
child2 = Child()
children: List[Child] = [child1, child2]

# If list type elements should be covariant, this should be fine, because Adult is a Person, and our function
# expects a list with element types of Person. Because of that covariance, this would be we could also pass
# in a list of element type that is a child class of Person (subtype) instead of just the Person.
append_adult(children)

# This will work fine, all people can eat, that includes adults and children
children[0].eat()

# Only children can study, this will also work fine because the 0th element is a child
children[0].study()
# This will fail, we've appended an adult to our list of children that's now on the 2nd element
# because this is a list of Child, we expect all elements in that list to have all properties
# that our Child class does, however in our case Adults can't study, giving us an error here
children[2].study()
```

As we can see from this example, the reason lists can't be covariant isn't because we wouldn't be able use a subtype
(a child class) of our actual element type, which is why immutable sequences are covariant, but rather it's because it
would allow us pass in a list of this type to a function that expects a list of some more generic supertype, and the
function could then end up appending an element that is a subtype of the supertype that the function expected, but
isn't a subtype of the element type that our list has.

This means that we can't afford to make lists covariant precisely because they're mutable.

## Recap

- Generics of covariant types can be represented as generics of a child class of our original type (subtypes)
- Generics of contravariant types can be represented as generics of a parent class of our original type (supertypes)
- Generics of invariant type can only be represented as generics of that same invariant type and no other subtype nor
  supertype

## Utilizing these concepts

### Type Variables

If you already know what type variables are, you can skip over this section, however if you don't it could be
beneficial for you in the next section, where we will be using them quite a lot.

A type variable (or a TypeVar) is essentially a simple concept, it's a type but it's a variable. What this means is
that we can have a function that takes a variable of type T (which is our TypeVar) and returns the type T. Something
like this will mean that we return an object of the same type as the object that was given to the function.

```py
from typing import TypeVar, Any

T = TypeVar("T")


def set_a(obj: T, a_value: Any) -> T:
    """
    Set the value of 'a' attribute for given `obj` of any type to given `a_value`
    Return the same object after this adjustment was made.
    """
    obj.a = a_value
    # Note that this function probably doesn't really need to return this
    # because `obj` is obviously mutable since we were able to set the it's value to something
    # that wasn't previously there
    return obj
```

Something extra: This isn't necessary for you to know if you're just interested about making generics with TypeVars,
however if you want to know a bit more about what you can do with TypeVars you can keep reading, otherwise just go to
the next section.

#### Type variables with value restriction

By default, a type variable can be replaced by any type. This is usually what we want, but sometimes it does make sense
to restrict a TypeVar to only certain types.

A commonly used variable with such restrictions is `typing.AnyStr`. This typevar can only have values `str` and
`bytes`.

```py
from typing import TypeVar

AnyStr = TypeVar("AnyStr", str, bytes)


def concat(x: AnyStr, y: AnyStr) -> AnyStr:
    return x + y

concat("a", "b")
concat(b"a", b"b)
concat(1, 2)  # Error!
```

This is very different from just using a simple `Union[str, bytes]`:

```py
from typing import Union

UnionAnyStr = Union[str, bytes]

def concat(x: UnionAnyStr, y: UnionAnyStr) -> UnionAnyStr:
    return x + y
```

Because in this case, if we pass in 2 strings, we don't know whether we will get a `str` object back, or a `bytes` one.
It would also allow us to use `concat("x", b"y")` however we don't know how to concatenate string object with bytes.
With a TypeVar, the type checker will reject something like this, but with a simple Union, this would be treated as
a valid function call and the argument types would be marked as correct, even though the implementation will fail.

#### Type variable with upper bounds

We can also restrict a type variable to having values that are a subtype of a specific type. This specific type is
called the upper bound of the type variable.

```py
from typing import Iterable

T = TypeVar("T", bound=Iterable[str])
```

In this case, we can use any type which matches the criteria of `typing.Iterable` ABC. (One such requirement is for
example to have `__iter__` defined.)

### Type-hinting a decorator

A common use-case for type variables is happening with decorators, because they usually just take our function, adjust
the arguments somehow and then return the same function object. Even though decorators are used pretty commonly in
python, most people actually don't really know how to type hint them and so they just leave them as they are, without
any type-hinting at all, since many type checkers know that any function that's decorated with `@decorator` will still
be that function, however this isn't ideal, especially when using the decorator manually
(`decorated = decorator(function)`). This is how a properly type-hinted decorator should actually look like:

```py
from typing import Any, Callable, TypeVar, cast

F = TypeVar("F", bound=Callable[..., Any])

def my_decorator(func: F) -> F:
    def wrapper(*args, **kwargs):
        print("function was called.")
        return func(*args, **kwargs)

    # We use `cast` here to tell the type-checker that the type of our `wrapper` function
    # is indeed the same as the type variable "F". Many people would think to just do
    # something like `def wrapper(*a, **kw) -> F`, however that's not correct because our
    # wrapper function doesn't actually return the function object itself, it returns the
    # value that's comming from our `func`.
    # I've seen some people attempting to extract the type hints of the `func` with `inspect`
    # module and dynamically set the singature of the wrapper type, however this isn't ideal
    # because the type-checkers are static, and they won't actually run the code in order to
    # evaluate the type it would set as a signature.
    return cast(F, wrapper)
```

Note that doing this isn't necessary if we decide to use the `@functools.wraps` decorator as it does all of this in the
background and for that reason we don't really see this type hinting actually happening since most programmers choose
to use `@wraps` simply because it's easier and it's not a good idea to re-implement something that's already in the
standard libraries.

### Creating Generics

Now that we know what it means for a generic to have a covariant/contravariant/invariant type, we can explore how to
make use of this knowledge and actually create some generics with these concepts in mind

Making an invariant generic:

```py
from typing import TypeVar, Generic

# We don't need to specify covariant=False nor contravariant=False, these are the default
# values, I do this here only to explicitly show that this typevar is invariant
T = TypeVar("T", covariant=False, contravariant=False)

class University(Generic[T]):
    students: tuple[T]

# In this case, we can see that our University will have some students, that will have a given type, however this type
# will be invariant, which means that we won't be able to make child classes for the students to split them into
# different categories, for example we wouldn't be able to do University[Student] and have an EngineeringStudent in
# our students list.
```

Making covariant generics:

```py
from typing import TypeVar, Generic

T_co = TypeVar("T_co", covariant=True)

class University(Generic[T]):
    students: tuple[T]

# In this case, we will be able use supertypes of the given T (presumabely Student) which makes it possible
# to now store specified students into our students tuple. (Note that we're using an immutable `tuple` here, which
# means we can use a covariant type here, however this wouldn't be the case if we wanted to use a mutable `list`!)
```

It's probably obvious how we would go about making a contravariant generic now
(`T_contra = TypeVar("T_contra", contravariant=True)`) though because of my limited imagination and limited time, I
didn't bother to think about an example where it would make sense to have a contravariant generic. It's safe to say
that they're pretty rare.

Do know that once you've made a typevar covariant or contravariant, you won't be able to use it anywhere else outside
of some generic, since it doesn't make sense to use such a typevar as a standalone thing, just use the `bound` feature
of a type variable instead, that will define it's upper bound types and any subtypes of those will be usable.

## Conclusion

This was probably a lot of things to process at once and you may need to read some things more times in order to really
grasp these concepts, but it is a very important thing to understand, not just in strictly typed languages, but as I
demonstrated even for a languages that have optional typing such as python.

Even though in most cases, you don't really need to know how to make your own covariant typing generics, there
certainly are some use-cases for them, especially if you enjoy making libraries and generally working on back-end,
since these type hints will show up to the people who will be using your code (presumably as an imported library) and
they can be really helpful in further explaining what arguments do some functions expect and what will they return even
without the need to read the docstrings of those functions.
