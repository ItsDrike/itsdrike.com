---
title: Changing a software license
date: 2023-10-12
tags: [programming, licensing]
changelog:
  2023-12-10:
    - "Publishing this post (was written earlier, but it was waiting for other posts that it refers to)"
---

Figuring out how to properly and legally change the software license of your project can be a difficult task, and yet
it's incredibly important that you do this right, as you might run into some legal issues otherwise, which I'm sure
you'd like to avoid. For that reason, I wanted to write something explaining this process in detail, and demystify it a
bit.

{{< notice  note >}}
This article assumes that you already know the basics of how software licensing works, and that you're familiar with
the different types of licenses (permissive, (weak and strong) copy-left, public domain). If you aren't sure you're
familiar enough with these topics, I'd strongly advice you to learn read about these before going through this article,
as you will likely not end up understanding a lot of what I'm talking about here.

But don't worry, I actually have an article explaining these basics right here, [check it out!]({{< ref
"posts/software-licenses" >}}).
{{< /notice >}}

{{< notice warning >}}
Even though I did a lot of research into software licenses, it is important to mention that I'm not a licensed lawyer,
and this is not legal advice. Ideally, you should consult a lawyer if you need to get the licensing right. This article
is here purely to give you a general understanding of how the relicensing process works in various cases.
{{< /notice >}}

## Licenses stick around

So you've decided that you want to relicense some of your projects (or add a license to previously unlicensed
projects), good! There is however an important consideration that you should be aware of when doing this.

In most cases, if your code already had some kind of license, it is very likely that that license will remain in effect
even after the relicense. This is because most open-source licenses will give out "perpetual" and "irrevocable" rights
to the code licensed under them.

By relicensing your code, all you're doing is adding yet another license in combination with that original one to all
of your existing code. This will then mean that the code you had will now be available under either the terms of the
original license, or the terms of the new one, and anyone who'd like to use your code will be able to pick whichever of
those 2 licenses that they prefer.

So, while you can remove the first license from the repository, the code that was originally licensed under it will
remain available under those terms. That said, any new code you write after the removal of the first license will then
only be available under the new license.

This is why it's very important to really think about which license you want to use before publishing your code under
it, as otherwise, you risk making your code available to anyone under very permissive terms, which you may end up
regretting in the future.

## Relicensing public domain code

This is certainly the easiest of the cases. If you want to add a license to any code attributed to the public domain,
you can do so without any worries about legal issues, as this code's license doesn't impose requirements on you, and
simply gives anyone rights to do essentially anything with that code.

## Relicensing permissive code

Using permissively licensed code under a different license is still pretty easy, as that is their intention. That said,
this time there will be at least some requirements for you to meet.

Generally these will just be simple things such as having to mention the original source, state changes, a clause
preventing you from making software patents of this code, etc. These requirements will differ from license to license
so you should understand them first before trying to use such code, however the relicensing process here will generally
still pretty straightforward.

## Relicensing copy-left code

This case however won't be as easy. The whole point of copy-left licenses is to ensure that the code will stay open,
and to guarantee this, they're designed to prevent most sublicensing. That said, they don't necessarily prevent all
sublicensing, as you'll see in the following section:

### Compatible licenses

All copyleft licenses will by design have to prevent you from removing (freeing up) restrictions in the license, at
least to some extent, otherwise they wouldn't be copy-left (they'd be permissive). Copy-left licenses then also prevent
imposing further restrictions on the freedoms these licenses do give out, because without that, one could for example
relicense the project under a technically copy-left license, but one that only allows a single person/entity to use
this code, essentially making it proprietary. Once again, there may be some leeway here, and perhaps some additional
restrictions can be imposed, but it's generally not going to be much, and in most cases, this leeway is essentially
non-existent.

This means that even though in some (rare) cases, you might actually be able to find a compatible license that you
could relicense to without any issues, this license will then likely be almost the same, often making this transition
pretty much useless.

That said, a copy-left license can contain a list of some specific licenses, to which relicensing is explicitly
allowed, even though they otherwise wouldn't be compatible. This is mostly done just to allow updating this license,
such as for going from GPL version 2 to GPL version 3.

In many cases, these licenses provide a version without this clause, for people who consider it potentially dangerous
though (for example with GPL v2, these versions are often called `GPL-2.0-or-later` vs `GPL-2.0`). It's very rare for
this clause to allow completely different licenses though, and generally it will really only be for this "upgrade" use
(downgrading usually isn't possible either, so once you update, you can't go back).

### Incompatible licenses with full code ownership

As you see, it's very unlikely that if you'd want to relicense, you'll be able to do so simply, by just moving to a
compatible license. This therefore brings us to moving to incompatible licenses, and doing this can be incredibly hard.

However there is a simple case here, for when you own all of the code in the project yourself. In this case, as a
copyright holder, it doesn't really matter what the license says, you own the full rights to your code. The license is
just a way to give out some of those rights to others. You, as the owner, don't need to follow it though, and that
means it's literally as simple as deleting the old license, and putting in a new one.

### Incompatible licenses without code ownership

The real issue only arises when you're trying to relicense a project that actually has some contributions from others,
and you don't have the rights to relicense their code. This is because when they made their contribution, they
submitted it to your project only under that original copy-left license.

At that point, you don't really have that many options. The simplest one is to just rewrite the code that you don't
own, so that you will then have the copyright over all of the code. Once 100% of the codebase is owned by you, you can
relicense, as we're essentially just back to the first case. Obviously though, this might be a huge task for bigger
projects, and it might simply be infeasible to rewrite that much.

The other option is to get permission from the original contributors, allowing you to relicense their code. This works
because you don't actually need to follow the original license, if you have some other agreement with the contributor,
that allows you to use the code in a less restricted way. (This is pretty much also why the first case, where you own
100% of the code is so easy.)

The issue with this one is also pretty obvious though, as not only do you need to find a way to contact the
contributors, you also need them to actually agree to this license change. Contacting contributors alone can be a very
difficult, and perhaps even impossible. Many contributors use no-reply emails from GitHub/GitLab in their commits, and
their accounts don't list any way to get in touch with them. Even if you can find the email, they might not be using it
anymore, or simply choose to not reply. But it gets even worse! It's possible that the contributor has died, in which
case their copyright got transferred to their relatives, or to the state, and you'd need to obtain permission from
them instead.

Let's say you were able to contact the contributor though, now you'll need them to agree to give you the rights that
allow you to use their code in a different way, than that which they originally agreed to. This is no easy task,
especially when the contributor wants their code to stay open, and they just aren't comfortable with the change you're
trying to make. In many cases, when companies attempt this, they end up convincing people by offering to pay for these
rights.

But even with contributors that wouldn't mind giving you those rights, you will still need them to sign a document
(usually this will be a [CLA]({{< ref "posts/licensing-documents" >}})) confirming that they're granting you these
rights, and generally, people just don't like signing things like that, even if the wording isn't that difficult to
understand. In some cases, it is even possible that the code in your project was written by someone that is too young
to be able to legally sign such a document, in which case, you would need to get their parents/guardians to do so
(you'd be surprised just how many open-source developers are minors).

## Relicensing proprietary/unlicensed code

Projects without any sort of license are automatically considered proprietary, as the original owner(s) automatically
get the copyright to what they wrote and they didn't give out the rights to use this code to anyone via a license.

### Intentionally proprietary

If you're dealing with a source-available code-base without a license, and you'd like to use some of it's code in your
own project, or to fork it and license under some open-source license, the only choice you have is to contact the
author, and get their permission to do so (often by paying the author to get it).

This is a pretty common thing for companies, who write code for clients, who only have usage rights, but not
modification rights. So when the client wants to migrate to another company, they'd need to start over, or purchase the
rights to modification.

### Unintentionally proprietary

In a lot of cases, the lack of license actually wasn't intentionally, and the author actually intended for their code
to be open-sourced, but they just weren't aware that to do so, they need to add a license.

What's even worse is when someone actually makes a contribution to this kind of project, and the author accepts it. The
thing is, that contributor was never authorized to even make a contribution, as it's a modification of the code-base,
which the copyright prohibits by default. But the contributor didn't realize that, and neither did the author, so now,
that code-base contains proprietary code hunks, some owned by the original author, and some by the contributor.

This is incredibly problematic, as it means even the original author now doesn't have the rights to edit the code
written by that contributor, in their own project. They pretty much just legally locked themselves out of access to
their own project.

The simplest thing the author could do now is to just revert this change, add a license, and ask the contributor to
make another PR, offering the code under that new license. (You could also get the contributor to sign a CLA, which
will give you rights to their code that they've already submitted, but this leads to the same issues as in the
copy-left relicensing case, and getting people to sign something is much harder than to have them just redo the PR).

That said, this process gets exponentially more difficult with the number of contributors, as the amount of reverts to
be done might get really high, to the point where you can't reasonably do it without going back to a really old
version entirely, when all of the code was written only by you.

In that case, you should do your best to contact the contributors and get the appropriate permissions, but if you can't
do so, either revert and rewrite any code that isn't yours, or if that's not viable, just delete the project entirely
to avoid getting into legal trouble.
