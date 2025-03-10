---
title: Making great commits
date: 2023-04-17
tags: [programming, git]
sources:
  - <https://chris.beams.io/posts/git-commit/>
  - <https://dhwthompson.com/2019/my-favourite-git-commit>
  - <https://dev.to/samuelfaure/how-atomic-git-commits-dramatically-increased-my-productivity-and-will-increase-yours-too-4a84>
  - <https://thoughtbot.com/blog/5-useful-tips-for-a-better-commit-message>
  - <https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html>
---

A well-structured git log is key to project's maintainability; it provides insight into when and why things were done,
for future maintainers of the project, ... and yet, so many people pay very little attention to how their commits are
structured.

The problem isn't necessarily that they don't even attempt to write good commit messages, it's that the commit they
made is not actually easy to compose a commit message for.

Another, perhaps even bigger issue is that a lot of people don't even know that there's a reason to care about their
git history, because they simply don't see a benefit in it. The problem with this argument is that these people have
simple never explored git enough, and therefore aren't even familiar with the benefits they could gain.

So then, in this post, I'll try to explain both what are the benefits that you can get, and how to make your commits
clean and easy to read and find in git history later on.

## Commit message

The purpose of every commit is always to simply represent some change that was made in the source code.

The commit message should then describe this change, however what many people get wrong is that they just state
**what** was changed, without explaining **why** it was changed. There is always a reason for why a change is made, and
while the contents of the commit (being the actual changes made in the code - diff) can tell you what was done, the
only way to figure out why it was done, is through the commit message.

Therefore, when thinking of a good commit message, you should always ask yourself not just "What does this commit
change?", but also, and perhaps more importantly, ask "Why is this change necessary?" and "What does this change
achieve?".

Knowing why something was added can then be incredibly beneficial for someone looking at `git blame`, which allows you
to find out the commit that was responsible for adding/modifying any particular line. In vast majority of cases, when
you look at git blame, you're not interested in what that single line of code is doing, but rather why it's even there.

Without having this information in the commit itself, you'd likely have to go look for the actual pull request that
added that commit, and read it's description, which might not even contain that reason anyway.

### Commit isn't just the first line

A huge amount of people are used to committing changes with a simple `git commit -m "My message"`, and while this is
enough and it's perfectly fine in many cases, sometimes you just need more space to describe what a change truly
achieves.

Surprisingly, many people don't even know that they can make a commit that has more in it's message than just the
title/first line, which then leads to poorly documented changes, because single line sometimes simply isn't enough. To
create a commit with a bigger commit message, you can simply run `git commit` without the `-m` argument. This should
open your terminal text editor, allowing you to write out the message in multiple lines.

{{< notice tip >}}
I'd actually recommend making the simple `git commit` the default way you make new commits, since it invites you to
write more about it, by just seeing that you have that space available. We usually don't even know what exactly we'll
write in our new commit message before getting to typing it out, and knowing you have that extra space if you need it
will naturally lead to using it, even if you didn't know you needed it ahead of time.
{{< /notice >}}

That said, not every commit requires both a subject and a body, sometimes a single line is fine, especially when the
change is so simple that no further context is necessary, and including some would just waste the readers time. For
example:

```markdown
Fix typo in README
```

In this case, there's no need for anything extra. Some people like to include what the typo was, but if you want to know
that, you can use `git show` or `git diff`, or `git log --patch`, showing you the actual changes made to the code, so
this information isn't necessary either. So, while in some cases, having extra context can be very valuable, you also
shouldn't overdo it.

### Make commits searchable

It can be very beneficial to include some keywords that people could then easily find this commit by, when searching
for changes in the codebase. As an example, you can include the name of an exception, such as `InvalidDataStreamError`,
if your commit addresses a bug that causes this exception.

You can then add an explanation on why this error was getting raised, and why your change fixed that. With that, anyone
who found your commit by searching for this exception can immediately find out what this exception is, why was it
getting raised and what to do to fix it.

This is especially useful with internal API, whether it's custom exceptions, or just functions or names of classes.
People don't search the commit history very often, but if you do encounter a case where you think someone might perform
a search for at some point, it's worth it to make it as easy for them as you can.

### Make it exciting to read

I sometimes find myself going through random commit messages of a project, just to see what is the development like,
and explore what are the kinds of changes being introduced. Even more often, I look there to quickly see what was
changed, to bring myself up to date with the project.

When doing this, I'm always super thankful to people who took the time to for example include the debug process of how
they figured out X was an issue, or where they explain some strange behavior that you might not expect to be happening.

These kinds of commits make the history a fun place to go and read, and it allows you to teach someone something about
the language, the project, or programming in general, making everyone in your team a bit smarter!

### Follow the proper message structure

Git commits should be written in a very specific way. There's a few rules to follow:

- **Separate the subject/title from body with a blank line** (Especially useful when looking at `git log --oneline`,
  as without the blank line, lines below are considered as parts of the same paragraph, and shown together)
- **Limit the subject line to 50 characters** (Not a hard limit, but try not going that much longer. This limit ensures
  readability, and forces the author to think about the most concise way to explain what's going on. Note: If you're
  having trouble summarizing, you might be committing too much at once)
- **Capitalize the subject line**
- **Don't end the subject line with a period**
- **Use imperative mood in subject** (Imperative mood means "written as if giving a command/instruction" i.e.: "Add
  support for X", not "I added support for X" or "Support for X was added", as a rule of thumb, a subject message
  should be able to complete the sentence: "If implemented, this commit will ...")
- **Wrap body at 72 characters** (We usually use `git log` to print out the commits into the terminal, but it's output
  isn't wrapped, and going over the terminals width can cause a pretty messy output. The recommended maximum width for
  terminal text output is 80 characters, but git tools can often add indents, so 72 characters is a pretty sensible
  maximum)
- **Mention the "what" and the "why", but not the "how"** (A commit message shouldn't contain implementation details,
  if people want to see those, whey should look at the changed code diff directly)

If you want to, you can consider using markdown in your commit message, as most other programmers will understand it as
it's a commonly used format, and it's a great way to bring in some more style, improving readability. In fact, if you
view the commit from a site like GitHub, it will even render the markdown properly for you.

For example:

```markdown
Summarize changes in around 50 characters or less

More detailed explanatory text, if necessary. Wrap it to about 72
characters or so. In some contexts, the first line is treated as the
subject of the commit and the rest of the text as the body. The
blank line separating the summary from the body is critical (unless
you omit the body entirely); various tools like `log`, `shortlog`
and `rebase` can get confused if you run the two together.

Explain the problem that this commit is solving. Focus on why you
are making this change as opposed to how (the code explains that).
Are there side effects or other unintuitive consequences of this
change? Here's the place to explain them.

Further paragraphs come after blank lines.

- Bullet points are okay, too

- Typically a hyphen or asterisk is used for the bullet, preceded
  by a single space, with blank lines in between, but conventions
  vary here

If you use an issue tracker, put references to them at the bottom,
like this:

Resolves: #123
See also: #456, #789
```

## Make "atomic" commits

_Atomic: of or forming a single irreducible unit or component in a larger system._

The term "atomic commit" means that the commit is only representing a single change, that can't be further reduced into
multiple commits, i.e. this commit only handles a single change. Ideally, it should be possible to sum up the changes
that a good commit makes in a single sentence.

That said, the irreducibility should only apply to the change itself, obviously, making a commit for every line of code
wouldn't be very clean. Having a commit only change a small amount of code isn't what makes it atomic. While the commit
certainly can be small, it can just as well be a commit that's changing thousands of lines. (That said, you should have
some really good justification for it if you're actually making commits that big.)

The important thing is that the commit is only responsible for addressing a single change. A counter-example would be
a commit that adds a new feature, but also fixes a bug you found while implementing this feature, and also improves the
formatting of some other function, that you encountered along the way. With atomic commits, all of these actions would
get their own standalone commits, as they're unrelated to each other, and describe several different changes.

But making atomic commits aren't just about splitting thins up to only represent single changes, indeed, while they
should only represent the smallest possible change, it should also be a "complete" change. This means that a commit
responsible for changing how some function works in order to improve performance should ideally also update the
documentation, make the necessary adjustments to unit-tests so they still pass, and update all of the references to
this updated function to work properly after this change.

So an atomic commit is a commit representing a single small (ideally an irreducible) change, that's fully implemented
and integrates well with the rest of the codebase.

### Partial adds

Many people tend to always simply use `git add -A` (or `git add .`), to stage all of the changes they made, and then
create a commit with it all.

In an ideal world, where you only made the changes you needed to make for this single atomic commit, this would work
pretty well, and while sometimes this is the case, in most cases, you will likely have say fixed some bug you found
alongside, or a typo you noticed, etc.

When that happens, you should know that you can instead make a partial add, and only stage the changes that belong into
the commit you're about to make. The simple case is when you have some unrelated changes, but they're all in different
files, and don't affect this commit. In that case, you can use `git add /path/to/file`, to only stage those files that
you need, leaving the unrelated ones alone.

But this is rarely the case, instead, you usually have a single file, that now contains both a new feature, and some
unrelated quick bugfix. In that case, you can use the `-p`/`--patch` flag: `git add -p /path/to/file`. This will let you
interactively go over every "hunk" (a chunk of code, with changes close to each other), and decide on whether to accept
it (hence staging it), split it into more chunks, skip it, or even modify it in your editor, allowing you to remove the
intertwined code for the bugfix from the code for your feature that you're committing now.

You can then make the feature commit, that only contains the changes related to it, and then create another commit, that
only contains the bugfix related changes.

This git feature has slowly became one of my favorite tools, and I use it almost every time I need to commit something,
as it also allows me to quickly review the changes I'm making, before they make it into a commit, so it can certainly be
worth using, even if you know you want to commit the entire file.

## Stop making fixing commits

A very common occurrence I see in a ton of different projects is people making sequences of commits that go like:

- Fix bug X
- Actually fix bug X
- Fix typo in variable name
- Sort imports
- Follow lint rules
- Run auto-formatter

While people can obviously mess up sometimes, and just not get something right on the first try, a fixing commit like
this is actually not the only way to solve this happening.

Instead of making a new commit, you can actually just amend the original. To do this, we can use the `git commit
--amned`, which will add your staged changes into the previous commit, even allowing you to change the message of that
old commit.

Not only that, if you've already made another commit, but now found something that needs changing in the commit before
that, you can use interactive rebase with `git rebase -i HEAD~3`, allowing you to change the last 3 commits, or even
completely remove some of those commits.

For more on history rewriting, I'd recommend checking the [official
documentation](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History)

### Force pushing

{{< notice warning >}}
Changing history is a great tool to clean up after yourself, it works best with local changes, i.e. with changes you
haven't yet pushed.

Even though changing already pushed history is possible, it requires a "force push" (`git push --force`). These kinds of
pushes are something you need to be very careful about, as someone might have already pulled the changes, which you then
overwritten with your force push. Now, they might've done some work from the point at which they pulled, but then they
find out that this point is actually gone from the history, and they can't push their changes back. So now, they'll need
to undo their changes, pull the force pushed branch, and carry the work over, which can be very annoying.
{{< /notice >}}

My recommendation to avoid force pushing is to reduce the amount of (regular) pushes you do completely. If your changes
are only local, rewriting history is easy, and won't break anyone else's workflow, but the moment you push, the changes
are public, and anyone might've pulled them already.

This especially applies when you're pushing directly to master/main branch, or other shared branch which multiple people
are working with. If this is your personal branch (like a feature branch you're responsible for), force-pushing there is
generally ok, though you might still have people using your branch since they wanted to try out a feature early, or
review the changes from their editor. So even with personal branches, it's not always safe to force-push.

My rule of thumb is to avoid pushing until the feature is fully complete, as that allows you to change anything during
the development. Perhaps some change you made no longer makes sense, because you realized you won't actually be using it
in the way you anticipated, or you found a bug with it later on. You can now simply rewrite your local history, and
rather than making a fixing commit, it'd be as if the bug was never there.

Once you do finally decide to push, it's a good practice to run any auto-formatters and linters, and perhaps even
unit-tests. You can also take a quick peek at `git log`, to make sure you didn't make any typos. Then, only if all of
those local toolings passed should you actually push your version.

{{< notice tip >}}
If you do need to force-push, try to at least do it as quickly as possible. The more time that has passed since your
normal push, the more likely it is that someone have already clonned/pulled those changes. If you force-push within just
a few seconds after pushing, it's not very likely that someone has pulled already, and so you won't break anyone's
version.
{{< /notice >}}

## Benefits

Alright, now that we've seen some of the best practices for making new commits, let's explore the benefits that we can
actually gain by following these.

### A generally improved development workflow

I can confidently say, that in my experience, learning to make good git commits made me a much better programmer
overall. That might sound surprising, but it's really true.

The reason for this is that making good commits, that only tackle one issue at a time naturally helps you to think about
how to split your problem up into several smaller "atomic" problems, and make commits addressing that single part, after
which you move to another. This is actually one of very well known approaches to problem-solving, called "divide and
conquer" method, because you divide your problem into really small, trivially simple chunks, which you solve one by one.

Learning and getting used to doing this just makes you better at problem solving in general, and while git commits
certainly aren't the only way to get yourself to think like this, it's honestly one of the simplest ones, and you become
good at git while at it!

### Finding a tricky bug

Imagine you've just came up with a new feature that you're really eager to implement for your project. So, the moment
you think of how to do it, you start working on it. Then, a good bit of work, you're finally done, entirely. You now
make a commit, with all of the changes.

However, you now realize that as you pushed your commit to your repo, the automated CI workflows start to fail on some
unit-tests. Turns out you didn't think of some edge-case, some part of your solution is suddenly affecting something
completely unrelated. As you attempt to fix it, more and more other issues arise, and you don't really even know where
to start. You have this big single diff for the entire feature, but you have no idea where in that is the bug.

Figuring it out takes at best a lot of mental effort, analyzing and keeping track with all of the changes at once, or at
worst, you'll spend a lot of time doing this, but you'll just keep getting lost in your own code, until you finally just
give up, and start over. This time, only doing small changes at a time, and running the unit-tests
for each one as you go.

#### Same scenario, but with atomic commits

Now, let's consider the same scenario, but this time, you're following the best git principles, and so you're splitting
the problem up and making atomic commits for each of necessary changes, that will together make up the feature.

Once you're done, you decide to push all of those commits, and see the CI fail. However this time, you have a much
eaiser time finding where that pesky bug hides. Why? Because this time, you can just checkout one of those commits you
divided your bigger task into, and run the tests there. If it fails, you can run the tests in the commit before that.
You can just repeat this until you find the exact commit that caused these failures.

At this point, you know exactly which change caused this, because the commit you discovered was pretty small, it only
changed a few dozen lines and introduced a very specific behavior, in which after looking at it for a while, you find
that there's indeed a completely unexpected fault, which you only found out because you knew exactly where to look.

#### Git bisect

This scenario is actually very common and can come up a lot while developing, because of that, git actually has an
amazing tool that can make this process even easier! This tool is called `git bisect`.

Essentially, you can give git bisect a specific start commit, where you know everything worked as it should've, and an
end commit, where you know the fault exists somewhere. Git will automatically check out the commits in between in the
most optimal way (binary search), and all you have to do is then check whether the issue exists in the checked out
commit, or not. If it does, you tell bisect that this commit is still faulty, or if not, you say it's good.

Since bisect is essentially a binary search, it won't take too many attempts to figure out exactly which commit is the
faulty one, essentially automating the process above. Better yet, if the task of finding the bug can be uncovered by
simply running some script/command (perhaps the unit tests suite), you can actually just specify that command when using
git bisect, and it'll do all of the work for you, running that command on each of those check outs, and depending on
it's exit code, if the command passed, marking the commit as good, or if not, marking it as faulty.

So, even if the test suite takes a while, you can actually just have git find the bug for you, while you take a break
and make a nice cup of coffee.

### Git blame

Git blame is a tool that allows you to look at a file, and see exactly which lines were committed by who, and in which
commit. This can be very useful if you just want to check what that line was added there for. If it's a part of a larger
spanning commit, you can then check the diff of that commit, to see why that line was relevant, with the context of the
rest of the changes done.

Having good commit history and using atomic commits makes doing this a great and easy experience, as you're not very
likely to find that commit to be addressing 10 different issues at once, without providing any real description in the
commit message, as to why, and perhaps not even as to what it's doing. With commits like those, git blame becomes almost
useless, but if you do follow these best practices, it can be a great tool for understanding why anything in the code is
where it is, without needing to check the documentation, if there even is any.

### Cherry picking

Cherry picking is the process of taking a commit (or multiple commits), and carrying them over (essentially
copying/transferring them) to another branch, or just another point. So for example, you might have a feature branch, in
which you fixed a bug that also affects the current release. Instead of checking out the release branch, and re-doing
the changes there, you can actually use cherry-picking to carry the commit from the feature branch into the release
branch. This will mean any changes made in that commit will be applied, fixing the bug in release branch and allowing
you to make a release.

However, if the commit that fixed this issue wasn't atomic, and it also contained fixes for tons of other things, or
worse off, includes logic for additional features, you can't just carry it over like this, as you'd be introducing other
things into the release branch which aren't supposed to be there (yet). So instead, you'd have to make the changes in
the branch yourself, and create another commit, which is simply slower.

### Pull request reviews

When someone else is reviewing your pull request, having clean commits can be incredibly helpful to the reviewer, as
they can go through the individual commits instead of reviewing all of the changes at once by looking at the full diff
compared to the branch you're merging to. This alone can greatly reduce the mental overhead of having to keep track of
all of the added/changed code, and knowing how it interacts with the rest of the changes.

Atomic commits then allow for the reviewer to understand each and every atomic change you made, one by one, which is
much easier to grasp. So even if when put together, the code is pretty complex, in these atomic chunks, it's actually
pretty easy to see what's going on, and why. This is especially the case if these commits include great descriptions of
what it is they're addressing exactly.

This then doesn't just apply for pull-requests, this kind of workflow can actually be useful to anyone looking over some
code in a file. You could use git blame to find out the commit, and follow the parent commits up, allowing you to see
the individual changes as they were done one by one, which again, is then easier to understand, and allows you to then
realize what the whole file is about much quicker.

### Easy reverts

Sometimes, we might realize that a change that we made a while ago should not actually have been made, but the change
was already pushed and there's a lot of commits after it. That means at this point, we can't simply rewrite the history,
and we will need to push a commit that undoes that change.

The great advantage of atomic commits is that they should include the entire change, along with documentation it
introduces, tests, etc. in a single piece, a single commit. Because of that, assuming there weren't any commits that
built upon this change later on, we can use git's amazing `git revert` command.

This will create a new commit that undoes everything another specified commit did, making it very easy to revert some
specific change, while leaving everything else alone. This is much faster and easier than having to look at what the
original commit changed line by line, and change it back ourselves, and while this isn't something you'll use all that
often, when you do get a chance to use it, it's really nice and can be a good time saver.

## Conclusion

Git is something programmers use every day, learning how to do so properly is invaluable. There's a lot of rules I
mentioned here, and of course, you probably won't be able to just start doing all of them at once. But I would encourage
you to at least stop for a while before every commit you're about to make, and think of whether you really need to stage
all of the files, or if you should do a partial add, and make multiple commits instead, and also take a while to think
of a good commit message.

For motivation, here's a quick recap of the most important benefits a good git workflow gives you:

- Your development workflow becomes easier by allowing you to find issues a lot quicker
- You can also help your team or whoever ends up reading your commits understand what's going on and bring them up to date with the project
- You will be able to quickly find out who committed something and why
- Your overall programming skills will improve, because you'll get used to dividing up your problems naturally
