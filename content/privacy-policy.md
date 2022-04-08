---
title: Privacy Policy
hidden_from_navbar: true
---

As most services nowadays, it's hard to keep something running without **any** data collection at all, however I do
take privacy very seriously and I'm doing my best to minimize the amount of collected data, or even the data that's
available to me if I can and I try to only keep what's absolutely necessary, for as little time as necessary, while
still allowing me to properly maintain the service long-term, and catch any malicious activity.

## How I collect data

I'm completely against having any 3rd party service having access to any info about the users which visit my webpage
and you won't find any such data-collection platforms attached to my websites (things like google analytics). The data
which I do collect is purely 1st party data, there's no middle man peeking at the requests.

I should however point out that I do use Cloudflare, mainly because of the incredibly quick DNS that they provide for
free, and for their DDoS protections which I simply couldn't handle on my own with my small servers. I do however use
TLS/SSL on every publicly exposed service that I host, and the traffic from the website is end-to-end encrypted between
you, and my servers. This means that all Cloudflare would be able to see is the raw HTTP request data.

As for the data I do collect on my own servers from the reverse proxy, all of it is being collected by an open-source
tool called [Prometheus](https://github.com/prometheus/prometheus), which is living on an isolated network not
connected to the internet and only having access to the services it monitors (most notably the reverse proxy) since
even though I do trust that this service isn't sending any of my data anywhere, even if it did try, this setup ensures
that completely and gives me some more peace of mind.

## Don't actually trust me on any of this

As with any privacy policy, I can say whatever I want in here, even if it's a complete lie and sadly providing some
proof that what I say isn't a lie is incredibly hard, and often just impossible. The simple fact is that no matter how
much I may be claiming that I don't collect more than I say and that I don't keep logs for longer than I claim to,
that's all it is, my claim, and it's up to you whether you will trust me with it, or not. (Hint: I wouldn't)

I will try and mention some things which are provable and I'll of course show you a way to prove these claims, but know
that even with all of those taken into consideration, there is still a lot of data I could be collecting and it's
basically impossible to prove that I'm not.

### Third party tracking platforms

One of these provable things is that there's no direct connection being made from your browser to any 3rd party data
collection platforms. You can (and always should) verify this claim, and you can do so from pretty much any modern
browser. With Firefox, this can be done by opening the developer tools (Ctrl+Shift+I), going to the Network tab and
checking all of the requests being made. From there, you should inspect all of the 3rd party URLs you see there and
make sure that none of these URLs are pointing to platforms for such data collection. This process can be pretty
tedious though, and I'd recommend using tools such as uBlock Origin's plugin in advanced mode, which can show you
each domain, and even give you an easy way to block requests being made to that domain.

However direct 3rd party data collection, while being the most common way website owners track their users, certainly
isn't the only way to do that. In fact, all of what a 3rd party website can track can also be done directly as a 1st
party, and even worse, some 3rd party services provide tools to do this collection and send the data back as a first
party, only for that 1st party server to then send it over to the data collection website without the user ever even
having a way to find out.

### First party JavaScript tracking

Luckily though, it is in fact possible to prove, that the 1st party tracking is at least not using any intrusive
JavaScript, that would be collecting information that the browser's JavaScript engine makes available, which is
a lot. To demonstrate just how much a data can be collected purely with JavaScript, you can check the 
[Creep.js](https://github.com/abrahamjuliot/creepjs/) project, made to demonstrate this.

Proving that there's no such JavaScript code is technically very easy, all you need to do is go through every linked
JavaScript and every `<code>` tag on the webpage and check what is it doing. In practice though, this is actually very
hard, because websites often obfuscate their JavaScript code to hide what's it actually doing and turn it into
gibberish which the JavaScript interpreter can understand, but it's very hard to read and understand it by just reading
it. 

For my case though, I'm only including jquery and bootstrap (for now) which provide functionalities for things like
the navigation bar, and you can check that the included files do match the released jquery and bootstrap JS scripts and
there's nothing more hiding in those. There may also be some more javascript on page-to-page basis to handle some
special functionalities, but for the most part, I tried to make as little use of JavaScript as I could, and this also
means that if you really want to be safe from me having any chance to collect such data, it should be mostly fine to
just turn javascript off completely and the website will be almost completely the same without too many lost
functionalities. That said though, I can't promise on every little thing actually working if you go this route, and
it's likely that you will loose some functionalities, but I will do my best to at least keep the site properly
formatted and avoid having it completely break (which is the case with many other websites if you don't allow JS).

### Tracking from raw HTTP Requests

After all that, there is still some information that I can be collecting directly from the HTTP requests you're making.
These requests often contain the so called "User-Agent" header, which is a string containing things like what browser
you use along with it's version, the version of the Operating System used, etc. Additionally, you're of course going to
be making those requests from a certain IP address. There are several more data-points in these requests, and you
should check what those are for yourself. You can check the 
[Mozilla's docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Messages) for more info about all of the things
contained in an HTTP request and most browsers do allow you to inspect the requests you're making and see the sent data
along with all of the headers and other data within each request.

You should assume that I collect all of this data, because this time, there's indeed no way to verify that I'm not, and
you can be certain that I'm getting those data, because it's simply how HTTP communication over the internet works. To
easily demonstrate all of the data that a request like this holds, along with all additional data (mostly forward
headers) included by my reverse proxy and Cloudflare, you can visit <https://whoami.itsdrike.com>, which houses a
[Traefik's whoami service](https://github.com/traefik/whoami). This service is an easy way to print back all of the
captured information it got from the HTTP request that was made when connecting to the page. But of course, this is
purely for demonstration and you shouldn't trust me that I haven't edited this service to show less info than what I'm
actually getting, but again, you can see exactly what you're sending yourself by inspecting the requests in your
browser.

## What I collect

Specifically, these are the all of the data I'm storing, along with explanation why, exact info on what is stored and
for how long it's stored.

### The raw amount of HTTP requests and their response codes

I'm logging the each HTTP request along with a timestamp at which it occurred. This information is necessary to know
how much traffic is going through my server so that I can know about higher demand and easily handle it before it gets
out of bounds. I'm also collecting the [HTTP response codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)
which I'm using to ensure there aren't too many of 4XX errors, most notably things like 404s likely pointing to having
invalid links on my webpage which should be fixed.

This request information will be stored on my server for about 1 month. Specifically, this information will only
include the timestamp, HTTP response code, and a category (that this is an HTTP request). There are no other captured
information, such as an IP address, User-Agent or anything else that's stored along with this specific category.

### The connecting IP addresses

I'm also logging the IP addresses belonging to each request along with what internal service at what URL was accessed
over them. I'm doing this to immediately detect brute-force attacks and prevent people from attempting to crack
passwords on some of my other self-hosted services. If I do detect such activity, I proceed to ban all requests from
that IP for a certain amount of time (this time depends on many factors, and can vary from service to service). This
means that if you've made more than the maximum amount of requests over certain time, your IP will be stored for at
least the time it will be blocked for, but more likely for much longer, due to security concerns, so I can monitor if
something like that happens again, and perhaps issue a permanent ban on that IP.

If you haven't gone over these limits though, all logs containing IPs are being consistently rotated and should be gone
in at most a week, but likely much sooner as I have no intention of storing IP addresses for any longer than I need to.

### Cloudflare data

Along with data collected and stored on my servers directly, I should also point out that cloudflare is, by design,
also storing some user data from the requests going through it. I can't speak for how much data cloudflare is
collecting and keeping on their servers for them, however you can check their 
[privacy policy](https://www.cloudflare.com/privacypolicy/).

What I can comment on however is that data that's made available to me on the dashboard, and this includes:
- Number of unique visitiors over last 30 days
- Number of total requests over last 30 days
- Traffic by country/region over last 30 days
- DNS Queries by respones code over last 30 days

There is some more data that I can access, however that isn't connected with the user data so I didn't mention that
(things like how much data came from cloudflare cache and how much came from my server, etc.)

### That's it!

As I said, I take privacy very seriously, and I'm trying to do my best in protecting the privacy of others, if I can,
so while I can't afford to just stop collecting everything for the sake of security of my services, I refuse to collect
anything more.
