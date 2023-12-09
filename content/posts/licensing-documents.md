---
title: Software licensing documents (CLA and DCO)
date: 2023-04-03
tags: [programming, licensing]
changelog:
  2023-12-10:
    - "Publishing this post (was written earlier, but it was waiting for other posts that it refers to)"
---

In many projects you'll find out that before you're allowed to contribute something to an open-sourced, you'll be
required to sign a document requiring certain things. This is mostly the case of contributing to projects maintained by
big companies, but it can be seen in smaller projects too sometimes. But what is the purpose of these documents, and
should you be willingly signing them?

In most cases, you'll see one of the below two categories of documents, each doing very different things:

## Contributor's license agreement

Following the [relicensing post]({{< ref "posts/changing-license" >}}), it should be clear that any copy-left licensed
project wishing to relicense won't have it easy and it may take years to gather the consents of all of the contributors
to actually achieve that relicensing. Because of this, many companies choose to instead simply get this consent
beforehand, with what's called a "CLA", (short for "Contributor's License Agreement").

CLA is a legal document that each contributor is often required to sign before the company will allow any code from
said contributor to make it into their (usually copy-left licensed) codebase. This agreement states that all code
contributed by this person will have it's copyright transferred over to that company. Making this company the single
copyright holder and therefore making it really easy for them to change the project's license if the current license
becomes inadequate. (If you're unsure how that works, check out the above linked relicensing post.)

This is often used to allow for updating the license to a newer version when it comes out (though you could just as
well include a sort of update clause into the license itself, which for example the GPL license does allow). Another
common use-case for this is to allow the company to dual-license a project, having the original copy-left license there
for general public use, while also providing a permissively licensed version which can be purchased by companies for
usage in their own closed-source code bases, which makes them profit from the project.

{{< notice tip >}}
If you want to see how a full text CLA might look like, consider checking out
[contributoragreements.org](https://contributoragreements.org/ca-cla-chooser/), where you can generate a template CLA
based on some preferences which you can choose.
{{< /notice >}}

### Dangers of a CLA

The biggest issue with a CLA is the fact that it often transfers your copyright away, rather than gives right to using
your code. This means that you actually lose the ownership over that code, and if you were to use it elsewhere (like in
your own personal projects), you could end up actually having to treat it as someone else's code, and adhere to the
license it's released under. This might mean having to add a document where you attribute it to a different owner (such
as a company), which is pretty scary considering this was your code to start with.

Another big issue is that, usually, if you're contributing to a copy-left licensed project, you expect that code to
stay open-sourced. However with a CLA, the copyright owners could easily relicense it, and not just to some alternative
copy-left license, not necessarily even to a permissive one, instead, as the single owners of the entire project, they
could simply close-source it entirely, if they wanted to.

### Copyright back clause

While the first issue with CLAs, being you loosing your right to your own code sounds absolutely horrifying,
the agreement can include a "copyright back" clause (or a similarly named one), which contains a software license
granting you full irrevocable rights to use your code freely, without any restrictions or requirements.

The other case that's also seen quite often is one where you give the company full rights to your code, but without
any copyright transferring. This is similar to the copyright back clause that you're given, except it's now you giving
the company these unrestricted rights, including that to grant sublicenses to third parties, meaning your code could
spread anywhere, under any license, at that companies discretion.

While the 2nd option might sound a bit better, as you're technically still the copyright holder, in reality it doesn't
really matter, at all. That's because if the company has all rights to the content, it essentially makes that company
an owner of that content. They can do absolutely anything with it, and you can't revoke this right, as it was an
irrevocable grant. This is then also the case with the company giving these rights to you.

Thankfully, one of these 2 clauses is present in **almost** all CLAs, meaning you likely won't be loosing the rights to
use your own code. It is however very common for [employee CLAs](#employee-contracts) to not include these, as the
company often doesn't want you being able to share their proprietary code (though this is often also handled through an
[NDA](https://en.wikipedia.org/wiki/Non-disclosure_agreement)). So, if you're considering signing any CLAs, make sure
that one of these clauses is there, and if it's not, only sign it if you're really ready to accept the consequences of
that.

### Limiting conditions

To somewhat mitigate the dangers of signing a CLA, some of them can actually include a "transfer back/nullification"
clause, that can reassign the copyright back to you, or revoke the copyright rights you've given to the company.

This often requires you making a written letter about termination of the agreement, which you can request if the
company didn't follow one of these conditions.

A very common condition that CLAs for open-source projects include is one that prevents relicensing under any license
that wasn't FSF/OSI approved, or one that wasn't in an explicitly defined list of licenses (perhaps purely copy-left
licenses). This can therefore remove the contributors worry about the company potentially making the project, along
with your contribution closed-sourced.

So, if you don't mind signing a CLA, but you require the company to follow some conditions, you can always ask the
maintainers to offer you a version with these extra conditions. This likely won't succeed though, as even if the
company doesn't mind your conditions, it would require them to keep note that your contributions are under a different
license, and to contact their lawyer to write up a modified version of the agreement, which can be expensive.

However if your proposal is reasonable enough, and especially if you get more people to ask for these additional
conditions, you just might be able to convince them to change the main version of their CLA to include these by
default, protecting every new contributor with them.

### Employee contracts

A very commonly sen use of CLAs is in employee contracts, so that the company you're working for will be the one
holding the copyright over the code you write there. These CLAs are almost always incredibly invasive, and you likely
won't find any nullification clauses, and **not even copyright back clauses** in there at all. However that is somewhat
understandable as the company will probably want to be using that code in close-sourced projects with various licenses
and perhaps also even sell it under different licenses.

That said, it is incredibly important that you go through the CLA in your employee contact and understand when does
this copyright transfer occurs. Many companies go pretty far by simply having it apply to all projects that you work on
from a company machine (even a borrowed one that you work on from home), so even if it's not a project you've been
assigned to work on by that company, and you simply just opened up some personal project on a company owned machine,
that might've been enough to transfer the copyright for your project to the company.

Of course, you could fight this in court, but if the company would have any evidence that you did indeed open your
project on their machines, and their CLA stated that doing so means immediate copyright transfer, you're simply out of
luck, and you just lost the rights to the code of your own project.

Another common rule for when CLA applies is any time during the checked in working hours, or whenever you're in the
company building, etc. This is why you absolutely have to know under what conditions you're working, otherwise you're
risking the company going against you and taking over one or more of your projects.

## Developer Certificate of Origin

A "DCO", sort for Developer Certificate of Origin is a legal document that deals with ensuring that all of the code you
submit to some codebase is indeed owned by you, or you have a legal right to use it and contribute it to that codebase
(meaning you also need to have the right to use submit this code under the project's license).

This kind of document is pretty important because it gives the maintainers a signed document, showing that you've
agreed to always fact-check that your contributors are in fact license compatible and that you've met all of the
conditions to actually use it. Or that the code you're contributing is yours, or that you simply have a right to use it
and to add it to this project.

The reason maintainers often make it required for contributors to sign this document is because it gives them something
to hold over the contributors if it turns up that someone actually contributed code they didn't have rights to.

This solution isn't full-proof and the project maintainers may still be the ones held liable even though a DCO was in
place. However it will at least mean that the maintainers themselves can then hold the contributor liable which usually
does a good enough job of discouraging anyone who'd want to add a code they don't have the rights to into a codebase as
they'll now know that they could be facing lawsuits after doing so.

I think it makes sense for projects to include this document and you generally shouldn't be afraid to sign it (so long
as you're not submitting any stolen code, which you really shouldn't be doing even if there isn't a DCO in place). It
gives the maintainers at least some level of certainty that the submitted code isn't stolen and unlike a CLA, it
doesn't really do anything with your copyright to that project, it just confirms that you do in fact have the rights to
that code, and you're authorize to permanently add it to this project's code-base.

{{< notice warning >}}
While signing a DCO is generally quite safe, you're still legally signing a document, and as with any such document you
NEED to make sure that you've thoroughly read through it. It's entirely possible that a repository claims to have a DCO
document that you need to sign, when in fact it's also a CLA, and you might end up giving your rights away.
{{< /notice >}}

## Other issues

Perhaps the biggest issue with either a DCO or a CLA for many people, is the fact that they're legal
documents. This means a few things:

- You need to be of legal age (often 18+) to even be able to sign them.
- You need to sign them with your personal details, often requiring your address, date of birth and full name, which
  you might not be comfortable with sharing, especially if you're trying to stay anonymous on the internet / to the
  project.
- Complexity of the document: Many CLAs can span over several pages (though thankfully most are pretty short 1-2
  pages), making them hard and annoying to read, especially if they're filled with a lot of legal talk which can be
  hard to understand for non-lawyers.
