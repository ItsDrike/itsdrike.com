---
title: Escaping isolated network
date: 2021-09-15
tags: [hacking, linux]
---

Many networks nowadays are blocking certain websites, IPs or ports, that however often doesn't mean that there actually
isn't any way to access these blocked resources. Note that even though you can read about how these restrictions can be
bypassed, I was testing these commands against my own home server, and inside of my own network. Unless you have
permission from the network owner to do this, do not follow this article and take it purely as an informative resource,
and perhaps as something to think about when securing your own network.

## The reason some networks block certain webpages

You've probably encountered a public network, such as a one on a bus or on a train, from which you weren't able to
access a website such as youtube. The most likely reason for a block like this is because in a network like this, since
the bus or the train will be moving, you'll constantly be switching the access points and connecting to different
things, and with enough people connected to such network, streaming videos becomes incredibly resource heavy and the
network administrators will probably not like that. So they will set up a rule that prohibits you from accessing such
websites.

So how could we bypass such a block

## DNS Level block

A simple strategy that many network admins will use is to just block the domain name of the website you're trying to
visit on the DNS level. DNS is a short for what's called a "Domain Name System", it is a tool which resolves domain
names, such as "itsdrike.com" into IP addresses of the servers which are running them, such as "172.67.161.205".

The DNS servers your machine will use usually depend on the network you're connecting to, which means that the network
admin can easily define their own server and block off certain domains. However even though by default, your machine
will rely on the DNS servers defined by the network you're on, this is by no means actually enforced and you can easily
change your DNS servers to something else.

Personally, I'm using my own recursive DNS server with unbound which is then passed through pihole, but I only do this
because I don't like seeing ads which pihole can therefore block on the DNS level, just like the network admin would be
blocking a domain like youtube, however most people won't have their own DNS server, and so you'll want to use one of
the publically available servers, such as NextDNS (45.90.30.0), CloudFlare DNS (1.1.1.1) or Google DNS (8.8.8.8).

By switching the DNS IP address that your machine will be using, you will automatically bypass any DNS level blocks
because you're simply not accessing the DNS server that's blocking them.

## Simple proxy

Even though DNS level domain blocking isn't uncommon, in most networks, if the network admins are a bit more
experienced, it usually won't be the method they'll choose, precisely because it's very easily bypassed. Instead what's
much more common is to either block the specific IP addresses to the servers that belong to YouTube with a simple
firewall.

Rather than attempting to connect to this website directly, from our connected machine, we will use our machine to
connect to some other machine outside of the restrictive network, ideally to some home-server, but it can even be a
personal computer left at any place with SSH service running. By doing this, we're using this other server as what's
called a "proxy".

We can do this in a very simple way, just by using pure SSH. One way would be to just remote into the machine and make
the request from it, however this makes it hard to actually watch some youtube video. We could use a tool such as
youtube-dl, download the video and then stream it from our machine instead of from the blocked youtube website, or just
download the file from our server that has now downloaded this video, however that's way too crude.

There is a much nicer method that we can use, and it is still utilizing pure SSH:
```sh
ssh -f -N -D 1080 user@server
```
This command will start SSH in background (`-f`), it won't run any actual commands (`-N`) and it will be bound to the
port 1080 on our machine (`-D`). This means that we can utilize this port as a SOCK and make our server act as SOCKS5
proxy. This kind of proxy will even be supported by most web browsers, allowing you to simply specify the address
(in our case `127.0.0.1:1080`) and have all traffic go through this external server.

To test that this connection really does work, we could use the `curl` command like this:
```sh
curl --max-time 3 -x socks5h://127.0.0.1:1080 https://itsdrike.com
```
If we see the HTML code as the output, it means that we've obtained the content of the specified website through our
socks5 proxy, that we've established through simple SSH.

## Sshuttle

Even though the crude way of simply utilizing SSH to utilize our server as a proxy will work, it does have some issues.
Specifically it's the fact that SSH on it's own will be using the TCP protocol. If you want to know more about how this
protocol works, I'd suggest watching the video below:
{{<youtube 0Xfp2EXWjnY>}}

However basically, it's a protocol that ensures lossless data transmission between 2 machines. This makes sense for SSH
and it is what we want, but the issue arises once we try to send TCP traffic over already established TCP tunnel. Since
our SSH tunnel is already using TCP, it will already be ensured that it is lossless and using TCP over TCP makes no
sense in this case. Not only does it not make sense from the efficiency point of view, it is in fact damaging because
TCP relies on loss and it doesn't work well without it. This is because TCP uses loss to tell when the network is too
congested, and this is the only way for TCP to know when the network is actually congested.

To solve this problem, we can use a software called [`sshuttle`](https://github.com/sshuttle/sshuttle), which will wrap
all of the tunneling for us internally and avoids running this TCP over TCP connection. It's basically just a wrapper
around SSH and it will simply utilize SSH in the background, which is also why we don't need to do anything on the
server side for this to work properly, as long as we simply have the SSH server running, `sshuttle` will work fine.

We can use sshuttle with a command like this:
```sh
sudo sshuttle -r user@machine 172.67.161.205/24 -vv
```
Which will forward all traffic destined for the particular address block (the IP/number is called the CIDR notation, it
essentially specifies which IPs should be affected depending on the number after /, you can read more about it on
[wikipedia](https://wikiless.org/wiki/Classless_Inter-Domain_Routing?lang=en)). In this case, I've specified the IP of
the CloudFlare server that is behind my website, in your case, you'll probably want to use the IP of youtube, or even
simply something like `0.0.0.0/0` which will affect all IPs and proxy everything.

## Port 22 is blocked

In both of these examples, I've mentioned using SSH, which will be communicating with the other machine over port 22,
however this port may be blocked by the network you're on which renders all of these steps useless. To circumvent this,
you could set a different port for SSH on your server, however you will need to do that while directly on the server,
since you won't be able to establish an SSH connection and change the port, if the port for SSH would be blocked, so
you need to think about this ahead of time.

You could also simply redirect the port 22 to something else using iptables instead of having to mess with the SSH
config. You would do that with this command:
```sh
sudo iptables -t nat -I PREROUTING -p tcp --dport 1234 -j REDIRECT --to-ports 22
```

This command will make port `1234` act as the SSH port, and you could then access the server by specifying this port
instead of the default port in the ssh command:
```
ssh -f -N -D 1080 user@server -p 1234
```

## Deep packet inspection

Even though on many networks set up by amateurs, the steps above will likely be enough, if the person setting up the
network does have a bit more experience, they could be utilizing deep packet inspection and basically having their
servers look at the data your machine is sending out, and if these packets contain the reference to youtube.com, it
will get captured and it won't be forwarded to the actual youtube servers.

This can be done in various ways, and in some of those, the proxied traffic will actually still work, because the
server may only be performing this check for certain sections of the packet, and since you're not trying to directly
reach youtube, but rather you're reaching another server that's reaching youtube, it may not get captured. However with
all of these methods, the actual destination will still be included in those packets in clear text, so if the whole
packet is scanned for them, it will get discovered.

NOTE: This assumes that you're using standard SOCKS5 proxy, not the one like in our example, which, even though it was
a SOCKS5 proxy, the traffic was actually going over the SSH tunnel, which is encrypted, and so the packets would only
contain the encrypted data going towards our server, making even this method useless. But if you're using something
like netcat instead of SSH, which isn't encrypted, or the server is directly set up to be a SOCKS5 proxy, you will not
be immune to this method.

## VPNs

Preventing this is a bit harder, but it's nothing too complicated, in fact many people will already be quite familiar
with this method. It is, to simply use a VPN. Even though many people will be familiar with this, this familiarity will
often come from ads and similar things, and people don't even realize what it actually means and how VPNs work.

Basically, with a VPN, your machine is accessing some other server machine, that is making the requests on it's behalf.
This is very similar to our proxy server, however there is a major difference, which is that your machine is
communicated with the server over an encrypted tunnel. This means that all traffic going towards that VPN server will
be encrypted, and so simply searching for "youtube.com" inside of it will not achieve anything.

In my case, I do run my own VPN server with wireguard on my home server, another popular service to run is openvpn, so
if you want to host your own VPN server, I'd advice checking both of those because each do have some pros and cons, and
picking one of those. However most people will not want to self-host their VPN, and would rather pay a subscription to
a VPN provider. Mostly because these VPN providers will have many servers across multiple countries, which means you
can even access some content that is only available from a certain country, because you're technically accessing it
from that country, it is the VPN server that is forwarding the responses back to you.

## Protecting against VPNs

As a network admin, you still have some options to battle this and prevent people even from using something as powerful
as a VPN, however this ability is somewhat limited.

Basically, when someone is using a VPN, even though the internal traffic going to the VPN will be encrypted, the packet
does still need to contain the information about the protocol used, server destination and some other things. This will
depend on the VPN used, but some tools, such as openvpn (which is what most providers will be using) do provide a way
to "hide" the fact that you're utilizing a VPN and make the traffic appear as pure HTTPS traffic. This makes it really
hard to discover a use of a VPN, however many providers don't actually make this feature available, or they throw it
behind a higher subscription that many users won't have.

But even if the users would be hiding their VPN traffic, you still have a way to prevent it, however this option is
quite limited and very specific. Basically, there are usually publically available lists of IPs that belong to the
servers of popular VPN providers. This is how platforms such as Netflix prohibit the use of some VPNs, and it is also
the reason why some providers make it their marketing point that their servers weren't yet added to such a block-list
and so it is possible to access services like Netflix from them. You could therefore do something similar and simply
block all traffic going towards the IP addresses of these VPN servers.

Even though this method will work and it will prevent the usage of VPNs to some extent, this black-list will constantly
need to be updated which is very tedious, and if even a service as huge as Netflix can't completely block all VPNs,
your network likely won't be able to do so either. Not to mention the custom VPNs that will never be in any of these
public block-lists, which you basically can't prevent.

## My VPN is in a block-list

So how could you bypass a protection like this? What if the access to the IP address of your VPN is actively being
blocked by the network you're on?

Even though VPNs are pretty much the best ways to circumvent security measures that are preventing you from accessing
certain parts of the internet within some network, it is still important to know about the other ones mentioned above.
The reason for that is precisely because many network admins will only really prevent VPNs, because they're the most
common way of bypassing their network, but they won't be doing any kind of packet inspection and so even though your
VPN may not be working, you may actually be able to use the simple unencrypted proxy.

## Access White-list

If you're the network admin and you really want to make the network secure, rather than just blocking certain ports,
such as the port 22 for SSH, you'd instead block all ports and only allow certain ones. Usually, these would only be 80
and 443, because 80 is the port used for HTTP and 443 is used for HTTPS.

Even with this solution though, because of the firewall hole on port 80, we could just set our SSH to work over port 80
and still get to our server. Or if it's a VPN, we could just utilize the "hide VPN traffic" feature and mask the
traffic as HTTPS.

For this reason, some network admins will actually go as far as simply only allowing the traffic to go through their
own web proxy, which will limit our access only to some list of allowed sites.

## Bypassing a web proxy

Turns out that even with a security measure as strict as only allowing access to a certain web proxy, we could actually
somewhat make our way to our server, by essentially telling it to map all exiting traffic from port 443 to port 22.

To do this, we would use a command like this:
```sh
ssh -o "ProxyCommand nc -X connect -x proxy_server:3128 our_server_IP 443" user@our_server_IP
```
Here we're essentially sending a proxy command to the web proxy server (listening on port 3128) to through the port 443
to our_server_IP and make requests to the SSH's default port (22) on our_server_IP. Making the actual proxy server
access our server on port 22.

Of course, this would only work if the system administrator of that web proxy server didn't set up a firewall that
would prevent outcomming requests to be made from the server to other ports (such as 22).

NOTE: Even though this would technically work (unless the server has a firewall in place, blocking outgoing requests to
22), I'd never recommend actually trying something like this, because this kind of mapping can be instantly detected
and if the network admins spent that much time setting up something as secure as this, you can expect there to be a
system in place that would be checking for such mapping, and it's not particularly hard to discover, as long as it is
being looked for. So if it is being looked for, you'll basically instantly get discovered, and you wouldn't even be
able to argue your way out of it like you perhaps could with the above methods, because you can say that you always use
different DNS servers, or that you always go through a proxy or a VPN, but the only reason someone would be doing
something like this is to bypass some security measure that is in place somewhere and so arguing out of that wouldn't
really be possible.

To explain how easy it is to discover something like this, basically all that's needed is to run a single command on
that web proxy:
```sh
iptables -t nat -L
```
And look for the output policy destinations. Even though many network admins won't do this, you shouldn't ever risk
doing something silly like this, because if you will get discovered, you could get into some serious trouble
