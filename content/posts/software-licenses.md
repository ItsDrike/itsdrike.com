---
title: Software Licenses
date: 2022-01-23
tags: [programming, licensing]
changelog:
  2023-12-10:
    - "Rewrite many long and hard-to-read sections"
    - "Make use of the new notice boxes"
    - "Add licensing tag to keep posts about licensing together"
    - 'Move sections about CLA and DCO into a [standalone post]({{< ref "posts/licensing-documents" >}})'
    - 'Remove sections about changing license, in favor of a [standalone post]({{< ref "posts/changing-license" >}})'
    - 'Create new related [post about multi-licensing]({{< ref "posts/multi-licensing" >}}) (not previously mentioned at all)'
---

I've recently been coming across more and more developers which had no idea about the importance of software licensing,
how it works and what options there even are. What's worse, this lack of knowledge means people often end up not
choosing a license at all, thinking it means anyone can just use that code without limitations, when in fact no-one
can.

I've always been very interested in software licenses, and have accumulated a lot of knowledge about them over time, so
I've decided to share this knowledge and explain the basics of how licenses work, what enforces them, what different
types of licenses we have, and perhaps most importantly, why you need to use a license if you want to maintain an
open-source project. Along with just explanations, I've also included some of my personal thoughts on what I like to
use.

## Why even have a license?

Many people often assume that unlicensed code is free, and anyone can use it anywhere they want, because there is no
license prohibiting that use. This is a big misconception which has lead to many lawsuits against small developers, who
just didn't know any better.

The reason you can't use unlicensed code is simple, whenever you publish essentially anything, not just source code,
you automatically gain copyright over that published work. This copyright then imposes some pretty big legal
restrictions to others on this published content, including preventing you from simply using it in your own code.

Generally, this means that when publishing your code without a license you are the sole copyright holder and no one
else has any rights to that code. We often call public code like this "source-available", instead of "open-source",
because while people can look at the code, inspect it, perhaps even find and report issues about it, they can't use
this code in almost any other way. This means that an unlicensed project can't have any (legal) contributors, because
even the action of making a fork will be considered illegal, since the contributor will be copying your code without
permission.

{{< notice note >}}
The exact restrictions will vary from country to country, because each country can have their own copyright law, and
there are even some countries which don't respect any form of international copyright law (but that's quite rare).

Even though in most of the cases the copyright law is pretty similar with only minor differences in punishments and
enforcement, it does not mean that there can't be any differences. Because of that, the info above may not necessarily
be true for every country, and as always, you should do your own research (or delegate it to a lawyer you trust).
{{< /notice >}}

For these unlicensed repositories, it leads to losing many potential contributors, who would like to make some changes
to this project to improve it, but decide not to, because by doing so, they would put themselves in danger of getting
sued for copyright infringement. That's why whenever I see a project without a license, unless it was intentional, I
open an issue, or try to otherwise contact the author to inform them about this.

{{< notice warning >}}
The worst case scenario that you can get into with an unlicensed code-base is that people do in fact decide to
contribute, and you accept that contribution.

Not only did the contributor just break the copyright law by modifying your code without legal permission, now that
their unlicensed code is in your project, you can't legally modify it either. So it's not just the contributor who may
get in trouble, it's also you who the contributor can now press charges against for violation of their copyrighted
code.

You as the author can't even go and add a license now, since there is code from others that you don't own, and so you
can't simply relicense them. Solving this could then be very difficult, see my: [relicensing post]({{< ref
"posts/changing-license#unintentionally-proprietary" >}}) for more details.

This is why you should steer far away from any unlicensed projects, and make absolutely certain that your project
always have a license, or if they should be proprietary, make sure to explicitly mention that in your `README` file,
and don't accept any contributions.
{{< /notice >}}

## How can a license make code open-sourced

In order to make your source code classify as "open-source", it needs to be made freely available for anyone to copy
and modify, without the contributors worrying that they might in legal trouble just for trying to improve the project.

To give someone these rights, you can use a license which specifies that you, as the owner of the copyright to your
code, freely give out certain rights to everyone. This license is here to essentially "weaken" your copyright in that
you reduce the restrictions it generally imposes on others, because they were freely given out through the terms of
your software license.

These licenses can then also specify certain conditions, which limit when can the code be used by others. Picking a
good license for your projects then means understanding what freedoms does the license give out, and under what
conditions.

## How are these licenses enforced

It is important to understand how exactly the software licenses really work. How does simply having a text file with
some legal gibberish allow others to use that project and contribute to it? After all, they didn't need to legally sign
anything, so why should they be forced to follow that license's terms?

Well, the answer to that is simple, you don't need to follow the terms. The only issue is that if you decide not to,
you lose the only thing giving you the extended copyright permissions to use that code, so while you don't have to
follow the license, if you don't, you won't be able to use the code. You can think of it as the copyright over that
code itself being extended to be usable by anyone who meets certain conditions. So it extends over that category of
people. If you're in that category, you can use the code, if you're not, you don't have those right.

However, in some cases, you might have a different license given to you by the copyright holder, or maybe you are the
copyright owner (copyright ownership can even be transferred, and it's often sold), in which case, you already have
these rights even without following the license, so you can actually completely ignore it.

It's actually very common for many projects to be licensed under a stricter license for general usage, that doesn't
allow using this code in closed-sourced projects, with the authors selling a more permissive license for profit to
corporations which do need to use this project in their proprietary code bases. In many cases, this is the main way
these open-sourced projects make money. I explain this a bit further in my [post about multi-licensing]({{< ref
"posts/multi-licensing" >}})

So essentially, licenses aren't enforced, nobody will force you to follow them, you just need to do so if you want to
gain the rights that license grants you.

## Contributing to a licensed project

A question that you might have now is about how will your code be licensed if you contribute to a project. The answer
to this may be pretty obvious, but it is important to explain nevertheless.

Basically, if you pick a repository under say a GPL v3 license, fork it, change some things and make a pull-request
back to the original repo, you're offering this code to that project under the same (GPL v3) license. This is because
the LICENSE file in that project generally applies to the entire project, and you've added some code to a project with
this LICENSE file, meaning just as if you added this file to your own project, you've contributed to this project and
hence offering your code to it under this license.

However this isn't the only way to do it. There may be cases when you want to explicitly state that the code you've
contributed is actually under some other license, like MIT for example. To do that, projects generally use another
file, like `LICENSE-THIRD-PARTY`, where all of the differently licensed code chunks are stated, along with the
copyright holder (usually a name and an email) and the full-text of this differing license.

However you can do this in different ways, all that's necessary is to clearly mark that the code you've added is under
a different license, the way to do so is more or less just a convention (although some licenses to have specific
requirements on where they need to be mentioned, be careful with those). Another pretty common way to do it is to add a
comment at the start or end of the source code file containing the fulltext of the license, or a reference to the
license.

There's a lot of reasons why you may want to contribute to a project under a different license, for example it might be
that the code you're contributing isn't yours, but is instead from another project, with a license that requires you to
do something specific. However it could also just be personal preference, maybe you like another license, and you're
only willing to give out your code under that license, not under the one the project uses everywhere else.

## Available licenses

There are countless amount of licenses, each with different set of conditions and different rights they give out. As an
author of your project, it is up to you to pick a license which best suits your needs, or if you can't find a license
you like, perhaps even write your own.

But know that picking some random license, which could've just been written by some individual without any legal
knowledge may be dangerous, because of the potential for some legal loop-holes which it may contain. For that reason,
if you're making your own license, or picking one which isn't commonly used, you should always consult a lawyer.
Usually, you will likely just want to stick to an already well-established license, verified by thousands, if not
millions of users.

### Open-Source software licenses

I've mentioned before that the distinction between "source-available" and "open-sourced" code was having a license that
allows the user to do some additional things (like modifying the code and using it in different projects). However it's
not just as simple as having any license that does this. It's technically up to anyone to make their own mind about
what they'd consider open-sourced, but it's probably fair to say that if your license is discriminating against some
group of people, most probably wouldn't consider it as open-source license.

To address this, an organization called the "Open Source Initiative" (OSI) came up with their list of approved
licenses, which were fact-checked by their lawyers and are commonly used by tons of people already. You can find this
curated list of OSI-Approved licenses [here](https://opensource.org/licenses). All of these are generally considered to
be open-sourced by almost everyone.

### Free software licenses

> “Free software” means software that respects users' freedom and community. Roughly, it means that **the users have
> the freedom to run, copy, distribute, study, change and improve the software**. Thus, “free software” is a matter of
> liberty, not price. To understand the concept, you should think of “free” as in “free speech,” not as in “free beer.”
> We sometimes call it “libre software,” borrowing the French or Spanish word for “free” as in freedom, to show we do
> not mean the software is gratis.
>
> -- [Explanation of "free software" by the Free Software Foundation](https://www.gnu.org/philosophy/free-sw.html)

As seen in the quote above, free software is essentially about software that has a license which guarantees you certain
freedoms. Unlike the simple "open-source" software, which is merely about a project having a license which allows
others to fearlessly contribute to it, "free" software extends that and also guarantees contributors the freedoms
mentioned above.

Really, all you need in an open-sourced license is the ability for the contributor to change the code and pull-request
it back. The rights to distribute the software on their own, use this code in a different project, or do a bunch of
other things aren't all that necessary for pure open-source projects. So, to signify that these freedoms are being
respected, we often call such projects "free and open-sourced", instead of just "open-sourced".

To easily recognize which licenses do follow this ideology, the Free Software Foundation (FSF) also has [their own list
of licenses](https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses) that they confirm do meets these
guarantees.

## License types

Because there are thousands of very different open source licenses, we split them into several categories, which
describe the main goal of the license. While the individual licenses in the same category can still be quite different,
these differences are mostly minor details.

This categorization allows us to only remember what category a license is, and already know with fairly good confidence
what the general guidelines of that license will be. Knowing what license category you prefer can save you a lot of
time in finding a license you like, since you'll just need to look for licenses your preferred category.

### Copy-Left licenses

The main point of copy-left licenses is to ensure that the code licensed under them will never go closed-sourced, and
will always remain free and accessible to anyone.

To achieve this, copy-left licenses require everyone who would want to use the code licensed under them to publish
their code under the same (or a compatible) license. This basically means that if some other project would like to use
a part of copy-left licensed code, that other project would need to itself become entirely copy-left. We often call
this "propagating the copy-left".

Usually, if your project is compilable into a single executable file (or multiple executables) copy-left licenses will
also require shipping the license and the entire source-code that was used to compile it (or at least a link to a
website where this source-code and license's fulltext is accessible, which is often done because the source code might
be pretty big). This ensures that anyone wanting to use this binary will always have access to the source code it was
made from, and are free to change this code and to then use their own modified versions if they want to (this is often
called creating "derivatives"). For example they might make a version without any intrusive telemetry.

There can be many little caveats to these licenses and you should always make sure you understand what that license is
allowing/denying before you decide to use them.

The most popular copy-left license is the GNU General Public License version 3 (GPL v3), but version 2 is also still
quite popular.

### Permissive licenses

Similarly to copy-left licenses, this type of license allows usage of the original code in almost any way (derivatives,
using small chunks, using code as library, ...), however unlike with copy-left, permissive licenses will allow other
projects using the code under them to be relicensed under a completely different license, we call this allowing
"sublicensing".

However even though these licenses are generally very "weak", in that they allow the code to be used very easily and
without many restrictions, it doesn't mean there can't be any extra conditions to gain these rights. One example of a
very common requirement in permissive licenses is to mention the original copyright holder(s), or a requirement that
prevents making software patents, requires listing all changes made to the original code, or various other things.

This means that permissive licenses give others a lot more freedom because they allow anyone to use your code under any
license they like, usually even a proprietary one. This could then mean that someone might simply take your entire
project, and make it close-sourced. Perhaps with some added features, this version can then be sold for profit.

However the proponents of this license like this fact because even though it may mean their software will be used in
closed-sourced repositories, it at least means that there is a big chunk of open code in these projects, promoting the
open-source idea, rather than having the companies write their own internal tooling resulting in existence of even more
proprietary code. A big advantage here is also that companies using this code often end up contributing to these open
repositories, hence helping them to grow.

The most commonly used permissive licenses are the MIT License and the Apache 2.0 License. Another really popular
set of licenses are the BSD licenses, most notably the BSD 2-Clause license.

### Public domain licenses

There are also the so called "public domain licenses", which are actually a subcategory of permissive licenses, however
when we talk about permissive licenses, we generally don't mean the public domain ones, even though they do technically
meet the definition of a permissive license. This is why I separated this category as it's really quite different from
what people would expect from usual permissive licenses.

Public domain licenses essentially strip the copyright away completely. They don't impose any extra restrictions (such
as requirement to mention the author) at all. This means giving everyone the right to do absolutely anything with that
code, and anyone using them can essentially consider themselves as the owners of that works.

Depending on the country you're in, these licenses may act a bit differently as not all countries allow "removing" the
copyright from your work, instead you can "assign" the copyright to the public domain, or give all rights to everyone
without imposing any restrictions.

The most notable public domain licenses are: "Unlicense" license, Creative Commons CC0 1.0 Universal, and WTFPL.

### Strong and weak copy-left

Coming back to copy-left licenses, they're actually split into 2 sub-categories, which further define how strict they
are. The main problem with copy-left is that people who like permissive licenses will often simply refuse to use
copy-left projects, because they don't want to be forced to also license all of the code in their project under a
copy-left license. For that reason, copy-left licenses needed a bit of a change, adding another category.

This new weaker form of copy-left is essentially the same as normal copy-left, but with some exceptions that allow
using the code as if it was permissively licensed. The most common case for this is an exception for using the
copy-left licensed software as a library. This means that code licensed like this can be used in any other projects
under a weaker set of rules (essentially under permissive rules), when the project is used as a library dependency.
This would then even allow use in closed-sourced projects. However this weaker ruleset only applies if the project is
being used as a library. If you wanted to make an actual fork of the project, or use some part of the source-code
directly in your code-base, this exception doesn't apply and the copy-left still needs to be propagated. The more
exceptions to this there are, the "weaker" that copy-left license is considered.

With this change, to distinguish between these licenses, original copy-left was classified as "strong copy-left", and
this new weaker form of copy-left licenses was called "weak copy-left".

{{< notice warning >}}
Weak copy-left licenses could end up causing some legal "gray zones" when that copy-left license isn't clear about when
the copy-left should propagate, and when it can be permissive, and it is important to say that these **weak copy-left
licenses weren't yet tested in court**.

Nevertheless, many people and companies do use them and they're generally trusted to be quite safe (that is, if you
pick one that has been checked by a lawyer and is used commonly, ideally one of those listed in the OSI or FSF's
approved list of licenses).
{{< /notice >}}

#### Most commonly used strong copyleft licenses

- **General Public license (GPL):** The license that defined copy-left.
- **Affero General Public License (AGPL):** Extension of the GPL (an even stronger copy-left) that enforces source
  code publishing even for a "service" use case (I won't get into details about that here, look it up if you're
  interested).
- **Sybase Open Watcom Public License:** One of the strongest copy-left licenses which prevents the "private usage"
  loophole of the GPL (which allows source-code modification when you "deploy" the software for private use only,
  even for testing while developing a project covered by this license) and requires source code publishing in any
  use-case. However this can be way too limiting and basically makes it really hard to even develop the software
  covered by it because each time an executable is built, the srouce-code has to be made available, which lead to
  FSF not accepting this license as "free software license".
- **Design Science License:** The interesting thing about this license is that it can apply to any work, not just
  software/documentation, but also literature, artworks, music, ..., however it became irrelevant after the
  creation of "creative commons" licenses.

#### Most commonly used weak copyleft licenses

- **Lesser General Public License (LGPL):** Libraries are treated permissively, major derivatives and direct source
  usage forces inheriting copy-left.
- **Adaptive Public License (APL):** An incredibly detailed license which provides a template for users to slightly
  modify it to their exact needs.
- **Mozilla Public License (MPL):** Uses files as the boundaries between MPL-licensed, and proprietary/otherwise
  licensed parts. If a file contains MPL code, copy-left is propagated to that file only.
- **Eclipse Public License (EPL):** This license is made to be very similar to GPL, but with the intention of being
  more business-friendly, by allowing to link code under under it to proprietary applications, and licensing binaries
  under a proprietary license, as long as the source code is available under EPL.

## Picking your license

Whenever you make a new project, you should also figure out how will you want to license it category-wise. Should it be
permissive? Should it be copy-left? Is it a library? If so, should it be weak copyleft? So on and so forth. After you
know that, you should start considering the possible licenses in the category of your choosing, so for example if you
ended up on strong copy-left, should it be GPL-3, GPL-2, AGPL, or maybe something else entirely.

{{< notice tip >}}
If you need some help on picking the license, check out some of these pages, which are made to simplify this process a
bit:

- [The healthermeeker's license picker](https://heathermeeker.com/open-source-license-picker/) gives you a bunch of
  questions about your project, and shows you the license you'll want based on your answers
- [TLDRLegal](https://tldrlegal.com) allows you to quickly see some key points about a given license, without the need
  to read the entire license's full-text.
- [Choosealicense](https://choosealicense.com/licenses/) is a webpage made by GitHub, which can show you points about
  some of the most commonly used licenses helping you pick the right one.
  {{< /notice >}}

{{< notice warning >}}
If you want to add a license to an existing project, which didn't have any license before, or if you want to change the
license, depending on many factors, you may face some difficulties. To understand how to go about this, check out [my
other post]({{< ref "posts/changing-license" >}}) that talks specifically about changing licenses, or adding licenses
to previously unlicensed code.
{{< /notice >}}

## Limitations

Before picking your license, you should be aware of the limitations it may create for your project. While you can
obviously pick any license for your projects whatsoever (including no license at all), if you pick a permissive
license, you immediately loose the right to use any copy-left licensed code _(unless it's a weak copy-left and you're
in the exception, or unless you [relicense]({{< ref "posts/changing-license" >}}))_. It is therefore very important to
know the licenses of your dependencies and of the code you're going to be using in the codebase directly.

In vast majority of cases, if you're using a packaging system (such as pip for python, npm for node, cargo for rust,
...) these will create dependency listings, which will often fulfill the license's mention requirement since it's
source url will be mentioned by the package manager, and the original source is often included somewhere along with the
license, fulfilling the include license requirement.

In many cases, it is therefore enough to just add these libraries via the package manager without any worries.
Especially since most utility libraries are generally going to be licensed under weak copy-left allowing library usage
or permissive licenses. However it may not always be the case, and when that happens, you may need to do something
extra to comply with that license (like making sure you're not using any software patents, not using the project's
trademark, etc. For that reason, you should ALWAYS make sure that you are in fact following the licenses of your
dependencies.

## My personal preference

In most cases, I prefer strong copy-left, specifically I usually stick to the simple GPL v3 license, as it meets all of
the things I'd want from a license, however when I'm making libraries which I know many people may end up using, I
don't want to discourage that usage by forcing them to propagate my license as many people simply don't like licensing
their code under a copy-left license, so weak copy-left works better for me there, specifically I choose LGPL v3 for
cases like that.

Although to truly support open-source, it can sometimes make sense to use strong copy-left even on libraries, as it
forces everyone using it to also keep their project open, and therefore this could really significantly help grow the
open-source community, by forcing even companies to make their code open, because otherwise they just won't be able to
use your library. Depending on how complex this library is, they might end up reimplementing it themselves, bypassing
you entirely though, but if doing that is not so easy, it might simply not be worth it, and the company will instead
decide to just go open-source, following your license.

Another benefit with using full GPL on libraries is that you get to utilize code from other GPLed code-bases, while
with LGPL, this actually isn't possible, because GPL isn't compatible with it (you can't relicense GPL code into LGPL).

I'm generally against fully permissive licenses, as in my opinion, they simply give out too many permissions, and while
in the ideal world, this would be fine, that's just not the world we're in. I get the people who license their code
under these licenses, since they at least mean that the bigger companies will have a lot of open code in their
code-bases, but I'm just fundamentally against my code being used in a proprietary project, at least without being
compensated appropriately for it.

When I publish my code, I do it so that everyone can use it freely, to support the open-source community. I don't do it
to support big companies, only to use have my code used in their closed-sourced projects, or even worse, to have my
entire project copied and relicensed, with a bunch of added telemetry and other user-intrusive features, to the point
where it's basically spyware, with them then happily releasing it under their banner, selling and advertising it to
everyone, without having any say in it, since my license allowed it.

Instead, I just use a license which allows anyone to use my code, as long as they give out the same guarantees as I
did with my project, allowing anyone to modify it, etc. And if some company would want to use my code in a different
way, they can always contact me and we could discuss me giving them a different license over it (see [post about
multi-licensing]({{< ref "posts/multi-licensing" >}})), for some compensation. I don't want to write code for companies
which I'm not gonna be payed for. But I'm absolutely for writing code for people like me, who just want to use it in
their own open-sourced projects, and for giving back to the community as a whole.

{{< notice tip >}}
Another great license to consider is the [**Mozilla Public License**](https://www.mozilla.org/en-US/MPL/2.0/) which
uses a very interesting **file-based weak copy-left** propagation and therefore enforces all of your code to always
stay open, even if it lives in an otherwise proprietary codebase, by requiring the file with MPLed code be MPLed in
it's entirety, but the rest of the files, even if they then use the code (via imports/linking) won't be affected.

I still personally prefer strong copy-left, because it has this "give-back" property, but for people who just want their
code to stay open, without caring as much about it being in a project that abuses it, this may be an amazing choice
instead of going full permissive.
{{< /notice >}}

Then again, this is purely my stance and you should make up your own mind and decide what works best for you, I'm not
here to force my opinion on anyone, it's your code and I firmly believe that you should be able to do anything you want
with it, but I did want to express why I feel this way about permissive licenses and what I like using, in hopes that
someone will perhaps not have considered these arguments against permissive licenses. But again, I wouldn't want to
force that on anyone, it's your work and you can license it in any way you want.
