---
title: Typing generics and variance
date: 2021-10-04
tags: [programming, python, typing]
aliases:
  - /posts/typing-variance-of-generics
changelog:
  2024-09-05:
    - Complete overhaul of the article, rewrite most things
    - Focus more on explaining generics as a concept too, not just their variance
    - Rename the article from 'Variance of typing generics (covariance, contravariance and invariance)' to 'Typing generics and variance'
    - Move section about type vars into it's own [article]({{< ref "posts/type-vars" >}})
---

Generics and variance are advanced concepts in Python's type system that offer powerful ways to write code that is
flexible and reusable across different types. By understanding these concepts, you can write more robust, maintainable
and less repetitive code, making the most of Python's type hinting capabilities.

Even if you don't work in Python, the basic concepts of generics and especially their variance carry over to all kinds
of programming languages, making them useful to understand no matter what you're coding in.

_**Pre-requisites**: This article assumes that you already have a [basic knowledge of python typing]({{< ref
"posts/python-type-checking"
>}}) and [type-vars]({{< ref "posts/type-vars" >}})._



## What are Generics

Generics allow you to define functions and classes that operate on types in a flexible yet type-safe manner. They are a
way to specify that a function or class works with multiple types, without being restricted to a single type.

### Basic generic classes

Essentially when a class is generic, it just defines that something inside of it is of some dynamic type. A
good example would be for example a list of integers: `list[int]` (or in older python versions: `typing.List[int]`).
We've specified that our list will be holding elements of `int` type.

Generics like this can be used for many things, for example with a dict, we actually provide 2 types, first is the type
of the keys and second is the type of the values: `dict[str, int]` would be a dict with `str` keys and `int` values.

Here's a list of some definable generic types that are currently present in python 3.12:

{{< table >}}
| Type | Description |
|-------------------|-----------------------------------------------------|
| list[str] | List of `str` objects |
| tuple[int, int] | Tuple of two `int` objects (immutable) |
| tuple[int, ...] | Tuple of arbitrary number of `int` (immutable) |
| dict[str, int] | Dictionary with `str` keys and `int` values |
| Iterable[int] | Iterable object containing ints |
| Sequence[bool] | Sequence of booleans (immutable) |
| Mapping[str, int] | Mapping from `str` keys to `int` values (immutable) |
{{< /table >}}

### Custom generics

In python, we can even make up our own generics with the help of `typing.Generic`:

```python
from typing import TypeVar, Generic

T = TypeVar("T")


class Person: ...
class Student(Person): ...

# If we specify a type-hint for our building like Building[Student]
# it will mean that the `inhabitants` variable will be a of type: `tuple[Student, ...]`
class Building(Generic[T]):
    def __init__(self, *inhabitants: T):
        self.inhabitants = inhabitants


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

The concept of variance tells us about whether a generic of certain type can be assigned to a generic of another type.
So for example, variance tackles a question like: Can a value of type `Building[Student]` be assigned to a variable of
type `Building[Person]`? Let's see the different kinds of generic variances.

### Covariance

The first concept of generic variance is **covariance**, the definition of which looks like this:

> If a generic `G[T]` is covariant in `T` and `A` is a subtype of `B`, then `G[A]` is a subtype of `G[B]`. This means
> that every variable of `G[A]` type can be assigned as having the `G[B]` type.

So, in other words, covariance is a concept where if we have a generic of some type, we can assign it to a generic type
of some supertype of that type. This means that the generic type is a subtype of this new generic which we've assigned
it to.

I know that this definition can sound really complicated, but it's actually not that hard, it just needs some code
examples.

#### Tuple

As an example, I'll use a `tuple`, which is an immutable sequence in python. If we have a tuple of `Car` type
(`tuple[Car, ...]`), `Car` being a subclass of `Vehicle`, can we assign this type to a tuple of Vehicles
(`tuple[Vehicle, ...]`)? The answer here is yes, so a tuple of cars is a subtype of tuple of vehicles. 

This indicates that the generic type parameter for tuple is covariant.

Let's explore this further with some proper python code example:

```python
class Vehicle: ...
class Boat(Vehicle): ...
class Car(Vehicle): ...

my_vehicle = Vehicle()
my_boat = Boat()
my_car_1 = Car()
my_car_2 = Car()


vehicles: tuple[Vehicle, ...] = (my_vehicle, my_car_1, my_boat)
cars: tuple[Car, ...] = (my_car_1, my_car_1)

# This line assigns a variable with the type of 'tuple of cars' to a 'tuple of vehicles' type
# this makes sense because a tuple of vehicles can hold cars, cars are vehicles
x: tuple[Vehicle, ...] = cars

# This line however tries to assign a tuple of vehicles to a tuple of cars type.
# That however doesn't make sense because not all vehicles are cars, a tuple of
# vehicles can also contain other non-car vehicles, such as boats. These may lack
# some of the functionalities of cars, so a type checker would complain here
x: tuple[Car, ...] = vehicles

# In here, both of these assignments are valid because both cars and vehicles will
# implement all of the logic that a basic `object` class needs (everything in python
# falls under the object type). This means that this assignment is also valid
# for a generic that's covariant.
x: tuple[object, ...] = cars
x: tuple[object, ...] = vehicles
```

#### Return type

Another example of a covariant type would be the return value of a function. In python, the `collections.abc.Callable` type
(or `typing.Callable`) represents a type that supports being called. So for example a function.

If specified like `Callable[[A, B], R]`, it denotes a function that takes in 2 parameters, first with type `A`, second
with type `B`, and returns a type `R` (`def func(x: A, y: B) -> R`).

In this case, the return type for our function is also covariant, because we can return a more specific type (subtype)
as a return type. 

Consider the following:

```python
class Car: ...
class WolkswagenCar(Car): ...
class AudiCar(Car): ...

def get_car() -> Car:
    # The type of this function is Callable[[], Car]
    # yet we can return a more specific type (a subtype) of the Car type from this function
    r = random.randint(1, 2)
    elif r == 1:
        return WolkswagenCar()
    elif r == 2:
        return AudiCar()

def get_wolkswagen_car() -> WolkswagenCar:
    # The type of this function is Callable[[], WolkswagenCar]
    return WolkswagenCar()


# In the line below, we define a callable `x` which is expected to have a type of
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

All of this probably seemed fairly trivial, covariance is very intuitive and it's what you would assume a generic
parameter to be in most cases.

### Contravariance

Another concept is known as **contravariance**. It is essentially a complete opposite of **covariance**.

> If a generic `G[T]` is contravariant in `T`, and `A` is a subtype of `B`, then `G[B]` is a subtype of `G[A]`. This
> means that every variable of `G[B]` type can be assigned as having the `G[A]` type.

In this case, this means that if we have a generic of some type, we can assign it to a generic type of some subtype
(e.g. `G[Car]` can be assigned to `G[AudiCar]`).

In all likelihood, this will feel very confusing, since it isn't at all obvious when a relation like this would make
sense. To answer this, let's look at the other portion of the `Callable` type, which contains the arguments to a
function.

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
    # We need to login to our wolkswagen account with the wolkswagen ID, 
    # in order to be able to drive it.
    wolkswagen_car.login(wolkswagen_car.wolkswagen_id)
    drive_car(wolkswagen_car)

# The type of this function is Callable[[AudiCar], None]
def drive_audi_car(audi_car: AudiCar) -> None:
    # All audi cars need to report back with their license plate
    # to Audi servers before driving is enabled
    audi_car.contact_audi(audi_car.license_plate_number)
    drive_car(wolkswagen_car)


# In here, we try to assign a function that takes a wolkswagen car to a variable 
# which is declared as a callable taking any car. However this is a problem, 
# because now we can call x with any car, including an AudiCar, but x is assigned
# to a fucntion that only works with wolkswagen cars!
#
# So, G[VolkswagenCar] is not a subtype of G[Car], that means this type parameter
# isn't covariant
x: Callable[[Car], None] = drive_wolkswagen_car

# On the other hand, in this example, we're assigning a function that can take any 
# car to a variable that is defined as a callable that only takes wolkswagen cars 
# as arguments. This is fine, because x only allows us to pass in wolkswagen cars,
# and it is set to a function which accepts any kind of car, including wolkswagen cars.
#
# This means that G[Car] is a subtype of G[WolkswagenCar], so this type parameter
# is actually contravariant
x: Callable[[WolkswagenCar], None] = drive_car
```

So from this it should be clear that the type parameters for the arguments portion of the `Callable` type aren't
covariant and you should have a basic idea what contravariance is.

To solidify this understanding a bit more, let's see contravariance again, in a slightly different scenario:

```python
class Library: ...
class Book: ...
class FantasyBook(Book): ...
class DramaBook(Book): ...

def remove_while_used(func: Callable[[Library, Book], None]) -> Callable[[Library, Book], None]:
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
# Since this assignment is be valid, it means that Callable[[Library, Book], None]
# is a subtype of Callable[[Library, FantasyBook], None], stripping the unnecessary parts
# it means that G[Book] is a subtype of G[FantasyBook], even though Book isn't a subtype
# of FantasyBook, but rather it's supertype.
@remove_while_used
def read_fantasy_book(library: Library, book: FantasyBook) -> None:
    book.read()
    my_rating = random.randint(1, 10)
    # Rate the fantasy section of the library
    library.submit_fantasy_rating(my_rating)
```

Hopefully, this made the concept of contravariance pretty clear. An interesting thing is that contravariance doesn't
really come up anywhere else other than in function arguments. Even though you may see generic types with contravariant
type parameters, they are only contravariant because those parameters are being used as function arguments in that
generic type internally.
### Invariance

The last type of variance is called **invariance**, and by now you may have already figured out what it means. Simply,
a generic is invariant in type when it's neither covariant nor contravariant.

> If a generic `G[T]` is invariant in `T` and `A` is a subtype of `B`, then `G[A]` is neither a subtype nor a supertype
> of `G[B]`. This means that any variable of `G[A]` type can never be assigned as having the `G[B]` type, and
> vice-versa.

This means that the generic type taking in a type parameter will only be assignable to itself, if the type parameter
has any different type, regardless of whether that type is a subtype or a supertype of the original, it would no longer
be assignable to the original.

What can be a bit surprising is that the `list` datatype is actually invariant in it's elements type. While an
immutable sequence such as a `tuple` is covariant in the type of it's elements, this isn't the case for mutable
sequences. This may seem weird, but there is a good reason for it. Let's take a look:

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

people: list[Person] = [person1, person2, adult2, child1]
adults: list[Adult] = [adult1, adult2]

# At first, it is important to establish that list isn't contravariant. This is perhaps quite intuitive, but it is
# important nevertheless. In here, we tried to assign a list of people to `x` which has a type of list of children.
# This obviously can't work, because a list of people can include other types than just `Child`, and these types
# can lack some of the features that children have, meaning lists can't be contravariant.
x: list[Child] = people
```

Now that we've established that list type's elements aren't contravariant, let's see why it would be a bad idea to make
them covariant (like tuples). Essentially, the main difference here is the fact that a tuple is immutable, list isn't.
This means that you can add new elements to lists and alter them, but you can't do that with tuples, if you want to add
a new element there, you'd have to make a new tuple with those elements, so you wouldn't be altering an existing one.

Why does that matter? Well let's see this in an actual example

```python
def append_adult(adults: list[Person]) -> None:
    new_adult = Adult()
    adults.append(adult)

child1 = Child()
child2 = Child()
children: list[Child] = [child1, child2]

# This is where the covariant assignment happens, we assign a list of children
# to a list of people, `Child` being a subtype of Person`. Which would imply that
# list is covariant in the type of it's elements. A type-checker should complain
# about this line, so let's see why allowing it is a bad idea.
people: list[Person] = children

# Since we know that `people` is a list of `Person` type elements, we can obviously
# pass it over to `append_adult` function, which takes a list of `Person` type elements.
# After we called this fucntion, our list got altered. it now includes an adult, which
# should be fine assuming list really is covariant, since this is a list of people, and 
# `Adult` type is a subtype of `Person`.
append_adult(people)

# Let's go back to the `children` list now, let's loop over the elements and do some stuff with them
for child in children:
    # This will work fine, all people can eat, that includes adults and children
    child.eat()

    # Only children can study, but that's not an issue, because we're working with
    # a list of children, right? Oh wait, but we appended an Adult into `people`, which
    # also mutated `children` (it's the same list) and Adults can't study, uh-oh ...
    child.study()  # AttributeError, 'Adult' class doesn't have 'study' attribute
```

As we can see from this example, the reason lists can't be covariant because it would allow us to mutate them and add
elements of completely unrelated types that break our original list.

That said, if we copied the list, re-typing in to a supertype wouldn't be an issue:

```python
class Game: ...
class BoardGame(Game): ...
class SportGame(Game): ...

board_games: list[BoardGame] = [tic_tac_toe, chess, monopoly]
games: list[Game] = board_games.copy()
games.append(voleyball)
```

This is why immutable sequences are covariant, they don't make it possible to edit the original, instead, if a change is
desired, a new object must be made. This is why `tuple` or other `typing.Sequence` types can be covariant, but lists and
`typing.MutableSequence` types need to be invariant.

### Recap

- if G[T] is covariant in T, and A (wolkswagen car) is a subtype of B (car), then G[A] is a subtype of G[B]
- if G[T] is contravariant in T, and A is a subtype of B, then G[B] is a subtype of G[A]
- if G[T] is invariant in T, and A is a subtype of B, then G[A] and G[B] don't have any subtype relation

## Creating Generics

Now that we know what it means for a generic to have a covariant/contravariant/invariant type, we can explore how to
make use of this knowledge and actually create some generics with these concepts in mind

### Making an invariant generics

```python
from typing import TypeVar, Generic
from collections.abc import Iterable

# We don't need to specify covariant=False nor contravariant=False, these are the default
# values (meaning all type-vars are invariant by default), I specify these parameters 
# explicitly just to showcase them.
T = TypeVar("T", covariant=False, contravariant=False)

class University(Generic[T]):
    students: list[T]

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

### Making covariant generics

In the example below, we create a covariant `TypeVar` called `T_co`, which we then use in our custom generic, this name
for the type-var is actually following a common convention for covariant type-vars, so it's a good idea to stick to it
if you can. 

```python
from collections.abc import Iterable, Sequence
from typing import Generic, TypeVar

T_co = TypeVar("T_co", covariant=True)

class Matrix(Sequence[Sequence[T_co]], Generic[T_co]):
    _rows: tuple[tuple[T_co, ...], ...]

    def __init__(self, rows: Iterable[Iterable[T_co]]):
        self._rows = tuple(tuple(el for el in row) for row in rows)

    def __getitem__(self, row_id: int, col_id: int) -> T_co:
        return self._rows[row_id][col_id]

    def __len__(self) -> int:
        return len(self._rows)

class X: ...
class Y(X): ...
class Z(Y): ...

x: Matrix[Y] = Matrix([[Y(), Z()], [Z(), Y()]])
y: Matrix[X] = x  # VALID. Matrix is covariant
z: Matrix[Z] = x  # INVALID! Matirx isn't contravariant
```

In this case, our Matrix generic type is covariant in the element type, meaning that we can assign `Matrix[Y]` type
to `Matrix[X]` type, with `Y` being a subtype of `X`.

This works because the type-var is only used in covariant generics, in this case, with a `tuple`. If we stored the
internal state in an invariant type, like a `list`, marking our type-var as covariant would be unsafe. Some
type-checkers can detect and warn you if you do this, but many won't, so be cautions.

### Making contravariant generics

Similarly to the above, the contravariant type var we create here is following a well established naming convention,
being called `T_contra`.

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

i.e. if we had a sender generic of Car type with `send_request` function, and we would be able to assign it to a sender
of Vehicle type, suddenly it would allow us to use other vehicles, such as airplanes to be passed to `send_request`
function, but this function only expects type of `Car` (or it's subtypes).

On the other hand, if we had this generic and we tried to assign it to a sender of `AudiCar`, that's fine, because now
all arguments passed to `send_request` function will be required to be of the `AudiCar` type, but that's a subtype of a
general `Car` and implements everything this general car would, so the function doesn't mind.

This works because the type variable is only used in contravariant generics, in this case, in Callable's arguments.
This means that the logic of determining subtypes for callables will be the same for our Sender generic. Once again, be
cautions about marking a type-var as contravariant, and make sure to only do it when it really is safe. If you use this
type-var in any covariant or invariant structure, while also being used in a contravariant structure, the type-var
needs to be changed to an invariant type-var.

## Conclusion

Understanding generics and variance in Python's type system opens the door to writing more flexible, reusable, and
type-safe code. By learning the differences between covariance, contravariance, and invariance, you can design better
abstractions and APIs that handle various types in a safe manner. Covariant types are useful when you want to ensure
that your type hierarchy flows upwards, whereas contravariant types allow you to express type hierarchies in reverse
for certain use cases like function arguments. Invariance, meanwhile, helps maintain strict type safety in mutable
structures like lists.

These principles of variance are not unique to Python — they are foundational concepts in many statically-typed
languages such as Java or C#. Understanding them will not only deepen your grasp of Python's type system but
also make it easier to work with other languages that implement similar type-checking mechanisms.
