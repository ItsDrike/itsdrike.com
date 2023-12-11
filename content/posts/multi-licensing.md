---
title: Using multiple licenses in a single code-base
date: 2023-12-10
tags: [programming, licensing]
sources:
  - <https://opensource.stackexchange.com/questions/9851/can-different-parts-of-a-project-be-under-different-licenses>
  - <https://en.wikipedia.org/wiki/Multi-licensing>
---

Dual-licensing, or multi-licensing is the practice of distributing source-code for a single project under two or more
licenses. The general idea is pretty simple, however I've seen many people misunderstanding some important aspects
when it comes to it. There's especially a lot of confusion when it comes to multi-licensing a repository with
a copy-left license, so in this article, I wanted to shed some light onto this practice, to hopefully make you
a bit more confident in understanding, and maybe even maintaining multi-licensed projects.

{{< notice  note >}}
This article assumes that you already know the basics of how software licensing works, and that you're familiar with
the different types of licenses (permissive, (weak and strong) copy-left, public domain). If you aren't sure you're
familiar enough with these topics, I'd strongly advice you to learn read about these before going through this article,
as you will likely not end up understanding a lot of what I'm talking about here.

But don't worry, I actually have an article explaining these basics right here, [check it out!]({{< ref
"posts/software-licenses" >}}).
{{< /notice >}}

## Multiple licenses for the same code

Licensing the same code under 2 different licenses at once may seem like a pretty weird thing to do, after all, those
licenses can each have different requirements and grant different permissions, and there's generally not much of a need
to do this.

That said, there is one very common use-case for this, which is pretty important to know about. That is, providing a
stricter (usually copy-left) license to the project for free to everyone, while also selling a less strict (usually
permissive) license for a price. This then means that if companies would want to include this project in their
proprietary code-bases, they'd need to pay to be given the less strict license, allowing this. In fact, this is often
the main way (other than donations) for open-sourced projects to make money.

This less strict license is often one, which doesn't allow the company it was sold to to distribute the project's code
any further, however it can allow that company to use the project and make edits to it's source code in-house, and
distributing a modified binary without disclosing any source, and with their project remaining closed-sourced, which a
copy-left license would not allow.

### How does multi-licensing even work?

I've already [touched on this]({{< ref "posts/software-licenses#how-are-these-licenses-enforced" >}}) in my other
article. Generally, as the owner of a copyrightable work, you can do anything you want with it, however others can't
really do much of anything, unless you give them a permission to. To do that, we use a software license, which might
however limit condition those extra permissions behind some clauses (that's why you need to follow software licenses),
these conditions can be things like mentioning the original source, stating changes, etc.

When you, as the copyright owner, give out 2 (or more) licenses with your project, anyone is free to pick either of
those, however they do need to follow at least one, in it's entirety, so that they get the rights granted by it. People
can't just pick some terms to follow from the first license, and other from the second license, since neither of these
licenses would then be applicable, as some of the conditions weren't met, and so no copyright permissions are given to
you from either of those licenses.

## Using different licenses for different parts of the project

This is a simpler case than the above, as we don't actually have any code licensed under multiple licenses at the same
time, all we have is different chunks of the code-base being differently-licensed, and this is actually incredibly
common.

You'll likely find chunks of open-sourced code thrown around in almost every bigger code-base, because it's simply
easier to re-use the already written things, than to reinvent the wheel and make up our own versions of everything.
Most commonly, this is seen through projects using software libraries. These libraries will likely be under some
permissive or weak copy-left license, and they're being used in your project along with your own code, under whatever
license you chose.

A slightly less common case would be directly using differently licensed code in your own code-base. When doing this,
you often end up having files like `LICENSE-THIRD-PARTY` next to your `LICENSE` file, where you're stating all of the
different licenses used in your project, and what parts of the project they apply to. (Note that some licenses require
more things, such as also stating changes).

Another, but much less common case is when someone contributing to the project decides to contribute their code under a
different license to the rest of the project. They can do this by mentioning their changed/added part in that
`LICENSE-THIRD-PARTY` file, or by including a copyright header in the contributed file, or a bunch of other ways.
(Though the maintainers might just end up refusing that pull request).

### Contributing to multi-licensed project

When you see a project that's dual-licensed, being publicly available under some copy-left license, but offering a
permissive license for profit, you might be confused about how contributions to such a project could then work. After
all, if you submitted your code under a copy-left license, there's no way the company could then sell a permissive
license to that code, since well, you didn't give them a permissive license, and they wouldn't have the right to
release your copy-left code under a permissive license.

This is ultimately gonna be up to the project's maintainers, and you'll often find some guide on it in the project
docs, or in a file like `CONTRIBUTING.md`. However to understand how something like this is generally done, here's a
few common methods these projects use to handle external contributions:

- Making all contributors sign a [CLA]({{< ref "posts/licensing-documents#contributors-license-agreement" >}}), which
  grants the company maintaining this project permissive rights, even though you submitted your code under a copy-left
  license, and anyone else would need to honor that license. This CLA can be pretty narrow in it's scope, only allowing
  the company to distribute your code under a permissive license, but only when they sell it under certain conditions,
  etc. However it can also be very extensive, where you will be asked to give the company complete rights over that
  code.
- Making all contributors use a permissive license, with the company maintaining the project having their code licensed
  under a copy-left license. In many cases, the company code makes up the majority of the code-base, so you end up with
  a mostly copy-left licensed code, with bits of permissively licensed code utilized in it. (See [section
  below](#using-different-licenses-for-different-parts-of-the-project) about split licensing like this.)
- Allowing contributors to pick whether they want to publish under permissive or copy-left license, keeping the code
  written by contributors who picked copy-left only available in the community/free version. However the company will
  usually try to keep version parity between these, or perhaps even having the payed permissive version include more
  features, so locking themselves from being able to get this code is pretty rare.

### Conflicting licenses

It is however important to say that if you do have a strong copy-left licensed code in your codebase, it's supposed to
force you to use that same (or compatible) license everywhere in your project, right? So is it even possible to
dual-license in cases like these? Yes!

Even though having copy-left code in your codebase will mean you have to distribute the rest of the project under the
same license, it doesn't actually force that license to be the only one. Aha! So we could leave the original permissive
license over the code in there, and on top of it add a compatible copy-left license, allowing us to use this copy-left
code.

{{< notice warning >}}
This will however still mean that when you'll be distributing your binary, since it will contain the chunk of copy-left
code, you'll have to follow the license yourself, as that license it the only thing giving you the right to use that
code, and so you'll have to for example always bundle the source code with that binary. So your project is pretty much
copy-left anyway, but you will allow others to use the rest of your code in a permissive manner, as it's also
licensed that way, and that license is usually much more friendly to others trying to use your code.
{{< /notice >}}

Since this code was originally permissive, you cold also just relicense and become fully copy-left, as permissive
licenses do allow that. That's also why you could "add" a copy-left license that now also applies to all of the
originally permissive code.

The reason why you might want to use this approach instead of just relicensing and going pure copy-left is that you
might eventually remove the copy-left chunk of code you used, and you could then go back to purely permissive license
over your project again. However if you've changed to copy-left without dual-licensing, going back might be harder (see
[this post about relicensing]({{< ref "posts/changing-license" >}})).

### Drawbacks

While multi-licensing can have some clear advantages to the project, as it allows it's monetization, it has it's
disadvantages too, mainly:

- Potential confusion for users who may not fully understand the licensing options
- Some contributors might be uncomfortable with the licensing terms, and with their code potentially being sold for
  profit, under a permissive license, making them avoid contributing completely.

### Example projects

- **MongoDB**: a popular open-source database system that uses dual-licensing. Its Community Edition is released
  under the GNU Affero General Public License (AGPL), while its Enterprise Edition is released under a proprietary
  license. This allows MongoDB to offer different features and support options to its users depending on their needs.
- **Qt**: a cross-platform application development framework that uses dual-licensing. Its Community Edition is
  released under the GNU Lesser General Public License (LGPL), while its Commercial Edition is released under a
  proprietary license. This allows Qt to offer additional features and support to its commercial users while still
  maintaining an open-source version.
- **MySQL**: another popular open-source database system that uses dual-licensing. Its Community Edition is
  released under the GNU General Public License (GPL), while its Commercial Edition is released under a proprietary
  license. This allows MySQL to offer additional features and support to its commercial users while still maintaining
  an open-source version that can be freely used and modified.
