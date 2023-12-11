---
title: Variance of typing generics (covariance, contravariance and invariance)
date: 2021-10-04
tags: [programming, python]
---

In many programming languages where typing matters we often need to define certain properties for the types of generics
so that they can work properly. Specifically, when we use a generic type of some typevar `X` we need to know when that
generic type with typevar `Y` should be treated as it's subtype. I know this probably sounds pretty confusing but don't
worry, I'll explain what that sentence means in quite a lot of detail here. (That's why I wrote a whole article about
it). It's actually not that difficult to understand, it just needs a few examples to explain it.

As a very quick example of what I mean: When we use a sequence of certain types, say a sequence containing elements of
type Shirt that is a subtype of a Clothing type, can we assign this sequence as having a type of sequence of clothing
elements? If yes, than this sequence would be covariant in it's elements type. What about a sequence of Clothing
elements? Can we assign this sequence as having a type of a sequence of Shirts? If yes, then this sequence generic
would be contravariant in it's elements type. Or, if the answer to both of these was no, then the sequence is
invariant.

For simplicity, I'll be using python in the examples. Even though python isn't a strictly typed language, because of
tools such as pyright, mypy or many others, python does have optional support for typing that can be checked for
outside of run time (it's basically like strictly typed languages that check this on compile time, except in python,
it's optional and doesn't actually occur on compilation, so we say that it occurs "on typing time" or "linting time").

Do note that this post is a bit more advanced than the other ones I made and if you don't already feel comfortable with
basic typing concepts in python, it may not be very clear what's going on in here so I'd suggest learning something
about them before reading this.

## Pre-conceptions

This section includes some explanation of certain concepts that I'll be using in later the article, if you already know
what these are, you can skip them, however if you don't it is crucial that you read through this to understand the rest
of this article. I'll go through these concepts briefly, but it should be sufficient to understand the rest of this
article. If you do want to know more though, I'd suggest looking at mypy documentation or python documentation.

### Type Variables

A type variable (or a TypeVar) is basically representing a variable type. What this means is that we can have a
function that takes a variable of type T (which is our TypeVar) and returns the type T. Something like this will mean
that we return an object of the same type as the object that was given to the function.

```python
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

If you've understood this example, you can move onto the next section, however if you want to know something extra
about these type variables or you didn't quite understand everything, I've included some more subsections about them
with more examples on some interesting things that you can do with them.

#### Type variables with value restriction

By default, a type variable can be replaced by any type. This is usually what we want, but sometimes it does make sense
to restrict a TypeVar to only certain types.

A commonly used variable with such restrictions is `typing.AnyStr`. This typevar can only have values `str` and
`bytes`.

```python
from typing import TypeVar

AnyStr = TypeVar("AnyStr", str, bytes)


def concat(x: AnyStr, y: AnyStr) -> AnyStr:
    return x + y

concat("a", "b")
concat(b"a", b"b)
concat(1, 2)  # Error!
```

This is very different from just using a simple `Union[str, bytes]`:

```python
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

```python
from typing import TypeVar, Sequence

T = TypeVar("T", bound=Sequence)

# Signify that the return type of this function will be the list containing
# sequences of the same type sequence as the type we got from the argument
def split_sequence(seq: T, chunks: int) -> list[T]:
    """
    Split a given sequence into n equally sized chunks of itself.

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

In here, we know that this function function will work for any type of sequence, however just using input argument type
of sequence wouldn't be ideal, because it wouldn't preserve that type when returning a list of chunks of those
sequences. With that kind of approach, we'd lost the type definition of our sequence from for example `list[int]` only to
`Sequence[object]`.

For that reason, we can use a type-var, in which we can enforce that the type must be a sequence, but we still don't
know what kind of sequence it may be, so it can be any subtype that implements the necessary functions for a sequence.
This means if we pass in a list, we know we will get back a list of lists, if we pass a tuple, we'll get a list of
tuples, and if we pass a list of integers, we'll get a list of lists of integers. This means the original type won't be
lost even after going through a function.

### Generic Types

Essentially when a class is generic, it just defines that something inside of our generic type is of some other type. A
good example would be for example a list of integers: `list[int]` (or in older python versions: `typing.List[int]`).
We've specified that our list will be holding elements of `int` type.

Generics like this can be used for many things, for example with a dict, we actually provide 2 types, first is the type
of the keys and second is the type of the values: `dict[str, int]` would be a dict with `str` keys and `int` values.

Here's a list of some definable generic types that are currently present in python 3.9:

{{< table >}}
| Type              | Description                                         |
|-------------------|-----------------------------------------------------|
| list[str]         | List of `str` objects                               |
| tuple[int, int]   | Tuple of two `int` objects                          |
| tuple[int, ...]   | Tuple of arbitrary number of `int`                  |
| dict[str, int]    | Dictionary with `str` keys and `int` values         |
| Iterable[int]     | Iterable object containing ints                     |
| Sequence[bool]    | Sequence of booleans (immutable)                    |
| Mapping[str, int] | Mapping from `str` keys to `int` values (immutable) |
{{< /table >}}

In python, we can even make up our own generics with the help of `typing.Generic`:

```python
from typing import TypeVar, Generic

T = TypeVar("T")

# If we specify a type-hint for our building like Building[Student]
# it will mean that the `inhabitants` variable will be a of type: `list[Student]`
class Building(Generic[T]):
    def __init__(self, *inhabitants: T):
        self.inhabitants = inhabitants

class Person: ...
class Student(Person): ...

people = [Person() for _ in range(10)]
my_building: Building[Person] = Building(*people)

students = [Student() for _ in range(10)]
my_dorm = Building[Student] = Building(*students)

# We now know that `my_building` will contain inhabitants of `Person` type,
# while `my_dorm` will only have `Student`(s) as it's inhabitants.
```

I'll go deeper into creating our custom generics later, after we learn the differences between covariance,
contravariance and invariance. For now, this is just a very simple illustrative example.

## Variance

As I've quickly explained in the start, the concept of variance tells us about whether a generic of certain type can be
assigned to a generic of another type. But I won't bother with trying to define variance more meaningfully since the
definition would be convoluted and you probably wouldn't really get what is it about until you'll see the examples of
different types of variances. So for that reason, let's just take a look at those.

### Covariance

The first concept of generic variance is **covariance**, the definition of which looks like this:

> If a generic `G[T]` is covariant in `T` and `A` is a subtype of `B`, then `G[A]` is a subtype of `G[B]`. This means
> that every variable of `G[A]` type can be assigned as having the `G[B]` type.

As I've very quickly explained initially, covariance is a concept where if we have a generic of some type, we can
assign it to a generic type of some supertype of that type. This means that the actual generic type is a subtype of
this new generic which we've assigned it to.

I know that this definition can sound really complicated, but it's actually not that hard. As an example, I'll use a `tuple`,
which is an immutable sequence in python. If we have a tuple of `Car` type, `Car` being a subclass of `Vehicle`, can we
assign this tuple a type of tuple of Vehicles? The answer here is yes, because every `Car` is a `Vehicle`, so a
tuple of cars is a subtype of tuple of vehicles. So is a tuple of objects, `object` being the basic class that
pretty much everything has in python, so both tuple of cars, and tuple of vehicles is a subtype of tuple of objects,
and we can assign those tuples to a this tuple of objects.

```python
from typing import Tuple

class Vehicle: ...
class Boat(Vehicle): ...
class Car(Vehicle): ...

my_vehicle = Vehicle()
my_boat = Boat()
my_car_1 = Car()
my_car_2 = Car()


vehicles: Tuple[Vehicle, ...] = (my_vehicle, my_car_1, my_boat)
cars: Tuple[Car, ...] = (my_car_1, my_car_1)

# This line assigns a variable with the type of 'tuple of cars' to a 'tuple of vehicles' type
# this makes sense because a tuple of vehicles can hold cars
# since cars are vehicles
x: Tuple[Vehicle, ...] = cars

# This line however tries to assign a tuple of vehicles to a tuple of cars type
# this however doesn't make sense because not all vehicles are cars, a tuple of
# vehicles can also contain other non-car vehicles, such as boats. These may lack
# some of the functionalities of cars, so a type checker would complain here
x: Tuple[Car, ...] = vehicles

# In here, both of these assignments are valid because both cars and vehicles will
# implement all of the logic that a basic `object` class needs. This means this
# assignment is also valid for a generic that's covariant.
x: Tuple[object, ...] = cars
x: Tuple[object, ...] = vehicles
```

Another example of a covariant type would be the return value of a function. In python, the `typing.Callable` type is
initialized like `Callable[[argument_type1, argument_type2], return_type]`. In this case, the return type for our
function is also covariant, because we can return a more specific type (subtype) as a return type. This is because we
don't mind treating a type with more functionalities as their supertype which have less functionalities, since the type
still has all of the functionalities we want i.e. it's fully compatible with the less specific type.

```python
class Car: ...
class WolkswagenCar(Car): ...
class AudiCar(Car)

def get_car() -> Car:
    # The type of this function is Callable[[], Car]
    r = random.randint(1, 3)
    if r == 1:
        return Car()
    elif r == 2:
        return WolkswagenCar()
    elif r == 3:
        return AudiCar()

def get_wolkswagen_car() -> WolkswagenCar:
    # The type of this function is Callable[[], WolkswagenCar]
    return WolkswagenCar()


# In the line below, we define a function `x` which is expected to have a type of
# Callable[[], Car], meaning it's a function that returns a Car.
# Here, we don't mind that the actual function will be returning a more specififc
# WolkswagenCar type, since that type is fully compatible with the less specific Car type.
x: Callable[[], Car] = get_wolkswagen_car

# However this wouldn't really make sense the other way around.
# We can't assign a function which returns any kind of Car to a variable with is expected to
# hold a function that's supposed to return a specific type of a car. This is because not
# every car is a WolkswagenCar, we may get an AudiCar from this function, and that may not
# support everything WolkswagenCar does.
x: Callable[[], WolkswagenCar] = get_car
```

### Contravariance

Another concept is known as **contravariance**. It is essentially a complete opposite of **covariance**.

> If a generic `G[T]` is contravariant in `T`, and `A` is a subtype of `B`, then `G[B]` is a subtype of `G[A]`. This
> means that every variable of `G[B]` type can be assigned as having the `G[A]` type.

In this case, this means that if we have a generic of some type, we can assign it to a generic type of some subtype of
that type. This means that the actual generic type is a subtype of this new generic which we've assigned it to.

This explanation is probably even more confusing if you only look at the definition. But even when we think about it as
an opposite of covariance, there's a question that comes up: Why would we ever want to have something like this? When
is it actually useful? To answer this, let's look at the other portion of the `typing.Callable` type which contains the
arguments to a function.

```python
class Car: ...
class WolkswagenCar(Car): ...
class AudiCar(Car): ...

# The type of this function is Callable[[Car], None]
def drive_car(car: Car) -> None:
    car.start_engine()
    car.drive()
    print(f"Driving {car.__class__.__name__} car.")

# The type of this function is Callable[[WolkswagenCar], None]
def drive_wolkswagen_car(wolkswagen_car: WolkswagenCar) -> None:
    # We need to login to our wolkswagen account on the car first
    # with the wolkswagen ID, in order to be able to drive it.
    wolkswagen_car.login(wolkswagen_car.wolkswagen_id)
    drive_car(wolkswagen_car)

# The type of this function is Callable[[AudiCar], None]
def drive_audi_car(audi_car: AudiCar) -> None:
    # All audi cars need to report back with their license plate
    # to Audi servers before driving is enabled
    audi_car.contact_audi(audi_car.license_plate_number)
    drive_car(wolkswagen_car)


# In here, we try to assign a function that takes a wolkswagen car
# to a variable which is defined as a function/callable which takes any regular car.
# However this is a problem, because now we can use x with any car, including an
# AudiCar, but x is assigned to a fucntion that only accept wolkswagen cars, this
# may cause issues because not every car has the properties of a wolkswagen car,
# which this function may need to utilize.
x: Callable[[Car], None] = drive_wolkswagen_car

# On the other hand, in this example, we're assigning a function that can
# take any car to a variable that is defined as a function/callable that only
# takes wolkswagen cars as arguments.
# This is fine, because x only allows us to pass in wolkswagen cars, and it is set
# to a function which accepts any kind of car, including wolkswagen cars.
x: Callable[[WolkswagenCar], None] = drive_car
```

So from this it's already clear that the `Callable` type for the arguments portion can't be covariant, and hopefully
you can now recognize what it means for something to be contravariant. But to reinforce this, here's one more bit
different example.

```python
class Library: ...
class Book: ...
class FantasyBook(Book): ...
class DramaBook(Book): ...

def remove_while_used(func: Callable[[Library, Book], None]) -> Callable[[Library, Book], None]
    """This decorator removes a book from the library while `func` is running."""
    def wrapper(library: Library, book: Book) -> None:
        library.remove(book)
        value = func(book)
        library.add(book)
        return value
    return wrapper


# As we can see here, we can use the `remove_while_used` decorator with the
# `read_fantasy_book` function below, since this decorator expects a function
# of type: Callable[[Library, Book], None] to which we're assigning
# our function `read_fantasy_book`, which has a type of
# Callable[[Library, FantasyBook], None].
#
# Obviously, there's no problem with Library, it's the same type, but as for
# the type of the book argument, our read_fantasy_book func only expects fantasy
# books, and we're assigning it to `func` attribute of the decorator, which
# expects a general Book type. This is fine because a FantasyBook meets all of
# the necessary criteria for a general Book, it just includes some more special
# things, but the decorator function won't use those anyway.
#
# Since this assignment is be possible, it means that Callable[[Library, Book], None]
# is a subtype of Callable[[Library, FantasyBook], None], not the other way around.
# Even though Book isn't a subtype of FantasyBook, but rather it's supertype.
@remove_while_used
def read_fantasy_book(library: Library, book: FantasyBook) -> None:
    book.read()
    my_rating = random.randint(1, 10)
    # Rate the fantasy section of the library
    library.submit_fantasy_rating(my_rating)
```

This kind of behavior, where we can pass generics with more specific types to generics of less specific types
(supertypes), means that the generic is contravariant in that type. So for callables, we can write that:
`Callablle[[T], None]` is contravariant in `T`.

### Invariance

The last type of variance is called **invariance**, and it's certainly the easiest of these types to understand, and by
now you may have already figured out what it means. Simply, a generic is invariant in type when it's neither
covariant nor contravariant.

> If a generic `G[T]` is invariant in `T` and `A` is a subtype of `B`, then `G[A]` is neither a subtype nor a supertype
> of `G[B]`. This means that any variable of `G[A]` type can never be assigned as having the `G[B]` type, and
> vice-versa.

This means that the
generic will never be a subtype of itself no matter it's type.

What can be a bit surprising is that the `list` datatype is actually invariant in it's elements type. While an
immutable sequence such as a `tuple` is covariant in the type of it's elements, this isn't the case for mutable
sequences. This may seem weird, but there is a good reason for that.

```python
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

people: List[Person] = [person1, person2, adult2, child1]
adults: List[Adult] = [adult1, adult2]

# At first, it is important to establish that list isn't contravariant. This is perhaps quite intuitive, but it is
# important nevertheless. In here, we tried to assign a list of people to `x` which has a type of list of children.
# This obviously can't work, because a list of people can include more types than just `Child`, and these types
# can lack some of the features that children have, meaning lists can't be contravariant.
x: list[Child] = people
```

Now that we've established that list type's elements aren't contravariant, let's see why it would be a bad idea to make
them covariant (like tuples). Essentially, the main difference here is the fact that a tuple is immutable, list isn't.
This means that you can add new elements to lists and alter them, but you can't do that with tuples, if you want to add
a new element there, you'd have to make a new tuple with those elements, so you wouldn't be altering an existing one.

Why does that matter? Well let's see this in an actual example

```python
def append_adult(adults: List[Person]) -> None:
    new_adult = Adult()
    adults.append(adult)

child1 = Child()
child2 = Child()
children: List[Child] = [child1, child2]

# This is where the covariant assignment happens, we assign a list of children
# to a list of people, `Child` being a subtype of Person`. Which would imply that
# list is covariant in the type of it's elements.
# This is the line on which a type-checker would complain. So let's see why allowing
# it is a bad idea.
people: List[Person] = children


# Since we know that `people` is a list of `Person` type elements, we can obviously
# pass it over to `append_adult` function, which takes a list of `Person` type elements.
# After we called this fucntion, our list got altered. it now includes an adult, which
# is fine since this is a list of people, and `Adult` type is a subtype of `Person`.
# But what also happened is that the list in `children` variable got altered!
append_adult(people)

# This will work fine, all people can eat, that includes adults and children
children[0].eat()

# Only children can study, this will also work fine because the 0th element is a child,
# afterall this is a list of children right?
children[0].study()
# Uh oh! This will fail, we've appended an adult to our list of children.
# But since this is a list of `Child` type elements, we expect all elements in that list
# to have all properties required of the `Child` type. But there's an `Adult` type element
# in there which doesn't actually have all of the properties of a `Child`, they lack the
# `study` method, causing an error on this line.
children[-1].study()
```

As we can see from this example, the reason lists can't be covariant is because we wouldn't be able assign a list of
certain type of elements to a list with elements of a supertype of those (a parent class of our actual element class).
Even though that type implements every feature that the super-type would, allowing this kind of
assignment could lead to mutations of the list where elements that don't belong were added, since while they may fit
the supertype requirement, they might no longer be of the original type.

That said, if we copied the list, re-typing in to a supertype wouldn't be an issue:

```python
class Game: ...
class BoardGame(Game): ...
class SportGame(Game): ...

board_games: list[BoardGame] = [tic_tac_toe, chess, monopoly]
games: list[Game] = board_games.copy()
games.append(voleyball)
```

This is why immutable sequences are covariant, they don't make it possible to edit the original, instead if a change is
desired, a new object must be made. This is why `tuple` or other `Sequence` types don't need to be copied when doing an
assignment like this. But elements of `MutableSequence` types do.

### Recap

- if G[T] is covariant in T, and A is a subtype of B, then G[A] is a subtype of G[B]
- if G[T] is contravariant in T, and A is a subtype of B, then G[B] is a subtype of G[A]
- if G[T] is invariant in T (the default), and A is a subtype of B, then G[A] and G[B] don't have any subtype relation

## Creating Generics

Now that we know what it means for a generic to have a covariant/contravariant/invariant type, we can explore how to
make use of this knowledge and actually create some generics with these concepts in mind

**Making an invariant generics:**

```python
from typing import TypeVar, Generic, List, Iterable

# We don't need to specify covariant=False nor contravariant=False, these are the default
# values, I do this here only to explicitly show that this typevar is invariant
T = TypeVar("T", covariant=False, contravariant=False)

class University(Generic[T]):
    students: List[T]

    def __init__(self, students: Iterable[T]) -> None:
        self.students = [s for s in students]

    def add_student(self, student: T) -> None:
        students.append(student)

x: University[EngineeringStudent] = University(engineering_students)
y: University[Student] = x  # NOT VALID! University isn't covariant
z: University[ComputerEngineeringStudent] = x  # NOT VALID! University isn't contravariant
```

In this case, our University generic type is invariant in the student type, meaning that
if we have a `University[Student]` type and `University[EngineeringStudent]` type, neither
is a subtype of the other.

**Making covariant generics:**

In here, it is important to make 1 thing clear, whenever the typevar is in a function argument, it would become
contravariant, making it impossible to make a covariant generic which takes attributes of it's type as arguments
somewhere. However this rule does not extend to initialization/constructor of that generic, and this is very important.
Without this exemption, it wouldn't really be possible to construct a covariant generic, since the original type must
somehow be passed onto the instance itself, otherwise we wouldn't know what type to return in the actual logic. This is
why using a covariant typevar in `__init__` is allowed.

```python
from typing import TypeVar, Generic, Sequence, Iterable

T_co = TypeVar("T_co", covariant=True)

class Matrix(Sequence[Sequence[T_co]], Generic[T_co]):
    __slots__ = ("rows", )
    rows: tuple[tuple[T_co, ...], ...]

    def __init__(self, rows: Iterable[Iterable[T_co]]):
        self.rows = tuple(tuple(el for el in row) for row in rows)

    def __setattr__(self, attr: str, value: object) -> None:
        if hasattr(self, attr):
            raise AttributeError(f"Can't change {attr} (read-only)")
        return super().__setattr__(attr, value)

    def __getitem__(self, row_id: int, col_id: int) -> T_co:
        return self.rows[row_id][col_id]

    def __len__(self) -> int:
        return len(self.rows)

class X: ...
class Y(X): ...
class Z(Y): ...

a: Matrix[Y] = Matrix([[Y(), Z()], [Z(), Y()]])
b: Matrix[X] = x  # VALID. Matrix is covariant
c: Matrix[Z] = x  # INVALID! Matirx isn't contravariant
```

In this case, our Matrix generic type is covariant in the element type, meaning that if we have a `Matrix[Y]` type
and `Matrix[X]` type, we could assign the `University[Y]` to the `University[X]` type, hence making it it's
subtype.

We can make this Matrix covariant because it is immutable (enforced by slots and custom setattr logic). This allows
this matrix class (just like any other sequence class), to be covariant. Since it can't be altered, this covariance is
safe.

**Making contravariant generics:**

```python
from typing import TypeVar, Generic
import pickle
import requests

T_contra = TypeVar("T_contra", contravariant=True)

class Sender(Generic[T_contra]):
    def __init__(self, url: str) -> None:
        self.url = url

    def send_request(self, val: T_contra) -> str:
        s = pickle.dumps(val)
        requests.post(self.url, data={"object": s})

class X: ...
class Y(X): ...
class Z(Y): ...

a: Sender[Y] = Sender("https://test.com")
b: Sender[Z] = x  # VALID, sender is contravariant
c: Sender[X] = x  # INVALID, sender is covariant
```

In this case, our `Sender` generic type is contravariant in it's value type, meaning that
if we have a `Sender[Y]` type and `Sender[Z]` type, we could assign the `Sender[Y]` type
to the `Sender[Z]` type, hence making it it's subtype.

This works because the type variable is only used in contravariant generics, in this case, in Callable's arguments.
This means that the logic of determining subtypes for callables will be the same for our Sender generic.

i.e. if we had a sender generic of Car type with `send_request` function, and we would be able to assign it to a sender
of Vehicle type, suddenly it would allow us to use other vehicles, such as airplanes to be passed to `send_request`
function, but this function only expects type of `Car` (or it's subtypes).

On the other hand, if we had this generic and we tried to assign it to a sender of `AudiCar`, that's fine, because now
all arguments passed to `send_request` function will be required to be of the `AudiCar` type, but that's a subtype of a
general `Car` and implements everything this general car would, so the function doesn't mind.

Note: This probably isn't the best example of a contravariant class, but because of my limited imagination and lack of
time, I wasn't able to think of anything better.

**Some extra notes**

- Usually, most of your generics will be invariant, however sometimes, it can be very useful to mark your generic as
  covariant, since otherwise, you'd need to recast your variable manually when defining another type, or copy your
  whole generic, which would be very wasteful, just to satisfy type-checkers. Less commonly, you can also find it
  helpful to mark your generics as contravariant, though this will usually not come up, maybe if you're using
  protocols, but with full standalone generics, it's quite rarely used. Nevertheless, it's important to
- Once you've made a typevar covariant or contravariant, you won't be able to use it anywhere else outside of some
  generic, since it doesn't make sense to use such a typevar as a standalone thing, just use the `bound` feature of a
  type variable instead, that will define it's upper bound types and any subtypes of those will be usable.
- Generics that can be covariant, or contravariant, but are used with a typevar that doesn't have that specified can
  lead to getting a warning from the type-checker that this generic is using a typevar which could be covariant, but
  isn't. However this is just that, a warning. You are by no means required to make your generic covariant even though
  it can be, you may still have a good reason not to. If that's the case, you should however specify `covariant=False`,
  or `contravariant=False` for the typevar, since that will usually satisfy the type-checker and the warning will
  disappear, since you've explicitly stated that even though this generic could be using a covariant/contravariant
  typevar, it shouldn't be and that's desired.

## Conclusion

This was probably a lot of things to process at once and you may need to read some things more times in order to really
grasp these concepts, but it is a very important thing to understand, not just in strictly typed languages, but as I
demonstrated even for a languages that have optional typing such as python.

Even though in most cases, you don't really need to know how to make your own typing generics which aren't invariant,
there certainly are some use-cases for them, especially if you enjoy making libraries and generally working on
back-end, but even if you're just someone who works with these libraries, knowing this can be quite helpful since even
though you won't often be the one writing those generics, you'll be able to easily recognize and know what you're working
with, immediately giving you an idea of how that thing works and how it's expected to be used.
