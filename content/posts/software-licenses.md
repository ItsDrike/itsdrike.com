---
title: Software Licenses
date: 2022-01-23
tags: [programming]
---

I wanted to talk a bit about what are software licenses, what different types of these licenses are there and why are
they really important to know about and to know which one you like the most. Choosing a wrong license for your projects
may lead to your code being used by others in ways you don't like and depending on the license you chose, you may not
even have a way to really do anything about it. It is also important so that you personally won't misuse any code.
Stealing code is illegal and you may get in trouble for it, so it is always good to know what you can and can't do with
the code of others.

## Why are licenses important

Whenever you publish essentially anything, not just source code, you automatically gain copyright over that content (at
least in most countries, there are some which don't really respect the copyright law, but that's very rare). This
copyright imposes pretty big legal restrictions on that content. Essentially, this means that even though you may have
decided to publish your code on a website like GitLab or GitHub, you only made it "source-available", not
"open-sourced". This is because for a project to be considered open-sourced, it must meet some very specific criteria,
namely, it needs an open-source license. The reason we don't call source-available code open-source is because even
though the author of these projects as the copyright owner have published his work for anyone to look at, this doesn't
give others the legal permission to actually re-use this code or alter it in any way.

This means that everybody who would be interested in improving this code, or making derivative works from it would
actually be breaking this copyright law. Even if they made no changes to it, just creating a "fork" is already a
violation of this law. Think of it as if you were keeping a copy of some movie on your machine, or even hosted on the
internet somewhere without any permission from the company that made this movie. Obviously, you can't do that, it's
illegal, and so is doing the same with source-code without a license from the copyright owner that allows it.

Most people interested in making their source code available are actually also interested in getting others to use
their project in their own source-code perhaps integrated as a library, or in any other way, and more importantly, they
are looking for others to help them with their projects and contribute to them to make these projects better for
everyone. This is precisely what an open-source license allows. There's countless amount of these licenses, and many of
them are written by individuals without any legal knowledge, which may be dangerous. For that reason, the Free Software
Foundation (FSF) has a curated list of [FSF approved
licenses](https://software.fandom.com/wiki/List:FSF_approved_software_licenses) out of which all of them are guaranteed
by the FSF to legally make sense and to indeed allow this source code sharing, so you should really only pick one of
these licenses unless you have a good lawyer who can confirm that the license you decided to use, even though it wasn't
on this list does make legal sense and is legally enforcible.

But there are many types of licenses that allow others to use your code with different kinds of permissions and
restrictions imposed on them while using this code, most commonly for example the need to mention the usage of the
original project in a derivative work.

## License types

Learning about different licenses may be a bit confusing at first, and I would always suggest to do your own research
as I am not a lawyer and I do not offer any legal advice here. All I will do is try to explain the basic categories of
the open-source licences and explain what these categories represent, but once again, don't just blindly trust some
random guy on the internet, do your own research before picking a license and ensure it will really be exactly what you
want it to be.

### Copy-Left licenses

These licenses allow others to use your code, whether it means building a derivative project that can do certain things
differently from your original code, but still uses a lot of the original code-base, or just utilizing a few snippets
of your code-base for example just a single function, or even just using this project as a library, being integrated in
some bigger scoped project which needs the logic of your project internally.

The main point of this type of licenses is that they require all projects using work that's licensed under them to also
use that same copy-left license. This is called propagating the copy-left. This basically means that if some other
project would like to include some part of your code into their code-base, no matter how big the part is, or if it's
the whole project, used as a library, they would need to license their code under the same license that your original
code code has, or at least a compatible license (propagate the copy-left).

This behavior of copy-left licenses propagating themselves and prohibiting being licensed under any other
(non-compatible) license is called forbidding sublicensing. Some copy-left licenses do actually allow you to change the
license, but only to a selection of a few other copy-left licenses with similar terms, even though they wouldn't
necessarily be "compatible" licenses legally, as they may enforce different set of rules, they can still include a
clause allowing for such sublicensing. This is often done to allow for easily updating the license to a new version of
it. As without a clause like that, changing licenses may get tricky, I will talk about this in another section later as
it can be a pretty involved process. However be careful with this as even though one license may have a clause allowing
you to sublicense your content under another, that other license may not have the same clause allowing you to go back.

Usually, if your project is compilable into a single executable file (or multiple executables) copy-left licenses can
require shipping the license and the entire source-code (or at least the parts covered by this license), or at least a
link to a website on which this source-code is hosted along with that executable. This ensures that there is no way the
code could go closed-source, because it can't even be shipped without the source-code. 

Note that they don't however usually forbid the software from being commercialized and sold for a profit, but whenever
someone would decide to buy this software, they would receive it along with it's source-code and the copy-left license,
and after that they could simply make their own derivative works and distribute those for free if they wanted to, since
the license allows that. This makes it really easy for anyone to just buy the software and then distribute the exact
same copy of that source-code for free to anyone, making it mostly pointless to even sell it in the first place,
however it is important to mention that it's possible nevertheless. 

What's perhaps a bit unintuitive though is the fact that it actually is possible for a copy-left licensed software to
be kept private for example just to a company that's using that software internally. However keeping it private is
quite difficult as by being copy-left, the source code and the license will have to be shipped with the executable,
even internally. This means that any employee could just take a look at that source code and decide to publish it as
the license allows them to do that. Another way to keep a copy-left licensed code private would be to just use it
personally, because the code is available to you when you made the executable, you're following the license and yet
you've just made a private copy-left licensed code, though that's only the case as long as you don't distribute it, or
if you do, as long as that person doesn't decide to release it publicly, as the license shipped with that software
allows them to do that. Although there are actually some licenses which prohibit even something like this, those
requirements make these licenses really hard to follow so there aren't that many people actually using them.

There can be many little caveats to these licenses and you should always make sure you understand what that license is
allowing/denying before you decide to use them.

The most popular copy-left license is the GNU General Public License version 3 (GPL v3), but version 2 is also still
quite popular. Another a bit less commonly used is the Mozilla Public License (MPL).

### Permissive licenses

Similarly to copy-left licenses, this type of licenses allows usage of the original code in almost any way
(derivatives, using small chunks, using code as library, ...), however unlike licenses in the copy-left category,
permissive licenses do allow almost any form of sublicensing.

This said, even though sublicensing may be allowed, it doesn't mean there aren't any conditions which may need to be
met before the code can be sublicensed. Most notably the requirement to mention the original copyright holder(s) and
perhaps to ensure the original author won't be held liable for any issues with the source or clauses which can forbid
things like patenting.

This means that permissive licenses give others a lot more freedom because they allow changing the license of a project
that's using parts of your code, but this means that anybody could simply take your entire project, change it a bit and
close-source it, while just respecting the terms of your license (most likely just being the original author mention),
after that the person/company utilizing your code could easily release the product as a payed software without having
to show what the code is actually doing at all. And since the code is now closed-sourced they could even decide to add
all kinds of trackers constantly sending everything you do with that software to them and perhaps even some nefarious
things, such as integrating a full-blown crypto-currency miner that's running in the background at all times while
you're using this project.

Things like these are unavoidable with a license allowing this much freedom, and even though it may require the project
to follow some guidelines, they usually aren't that strict and if it's just mentioning the source, this mention can
easily be lost along with thousands of other mentions because the project may rely on many other things too.

However the proponents of this license like this fact because even though it may mean their software will be used along
with these non-privacy respecting things added on top, at least it means that a big part of this new project is
open-sourced and it may even bring the companies/people using this open-sourced software to contribute back to it,
therefore helping it to grow and improve the features it supports. While they could do this on their own in their
versions of that software, they usually don't do that simply because it gives them more code to maintain, while
contributing it to an open-sourced project that they will then use will mean others will maintain that code for them,
whether that's other people, or even other companies following the same logic.

The most commonly used permissive licenses are the MIT License and the Apache 2.0 License. Another really popular
set of licenses are the BSD licenses, most notably the BSD 2-Clause license.

### Public domain licenses

There are also the so called "public domain licenses", which are actually technically a subtype of permissive licenses,
however when we talk about permissive licenses, we generally don't really refer to the public domain ones, even though
they technically meet the definition of a permissive license. This is why I separated this category since it's quite
different from the general permissive licenses.

Public domain licenses essentially strip the copyright away completely. This basically gives everybody the rights to do
pretty much anything with the code. They don't impose any extra restrictions (such as mentioning the original
source/author) and they obviously allow sublicensing.

Depending on the country you're in, these licenses may act a bit differently as not all countries allow "removing" the
copyright from your work, instead you can "assign" the copyright to the public domain on an equivalent of that in other
countries. This could basically mean that everyone is the copyright holder of said work giving everyone the rights to
do absolutely anything with that work as they're basically considered as the owners of that work.

The most notable public domain license is the "Unlicense" license.

### Strong and weak copy-left

These are subtypes of the wide copy-left licenses category. I didn't initially include it in the copy-left section
because it was already quite big and I wanted to just describe the category itself before getting to some specifics,
also I wanted to describe the permissive licenses before getting to the definition of these subcategories as it does
rely on this definition.

Basically, the "strength" of a copyleft license is determined by the extent of the license's provisions on the
different kinds of derivative works. This sounds complex, but the difference isn't actually that hard to understand.
Simply the "stronger" the copy-left license is, the less exceptions are there for a derivative work to not inherit that
copyleft and with it the requirement of propagating the license.

In other words, the "weak" copy-left licenses are those where there are exceptions to inheriting a copy-left and there
can therefore be some derivative works made which won't actually fall under the copy-left guidelines of that license.
For these derivatives, the license actually becomes permissive and they can be sublicensed, and even become closed. As
opposed to "strong" copy-left licenses, which don't carry any exceptions like these and every single derivative work,
no matter how little of the original project's code was used, or in what manner it was used, will inherit the copy-left
and will be forced to be license under the same (or compatible) copy-left license.

This makes weak copy-left licenses somewhat of a compromise between strong copy-left and permissive licenses where you
may want to allow sublicensing if a derivative meets some criteria, such as if someone just wants to use your work as a
library, in which case they could sublicense and use your code as if it were under a permissive license, but in other
cases, such as someone wanting to make a full-fledged alternative where they're going to be making changes to your code
and building on it, they will be required to inherit the copy-left and use the same license.

Another way a weak copy-left can behave is a file-based copyleft. This means that any file containing copy-left code
will inherit that copy-left and will therefore need to be licensed and distributed accordingly to the terms of that
license, however your derivative project may only include one file out of thousands in a codebase under this weak
copy-left license, this would mean instead of you having to license the entire project as copy-left, you'd only need to
license that file(s) in which that copy-left code is present, everything else can still stay permissive, or even closed
sourced in this project.

Do note that this could end up causing some legal "gray zones" when that copy-left license isn't clear about when the
copy-left should propagate, and when it can be permissive, and it is important to say that these weak copy-left
licenses weren't yet tested in court.

- The most commonly used weak copyleft licenses are the 
    - **Lesser General Public License (LGPL):** Libraries are treated permissively, major derivatives inherit copy-left
    - **Mozilla Public License (MPL):** File-based copy-left that ensures all of the copy-left licensed parts remain
    copy-left licensed, even though they could end up being a part of a proprietary closed-sourced project. It also
    allows the project's contributors to terminate the license for their copyright code only (the code that was
    contributed by this author under this license) by sending a written notice to the projects using this MPLed code,
    but only to the parts of the MPLed code copyrighted by that author. This license treats files as the boundaries
    between MPL-licensed and proprietary parts, meaning either all code in a file will be MPL licensed, or none of it
    will. (i.e. using just a bit of MPLed code in a file makes the whole file fall under MPL).
- The most commonly used strong copyleft licenses are the 
    - **General Public license (GPL):** The license that defined copy-left
    - **Affero General Public License (AGPL):** Extension of the GPL (an even stronger copy-left) that enforces source code
    publishing even for a "service" use case (I won't get into details about that here, look it up if you're interested)
    - **Sybase Open Watcom Public License:** One of the strongest copy-left licenses which prevents the "private usage"
      loophole of the GPL (which allows source-code modification when you "deploy" the software for private use only,
      even for testing while developing a project covered by this license.) and requires source code publishing in any
      use-case. However this can be way too limiting and basically makes it really hard to even develop the software
      covered by it because each time an executable is built, the srouce-code has to be made available, which lead to
      FSF not accepting this license as "free software license". Therefore usage of it, while making the project
      "open-sourced", does not make the project a "free and open-sourced" project.
    - **Design Science License:** The interesting thing about this license is that it can apply to any work, not just
    software/documentation, but also literature, artworks, music, ... (however it became irrelevant after the creation
    of "creative commons" licenses.)

## How are these licenses enforced

It is important to understand how exactly the software licenses actually work. How does simply having a text file with
some legal gibberish allow others to use that project and contribute to it?

Essentially, these licenses extend the copyright of the person who submitted some code under that license. By doing so,
they and allow using of said code in other places, it's modifications, and other things, depending on the actual
license. But that license is usually the only thing that give others the right to use that code in these ways. 

These licenses are therefore able to enforce themselves, because the moment you violate the terms of that license, it
no longer applies to you. At that point, you still have the copyright law to consider. It's entirely possible that you
could've had a permission from the original author to use the code in the way you did, even if it isn't following that
project's license. This is because that person explicitly gave you some rights to do certain things with their
copyrighted work, so basically, they extended their copyright of that work to give you some additional rights. But if
this agreement also didn't happen and you were in violation of the main license, you don't have any other legal
permission allowing you to use the copyrighted work, which puts you in violation of the copyright law.

Whenever you're in such copyright law violation, the significance of such violation will depend on where you live. Some
countries don't even respect the copyright law, allowing you to use whatever code you want as there's no law to violate
if your country doesn't actually have the copyright law at all, however most developed countries do respect copyright.
If you live in one of the copyright-respecting countries, you'll just need to learn how they handle copyright
violations. It may be the case that before any legal case can be made, the author must send you a copyright violation
letter (so called: `ciese and desist letter`). However if your country doesn't require that, you may simply find
yourself facing a lawsuit for copyright infringement without any prior warning.

As you can see, you can't actually "violate" a software license, rather if you do not meet the conditions of said
license, then the license doesn't apply to you and you do not acquire the permissions granted by it. Unless you've
acquired these permissions by some other means, you are violating copyright, but you aren't violating the actual
software license as it isn't a license that you've signed or anything like that, it's just something giving you the
possibility to use that work, if you follow it. That said though, in practice you often hear about a license being
"violated", but what's really meant by that is that since you didn't meet the conditions of that license, hence you're
violating copyright.

So remember, a software license can only ever give the recipient of the creative works additional rights, it can never
takes away rights.

## Picking your license

While you aren't required to add a license of any kind to any of your source-available projects, it's a bit weird to
have a project's source code available without any license giving others rights to actually improve it and use it. At
the moment, all of the contributors to such projects are actually breaking the copyright law which isn't ideal (unless
they live in a country which doesn't respect copyright, but again, that's very rare). Even though I'm sure most people
with projects like these don't actually have the intention to sue it's contributors, authors of these projects
technically could. That's a bit unexpected for the contributors and it could make contributing to projects like these a
bit scary, and it would certainly discourage many people from not just contributing, but possibly also using this
project at all.

**Some great websites:**
- There is a [page from GitHub](https://choosealicense.com/) that may help you pick the correct license for your
  project.
- Another website to help you pick a license is the [license picker from heathermeeker](https://heathermeeker.com/open-source-license-picker/).
- You can also check out a post in the GitHub docs about licensing projects
  [here](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/licensing-a-repository)
- Yet another wonderful site you should check out is <https://tldrlegal.com>, which can quickly show you the details about
what a given license requires from others when they use your code, and what rights it gives them.

## Limitations

Before picking your license, you should be aware of the limitations it may create for your project. While you can
obviously pick any license for your projects whatsoever (including no license at all), if you pick a permissive
license, you immediately loose the right to use any copy-left licensed code (unless it's a weak copy-left and you're in
the exception). It is therefore very important to know your dependencies and the licenses of the code you're using in
your codebase directly.

You as the author of that project do need to follow the licenses of the other projects you're using in your project.
Even with permissive licenses, there may be certain terms you need to follow in order to meet the conditions of that
license and be allowed to use the code from that project. Most commonly this will be the requirement to mention the
usage of said code/mention it's copyright holder/mention the original source repository/... 

In vast majority of cases, if you're using a packaging system (such as pip for python, npm for node, cargo for rust,
...) these will create dependency listings, which will often fulfill the requirement and it's possible to get it's
source url because of that package manager. Luckily, most libraries are generously licensed under weak copy-left or
permissive licenses, and they don't really have any other terms that would make things more complicated apart from just
a simple mention, even if that's just done by the package manager in the project's dependencies. However it may not
always be the case, and for those cases, you may need to do something special apart from/other than just a mention like
this to fulfill that license, and if you aren't willing to do that, you simply can't use that project.

Even if you're licensed under a copy-left license and you're using some copy-left repositories code licensed under the
exact same license, just having that license may not be enough to fulfill it's terms, in fact in most of the cases it
won't be. You will often need to mention the original source (again, if it's a dependency, a simple listing may be
enough for this), not make any software patents with that license, not use the project's trademark, state the changes
from the original project, etc. So no matter if your licenses are permissive or copy-left, there may be other terms and
you need to make sure they're followed, otherwise you may be violating that license.

To avoid things from getting too messy, you may want to make a file that will explicitly mention which parts of your
codebase aren't actually licensed under the main license, but instead belong to someone else and are licensed
differently. In fact some licenses even require your project to have such a file. In there, you'll often want to
include full text of that other license and then below (or above) the copyright holders/links to original sources/other
stuff which said license requires. This can make it a lot easier to keep track of which parts of your code-base aren't
actually covered by your main license, but are instead using some other license. It can also keep you from making
mistakes if you wanted to change a license as you'll immediately see if you have some code that isn't compatible with
some new license you'd like to relicense to (more in the changing license category).

## Changing the license

If you initially licensed your code under a certain license, and after reading this (or really for any reason and at
any point) you decided you want to change that license, you may run into some problems.

### The easy part

If nobody else owns the copyright to your code and you don't have any internally used incompatible code with the new
license (copy-left dependency or code), you can relicense, your code is yours to do whatever you like with. But once
other contributors are added to the equation, things get a lot more complicated. If that's the case, follow the messy
part below.

If your code was initially licensed under a permissive license, you're usually fine as you can sublicense because of
that permissive license, no matter if the next license is going to also be permissive, or if it will now be copy-left,
or even a proprietary license. Of course the licenses of all of your dependencies are most likely also permissive if
your main license is permissive so they should also be compatible, but again, permissive licenses may have some
exceptions to relicensing and while this is pretty much never the case with FSF approved ones, you should always make
sure.

### The messy part

However if your project has multiple contributors and it's licensed as copy-left, you will have more work to do. First
of all, check if you have some copy-left licensed dependencies/parts included in your codebase, and if you do, ensure
all of them will be compatible with this new license (most likely they won't be as just a slight change to a copy-left
license usually means it's no longer compatible, but there may be some compatibility clauses in your license allowing
this). Note that even if the license you're switching to is compatible with your main project's license, it doesn't
necessarily means it's also compatible with the copy-left dependencies, since they could've only been compatible with
your current (old) license because of some compatibility clauses, which however don't also extend to that new license,
even though your current license has a compatibility clause with it. This can sometimes get really complicated, however
luckily most people usually stick to only a few common copy-left licenses and compatibility questions about them were
already answered, just look them up.

If some of your dependencies aren't compatible though, you'll need to remove them and use something else, or write it
yourself. Otherwise, the next step will be to check if your main project's license is compatible with the new one, if
it is, it's completely safe to change the license, just like it would be with a permissive licensed project.

However, if the main license isn't compatible, which will basically always happen if you're going from copy-left to
permissive, but also if you're just going to different copy-left license without an explicit compatibility clause, you
will face some issues. 

If you are the sole copyright owner and all of the dependencies/code parts are compatible, you can just switch as an
owner of that code, but that's often not the case. In which case, you will have some other contributors, which hold the
copyright to certain parts of your project. Each line of code added by someone else will mean the copyright will belong
to them (unless it's explicitly stated otherwise) and you can't simply change the license as these other copyright
holders originally submitted their code under the terms of the main project's license, which didn't allow you to change
it.

Don't worry though, there is a way around that, but it's not particularly easy to achieve. Your next step now will be
to find a legal way to still change the license, which is only achievable in 2 ways. First way is to just remove all of
the code by any other contributors, which will most likely mean you'll need to rewrite a lot of the project yourself
without using any of the code from those contributors, the other way is to get their written consent that alters their
copyright on that work and allows you to sublicense. This can be done by either them assigning their copyright to that
code to you completely, or by them extending their copyright to also include a different license terms being the new
license you want to sublicense under (or some other license which allows sublicensing like that). This won't be easy as
you'll need to find out some way to contact all of these contributors, and even if you can achieve that, getting their
written consent to relicense can be very difficult.

This is why in most realistic scenarios, if you will be relicensing with a lot of contributors, you'll end up having to
go with a mixture of those two options and rewrite the code of the people you weren't able to reach/didn't give you the
consent to relicense, and use the written consent of the rest.

It's probably clear by now that changing a license of a copy-left licensed work is really hard, but that's very much
intentional, after all copy-left is here to prevent license changes unless the contributors agreed to it, either via a
clause in that license directly stating that it allows sublicensing to some other license (usually next version of
itself), or via an explicit permission from said contributor. 

## Common legal documents about licensing

In many projects you'll find out that before you're allowed to contribute something to an open-sourced, you'll be
required to sign a document stating certain things. This is mostly the case of contributing to projects maintained by
big companies, but what are these documents for, and should you be signing them?

### Contributor's license agreement

Following the relicensing category, it should be clear that any copy-left licensed project wishing to relicense won't
have it easy and it may take years to gather the consents of all of the contributors to actually achieve that
relicensing. Because of this, many companies chose to instead just get this consent beforehand, with what's called a
["CLA"](https://en.wikipedia.org/wiki/Contributor_License_Agreement), which is a short for "Contributor's License
Agreement".

CLA is a legal document that each contributor is required to sign before the company will allow any code from said
contributor to get into their (usually copy-left licensed) codebase. This agreement states that all code contributed by
the person who signed it will have it's copyright transferred over to that company. Making this company the single
copyright owner and therefore making it really easy for them to change the project's license if the current license
became inadequate.

But know that signing an agreement like this is very dangerous if you care about that code staying open-sourced. The
copy-left licenses are great because they're enforced by the combination of various small copyrights present in that
codebase, but the holders of these copyright each agreed to distribute their work, so long as the conditions of given
copy-left license will be followed. But when there is a single owner of the entire project, as I said before, it's
their work, they can relicense under anything they want. This includes closing down the project and licensing under a
proprietary license, and you as a contributor, even if you wrote over 50% of that code, because you've assigned your
copyright to that company, won't be able to do absolutely anything about this relicensing.

This is why if you're going to be signing a CLA, you should at least make sure that they include a "transfer
back/nullation" clause that doesn't allow them to relicense the code under any closed source proprietary license, so
you at least make sure the code-base will always end up being open-sourced, even though it may not end up being under
the same license. These nullation clauses can be as specific as desired and can even enforce staying on copy-left
licenses, or staying on some specific type of open-sourced licenses. But most companies wont' actually include clauses
like these in their CLAs and while you can ask them to include it, you most likely won't have much success with that
and instead your contributions will just be declined. 

So just be aware what signing a CLA really means and that after you do so, you've given that company the rights to do
absolutely anything with your code, no matter the initial license that code was released under.

It is also very common for employees with a clause in their contract that states that all of the work they do while
inside of that building/while using the companies computers/while contributing to company-owned source code/..., you as
an owner of that creative work you made assign the copyright which you automatically gained to that company, therefore
making it the sole owner of all of the source-code (and other things) maintained by them even though it wasn't written
by them. 

This is basically a CLA, except it's usually way more invasive, i.e. it doesn't just apply to the work you submit to
companies projects, but also personal work, if you worked on it on their machines/in their building/... This is often
the reason why many people who developed their own projects which grew a bit bigger got legally transferred over to
some company they once worked in, just because they wrote even just a single line of that project on that companies
computer, immediately giving your copyright to that project over to that company. So be careful to inspect the terms of
your contract when getting a job as a programmer, and make sure if you're working on some personal project to not do so
while on the job.

### Developer Certificate of Origin

A ["DCO"](https://en.wikipedia.org/wiki/Developer_Certificate_of_Origin), or Developer Certificate of Origin is a legal
document that deals with ensuring that all of the code you submit to some codebase is indeed owned by you, or you have
a legal right to use it and contribute it to that codebase. It also requires you to have the right to assign this
contributed work to the license of that project, which extends the copyright of that code accordingly to the terms of
that license.

This kind of document is pretty important because without it, it would be the owners of that repository who would face
legal issues if their project contained some code it wasn't allowed to use and especially for bigger projects, but for
smaller ones too, it can be very difficult to verify that the code a contributor wants to add is actually their code to
begin with. Making all contributors sign this document before allowing them to contribute to the repository is a way to
ensure that the project's maintainers won't be the ones facing the legal issues for having code that they didn't have
right to use in their project, but instead it will be the person who contributed it who will be held liable. Of course,
this code will still be required to be removed from this project, even though it wasn't the fault of the maintainers
that it got included, but at least they won't be facing any fines or things like that and instead it will be the
contributor facing these.

This solution isn't full-proof and the project maintainers may still be the ones held liable even though a DCO was in
place, however it will at least mean that the maintainers themselves can then hold the contributor liable which usually
does a good enough job of scaring anyone who'd want to add a code they don't have the rights to into a codebase as
they'll now know that they could be facing lawsuits after doing so.

I think it makes sense for projects to include this document and you generally shouldn't be afraid to sign it (so long
as you're not submitting any stolen code, which you really shouldn't be doing even if there isn't a DCO in place). It
gives the maintainers at least some level of certainty that the submitted code isn't stolen and unlike a CLA, it
doesn't really do anything with your copyright rights to that project, it just confirms that you do in fact hold them.


## My personal preference

In my opinion, to truly support open-source as much as possible, I try to stick with copy-left licenses, because it
prevents my code from ever becoming proprietary as anyone wanting to use my copy-left licensed code will need to
distribute it's source-code along with the executable and they will need to follow the exact terms of the license which
I've picked.

In most cases, I go with strong copy-left, specifically with the simple GPL v3 license, as it meets all of the things
I'd want from a license, however when I'm making libraries which I know many people may end up using, I don't want to
discourage that usage by propagating the copy-left and requiring these projects to also use GPL as many people don't
like licensing their code under something copy-left, so I use weak copy-left there, specifically LGPL. Although to
truly support open-source, it can sometimes make sense to use strong copy-left even on libraries, as it forces everyone
using it to also keep their project open, and therefore this could really help grow the open-source community even
more. Also, do keep in mind that LGPLed code isn't GPL compatible and therefore if you do make an LGPLed library, you
won't be able to use any GPLed code/library in it!

Another great license to consider is the Mozilla Public License which came up with the very interesting file-based
copy-left propagation and therefore enforces all of your code to always stay open, even if it lives in an otherwise
proprietary codebase. I also find the clause allowing individual copyright holders being able to withdraw all code
covered by their copyright licensed under MPL from a given code-base simply by sending a written notice to do so really
interesting, however it could also be somewhat risky, both for people deciding to use your MPL code in their codebase,
as that project could basically immediately be destroyed by someone owning the copyright to a lot of the code of that
project but also to your project specifically because of the same reason. If you have someone interested in your
project who has already contributed a lot of code into your codebase suddenly change their mind (perhaps because they
now want to make their own competing project, or really any other reason), suddenly you may be forced to take out all
of their code from the code-base of your own project, which is why I'm hesitant to use it in many places, however it
remains very interesting to me and I may change this opinion over time.

I'm generally against permissive licenses though as in my opinion, they well .. give out too many permissions. I get
the people who license their code under these licenses, interested in bigger companies using their code/libraries in
their projects and perhaps getting some contributions from these companies back into your codebase, improving your
project, I feel like it's too much of a threat to open-source. The thing is, if we didn't use any permissive licenses
and instead only used strong copy-left everywhere, these companies with their proprietary code-bases would either need
to write and maintain everything from scratch, which would be near impossible even for really big companies, or simply
be forced into also using these copy-left licenses and make their code open, which would be, at least in my opinion, a
really nice thing, as it would allow us to make derivatives of those works because of these freedom respecting
copy-left licenses, allowing us to make alternative versions to basically all software out there that's completely for
free and without any telemetry at all. Of course, this is quite unrealistic to actually happen anytime soon, but if you
think it's a nice idea, you can at least do a little bit by keeping your code copy-left licensed.

Then again, this is purely my stance on this and you should make up your own mind and decide what works best for you,
I'm not here to force my opinion on anyone, but I did want to express why I feel the way I feel about permissive
licenses and what I like using, in hopes that someone will perhaps not have considered these arguments and may be
persuaded to also use copy-left and expand the open-source community by it, but again, I wouldn't want to force that on
anyone, it's your work and you can license it any way you want.
