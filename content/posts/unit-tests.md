---
title: When to use Unit-Tests?
date: 2021-08-24
tags: [programming]
---

We often talk about the importance of testing our programs, however many people don't mention at which point it is necessary to start and why sometimes it could just be a waste of time to implement unit-tests.

## The purpose of unit tests

The reason we use unit tests is simple, during our development, we're often actively changing things around and this has the potential to affect some unrelated functions in an unexpected way. This is by all means a human error, however it is very hard to prevent it and really most issues in development will be simple human errors. We simply won't expect that our changes could even remotely affect some other function and so we don't even think to check.

This has lead to pushing broken code into production many times, and even for bigger companies, because however thorough the review process may be, it is possible that the reviewer will still simply miss something like this because it appears unrelated, the code is merged into a production branch and suddenly, your project breaks in production and you need to solve this issue very quickly, or roll back the changes.

## When are they necessary?

The goal behind unit tests is simply to run as much code as possible. In fact unit-tests are often combined with tools to tell you the code covered by them (one example of such tool is <https://coveralls.io>). We do this because this is precisely what the goal of unit-testing is, to run all of the code in a project.

Unit-tests only become relevant when simply executing the project yourself doesn't automatically run every single line of code in your project. This is often the case when the program accept user input as a choice of some form, and so after a single run of the program, it would never get to the part behind the other choice. With a program as simple as this, with just 1 yes/no user choice, we still don't really need unit-tests though, because it's not a huge issue to simply run it twice and go through both of the options, but consider a program with 20 such choices, would you really be willing to go through all of this? Most people wouldn't and so the code remains not completely tested.

The importance of running all of the code in a project is very high, especially for interpreted languages such as python or javascript. This is because the compiler won't warn you when it detects that something could be wrong with the code, with interpreted languages, that code isn't looked at until it's actually ran, so you might not notice it but you could simply have a typo in a variable name that would cause the whole thing to fail, but you won't find out by simply running it because you didn't go through the lines of code that had the actual issue in them.

If you want to, in most modern languages, you can use a REPL (R: Read user input, E: Evaluate your code, P: Print out the result, L: Loop back to step 1) in which you can simply import your program and test individual functions yourself, this could be fine for some people and for smaller projects, but at this point you should already start asking yourself whether you want to be doing this for every submitted pull-request to ensure that it doesn't introduce any bugs, or whether you'd rather use an automated tool to do it for you.

## Conclusion

Unit-Tests are a neat tool and a great way to automate monotone testing of your application, but if your application runs every single line of code inside of it simply upon running it, there is usually no real reason to implement unit-tests and it would only clutter the project. However as your application starts to grow, and you start to have different branches your code can take, leading to some parts being left alone when ran in a certain way, that's the time to start thinking about whether you should implement unit-tests.
