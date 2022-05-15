---
title: JSON vs Databases
date: 2021-09-20
tags: [programming]
---

I've seen tons of projects incorrectly use a method of storing data for their use-case. In most of the cases this was
an issue about using JSON instead of a database, but I did also see some people using databases where JSON should've
been used, or even some completely different format, such as simple plain text, or something more similar to JSON, such
as YAML. This is why I decided to write something about which of these should you use and when.

## What is the JSON format?

To understand when should we use JSON and when we shouldn't, let's first understand what JSON was actually made for and
how is it commonly used now.

The name **JSON** stands for JavaScript Object Notation. This is precisely what this format was made for, to hold
objects from JavaScript language. Even though this was the reason this format was made though, it's certainly not the
only thing it's currently being used for and we see JSON in countless other languages and use-cases then just in
JavaScript to hold it's objects.

But why is it that if this format was made only for JS, we're still using it in so many other places? The answer to
that is really simple, many data is able to be fully represented in JSON-like structure, even though that's not what it
was made for, if it fits the format, it can be used. For example any hashmap (or dictionary in python) would certainly
be following the key-value structure, which is what JSON is holding, any array will be able to be represented as comma
separated values, any strings can just be represented as the text wrapped in double (or single) quotes, so on and so
on. Because JSON format supports all of these features, it turned out that a huge majority of the data we need can be
completely represented by it without any issues.

## What is a database?

This is a bit harder to explain, but the most basic way to think about this is to essentially think of an excel
spreadsheet. It has some columns and some rows and you can store data into it. There are countless Database Management
Systems (DBMS) out there, most notably these are MariaDB, MySQL, PostgreSQL, Oracle, MongoDB, ... The goal of these
systems is, as the name would imply, manage the database. It controls how the data is stored and retrieved and perhaps
if there should be some internal compression of this database or things like that.

Even though there are a lot of choices for DBMS, no matter which one we end up using, on the surface, they will be
doing exactly the same thing. Storing tables of data. Each item in the database usually has some *primary key*, which
is a unique identifier for given column of data. We can also have composite primary keys, where there would be multiple
slots which are unique when combined, but don't necessarily need to be unique on their own. We can also use what's
called a *foreign key*, which is basically the primary key of something in another database table, separate from the
current one, to avoid data repetition. This would be an example of the data tables that a database could hold:

Table of students:

{{< table >}}
| Student ID | Date of birth | Name           | Permanent residence address | Field of study       |
|------------|---------------|----------------|-----------------------------|----------------------|
| 0          | 1999-02-22    | John Doe       | Leander, Texas(TX), 78641   | Software Engineering |
| 1          | 1996-10-02    | Jack Hill      | Denmark, Maine(ME), 04022   | Computer Science     |
| 2          | 2000-11-14    | Samantha Jones | Dayton, Kentucky(KY), 41074 | Graphics Design      |
| 3          | 1998-04-12    | Michael Carter | Macomb, Michigan(MI), 48044 | Software Engineering |
| ...        | ...           | ...            | ...                         | ...                  |
{{< /table >}}

Student Grades:

{{< table >}}
| Student | Subject           | Grade | Year |
|---------|-------------------|-------|------|
| 0       | Mathematics       | B     | 2020 |
| 0       | Physics           | A     | 2020 |
| 1       | Computer Networks | C     | 2021 |
| 2       | Mathematics       | D     | 2021 |
| 2       | Web Design        | A     | 2021 |
| 2       | Web Design        | B     | 2020 |
| ...     | ...               | ...   | ...  |
{{< /table >}}

Here we can see that the *Student Grades* table doesn't have a standalone unique primary key, like the Students table
has, but rather it has a composite primary key, in this case, it's made of 3 columns: *Student*, *Subject* and *Year*.
We can also see that rather than defining the whole student all over again, since we already have the students table,
we can instead simply use the Student ID from which we can look up the given student from this table

I've probably went a bit over the board about databases here that I needed to, but the most important thing about them
is that the DBMS will in most cases make separate indices that make accessing or searching something in a database very
quick. For example a DBMS might make an index of the dates of birth for our student table, that is sorted and only
contains 2 columns, the primary key (student id) and the date of birth. With this index, we can then perform a binary
search when searching for the needed date of birth, from which we will then get our student ID very quickly, and in the
main database, there will also be an index that's ordered according to the student ids, so with another binary search,
we can immediately find the data about a student with a certain date of birth.

## Database Advantages

Because of the optimizations database is doing such as building separate index files that make it really efficient, a
database is an ideal solution whenever we know we will be holding a large amount of data. This is because whenever we
will need to search for something specific in the database, we can do so very quickly. This doesn't just mean a slight
improvement, with a database, you can easily get 1000x better performance than you ever could with a JSON file, because
with JSON we first need to parse out the whole JSON file, and only then we can access anything from it, and that is
without any of these helper indices.

That said, there are some ways to speed up the JSON lookups, these are done by avoiding to parse out the whole JSON
file and rather perform a simple search within that file for given term, and extrapolating from that. However this
isn't very reliable and even with something like this, we actually still wouldn't achieve the same performance as we
could with a database. This still has many reasons, not only is the database model still much faster with the binary
search from indices, it is also running as a service, which means that it can have certain data always loaded, and
ready to be returned when they're asked for, rather than having to open up a file and perform a search in it.

Another disadvantage of the JSON model is that when it is parsed, it means fully loading the whole JSON file into
memory (RAM). This works well for small things, that only hold a couple hundreds of entries, but once the file starts
to grow, we need to have the RAM capacity to accommodate for that growth.

If that all wasn't enough, there is yet another reason not to use JSON, that is additional writes. When we want to
extend a JSON file and write something new into it, we can't do that by simply appending something to the end of the
file, because JSON structure simply doesn't allow anything like that. Instead we first need to parse and load the whole
structure into memory, then edit that structure and add something we need to add, and then re-write the whole file once
again. This is extremely inefficient and so in any scenario where speed matters, JSON isn't a good solution.

## JSON Advantages

Alright, so now we know many reasons to avoid JSON, but when should JSON actually be used then, from all of this, it
seems like databases are better in every case, or is there some disadvantage to them too? Well, in most cases, the
appeal of JSON is the fact that it's text-based. With a database, even though you will usually be able to export it
into other formats, it is generally stored as a binary file, that can't really be easily edited and you will need the
corresponding DBMS to actually make any sense of it. This benefit of a plain-text format is great for things such as
API responses (or requests) and in fact, JSON is by far the most commonly used format for this.

What JSON was made for and that it can be used to represent many things, but where is it actually used? Well, the most
common use-case for this format are certainly API responses (or requests). The body of a response given from an API
will usually follow the JSON format, if it holds any data that's not a single value. While there are APIs that do use a
different standard, JSON is by far the most popular one. As can be seen in this use-case and from the reason it was
made for, JSON is really good for representing objects in programming languages. Whenever we have some data that was
already obtained from a database, or otherwise generated or stored, we can use JSON to easily represent it as text
without needing to resort to some language-specific serialization (such as pickling in python). So essentially, JSON is
a language-agnostic format for transmitting data about objects within a language.

Another useful case for using JSON is to represent data with it when the data is expected to be read by the user. These
are things like configuration files that can be directly changed by the user, however with this use-case, it may be
better to use .ini config format, or something like YAML or TOML. These formats are a bit more commonly used for config
files than JSON, and should be preferred, but JSON isn't necessarily a bad option either.

## Summary

For smaller projects, where we only really keep ~50 entries in the JSON file, it may be alright to use JSON, however if
this config is expected to be read from often, database should still be preferred. Really for any data that's
constantly changing a database would be preferred, however for static configuration or any static data that's not
really expected to be changed by the program itself, or at least not commonly changed by it, and is only read once
(usually at the start of the program) to obtain the data and not touched afterwards, JSON or similar formats are a
perfectly reasonable way of storing these data. In fact it would be a mistake to use a database for data that will only
be read once and won't be touched again, especially if the user could benefit from editing or seeing these data.

However for anything where we need to update some values constantly and re-access them later, we should always prefer a
database from using simple plain-text files. It will be a lot more efficient and you'll see a huge speed increase in
your program if you decide to switch to a database and speed matters to you.

Another use-case for databases is when you need to host the data of the database on some other machine. With a
database, we can simply expose some port and let the DBMS handle interactions with it when our program can simply be
making requests to this remote server. This is usually how we handle using databases with servers, but many client-side
programs are creating their own local databases and using those, simply because using files is ineffective.

