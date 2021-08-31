---
title: Removing duplicates from lists
date: 2021-08-31
tags: [programming]
---

In programming, we often need to handle removing duplicates from an array-like structure. While this may seem like an
arbitrary and easy question, that can be solved relatively simply, that's not necessarily always the case. While it may
be easy to solve, we also need to consider the runtime of the algorithm we use.

I'll be using python for the explanations and examples, but it should be relatively similar in most languages.

## Removing hashable duplicates (Simple case)

Let's say we have a list like `[1, 2, 4, 4, 5, 1, 3]`, the easiest and most optimized way to remove all elements from
this list would be to simply convert it into a `set`. In python, set is a data-structure that acts a bit like a
mapping/dictionary. Sets rely on hashes, and since the same objects should hash to same values, by design, sets prevent
the possibility of having multiple same elements in them.

An example of this would be as simple as this:

```py
duplicate_list = [1, 2, 4, 4, 5, 1, 3]
result = list(set(duplicate_list))
```

This will result in a clean list without any duplicate values. By converting the list into a set, we need to loop over
it (done internally) which means we take `O(n)`, there's also another `O(n)` for conversion back to list, but `O(2n)`
is just `O(n)`. This makes hashing a very compelling solution.

However this solution does have it's issues, and that's specifically the fact that it can't be used for everything.
Specifically if we had a list such as `[[1, 2, 3], [1, 2, 3]]` we would have a pretty big problem, that is the fact
that the inner lists aren't hashable, so we can't use sets here. This would also happen with inner sets or any custom
unhashable types.

## Removing unhashable duplicates

To cope with this problem, we have 5 general options:

1. Do `==` (`__eq__`) comparisons for each value against each other value
2. Compare exact object
3. Convert the elements into their hashable counterpart
4. Generate our own universal hashes for our unhashables
5. Generate specific hashes depending on the objects

**Note about hashes:** even though in the last 3 options, what we're essentially doing is somehow making an unhashable
object a hashable one, while this is probably fine for our use-case, there usually is a reason why some object isn't
hashable (unless the object's author was just careless). This reason is usually simply because the object is mutable,
i.e.: it can be changed without making a new object. This mutability will mean that it will get a new hash, since the
hash was probably computed from the defined values which were later changed.

### Equality comparisons with `__eq__` (the simpler option)

The easiest way would be to simply rely on `__eq__` (i.e.: the special function called by python when performing `==`
comparisons). Doing this means we don't need hashable object (objects defining `__hash__`), however we now need the
objects to define this equality check. This isn't a huge issue though, since it is much more common for objects to
define equality checks than to be hashable. At least for builtin objects, all of the unhashable objects do define this.

We can tackle this simply by making another `result` list, that will only hold the values once, this is the list
against which we will be running the `==` comparisons (for each value in it), to avoid ever inserting a duplicate value
into it. Example of this code:

```py
duplicate_list = [1, 1, 2, 4, [1, 2], [2, 1], [1, 2], "foo", "bar"]
result = []
for element in duplicate_list:
    # Go through the whole `result` list and only add current
    # `element` if it isn't already there.
    if element not in result:
        result.append(element)
```

Using `element in result` will internally call the `__in__` method of our `result` list object, which is implemented
in a way that goes through every element of that list and performs an `__eq__` equality check, which if true, we return
early and end with true. But in the worst case, we go through every element of the list and perform this comparison for
each one, once we've depleted all elements, only then we can return false (element wasn't in the `result` list)

This is a very common and simple solution, however it isn't a very effective one. In worst case (every element is
unique), it will first go through the whole `duplicate_list` (that's `O(n)`), and in there, we will go through the
whole `result` list, which in the worst case will be growing with every iteration until it gets to the size of `n`
(since in the worst case, every element is unique and gets added). This results in another `O(n)` inside of our
original `O(n)`, making our algorithm `O(n^2)`.

To resolve the efficiency problem, we could however add an optimization, where all hashable values would use `set`,
and only resorting to `__eq__` check for non-hashables. This would still result in worst case `O(n^2)` (all elements
are non-hashable), but best case of `O(n)` (all elements are hashable). This approach is probably the best way to
achieve simple implementation, yet relatively good efficiency.

### Compare exact objects

In most programming languages, there is a way to access the memory id of an object, in python, this is done with `id()`
function. This memory id will always be unique, since we can't have 2 separate objects sharing the same memory id.
Essentially this is the difference between `x is y` and `x == y`, `is` will basically do `id(x) == id(y)` while `==`
will use the `x.__eq__(y)` method defined for `x`'s class.

We can use this `id` for our comparisons instead of using the `__eq__` and since it will always be unique, we can even
use it as a hash of that object. However we should know that this will result in some weirdness and this method likely
isn't what you'd want for general duplicate removing.

```py
a = "hello"
b = a  # Python will not make a new string object here, so it will use the same one

print(a == b) # <- True
print(a is b) # <- True

c = "hi"
d = "hi" # This is a new string object, and the ids will be different here

print(c == d) # <- True
print(c is d) # <- False
```

**Note:** In many python interpretations, `c is d` will actually also be `True` because of internal memory
optimizations, it is simply more efficient to use the same object if there already exists one, but this shouldn't be
relied on and with some interpreters, this simply won't be the case and we would actually get the shown `False`.

The algorithm like this is relatively simple:

```py
x = Foo(x=5)
y = Foo(x=5)
duplicate_list = [x, x, y, 1, 2, "hi", Foo(x=5)]

result = {}
for element in duplicate_list:
    result[id(element)] = element

return list(result.values())
```

To preserve the original elements, we used a dict that held the unique hashable memory ids of our objects as keys and
the actual unhashable objects as values. Once we were done, we just returned all of the values in it as a list.

The result of this would be: `[x, y, 1, 2, "hi", Foo(x=5)]`. *(Note that `x`, `y` and `Foo(x=5)` would actually be
printed in the same way, since they're the same class, sharing the same `__repr__`)*. From this output we can clearly
see that even though `x`, `y`, and `Foo(x=5)` are exactly the same thing, sharing the same attributes, they're
different objects and therefore they have different memory ids, which means our algorithm didn't remove them, however
there is now only one `x`, because the second one was indeed exactly the same object, so that did get removed.

### Convert hashables into their unhashable counterpart (case-by-case)

We could try and find some alternative hashable data-structure for our unhashable ones. With builtin data-structures,
this is completely doable:

- unhashable `list` can be fully represented by a hashable immutable `tuple`: Tuples are ordered and a hash of `(1, 2)`
  will be different from `(2, 1)`, just like it should be with lists. Since tuples aren't mutable, they can be hashable.
- unhashable `set` can be fully represented by a hashable immutable `frozenset`: This is a python built-in, even though
  it's not very well known, it's simply an immutable set, giving it the possibility to be hashable too.

However we can't simply represent these objects as these other data-structures, since this would cause collisions, for
example with a list like `[[1, 2], (1, 2)]`, since `[1, 2]` would get converted into a tuple of `(1, 2)` it now becomes
identical, even though it really shouldn't be. To fix this, we can simply represent each object with a tuple:
`(type(obj), hashable_counterpart(obj))`, for example for a list, this would look like `(list, tuple(obj))` with the
first element in this tuple being the actual type, with this, real tuples would simply be `(tuple, obj)`, making
conversion possible once we're finished.

Even though for built-in data types, this is a viable solution, we need to be sure that we really will only use these
built-ins, and that our list will never contain anything else, or if it will, that it's handled appropriately. Since
the code for this example would be relatively long and entirely dependent on what data types will we have in the list,
I won't write an example code here, but the description should sufficiently describe how the code would look.

This will result in `O(n)`, however it should be kept in mind that the conversion into the hashable counterparts could
take significant time, we will be creating new objects for each unhashable object, which could end up taking longer
than the `O(n^2)` method using simple `__eq__` comparisons. This will be entirely dependent on how will the individual
cases be handled.

### Generate universal custom hashes for unhashables

If we don't have a strictly defined set of data structures that can be present in our list, we need to handle every
possibility. We can simply device our own way to generate a unique hash for any object whatsoever, this may sound hard,
but it's not actually that complicated.

We can go about this in many ways, but as a simple proof that this is possible, we know that all objects must be stored
somehow, this happens in the memory (RAM) which is a device that can only hold bits. This means that our object is
stored somewhere in the memory as an array of bytes, and any array of bytes can be interpreted as a simple integer.
Since integers are hashable we're done, we can compute a hash of any object.

Python has a handy library called `pickle` that is used for data serialization (converting data into a stream of bytes
that can be written into a file, for storage or sending whole python objects). Since these streams of bytes are
hashable, we can simply pickle all of the objects and use their hashes.

Again though, just like with the previous case, we should keep in mind that this process can take a while. Especially
when using `pickle` for objects with a big amount of internal attributes, not to mention that these attributes may also
be holders of a wide amount of other attributes. This could end up to be a very intensive process, depending on the
individual objects. So even with `O(n)` benefit of using hashing, this could take longer than the `O(n^2)` equality
approach.

### Generate hashes specific to our objects (case-by-case)

Another approach we could take is similar to the above, but rather than using `pickle` and generating a hash from every
single aspect of our object, we could use a more specific approach and only use the needed aspects of these objects to
make the hash. This is perhaps a bit more similar to the case-by-case representation with a hashable counterpart.

For example for an object that holds many attributes, however the only attributes that could actually be changed and
that determines it's uniqueness, we can construct our hash purely from those. `hash((obj.attribute1, obj.attribute2))`
Ideally we would also include the object's class: `hash((obj.__class__, ...))`.

This will end up being a lot faster than having to do a full serialization of our object with `pickle`, however since
this is a case-by-case approach, it will again only work when we have a pre-determined set of classes that can be in
our list, it isn't applicable to everything since we don't know the unique attributes of every custom class, that's why
these custom classes should be defining their own `__hash__`. Again, since this is hashing comparisons, it will be
`O(n)`.

## Recap

In most of the cases, the first approach will work just fine (the simple case where our list only have hashable
objects).

If however if we do need to deal with unhashables, we can either use direct memory ids and ensure that our
objects are exactly the same, or we can use some hashable counterpart to our unhashable object that could represent it.
We could also construct a universal hash function with serialization of our object, or a specific one if we know which
classes will be used there.

Even though we do have ways to deal with unhashables, if you're in control of the classes, and they aren't supposed to
be mutable, always make sure to add a `__hash__` method to them, so that duplicates can be easily removed in `O(n)`
without any complicated inconveniences.

