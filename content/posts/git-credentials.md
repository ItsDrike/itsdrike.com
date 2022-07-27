---
title: Managing (multiple) git credentials
date: 2022-07-27
tags: [programming, git]
sources:
    - <https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git>
    - <https://docs.github.com/en/authentication/connecting-to-github-with-ssh>
    - <https://www.onwebsecurity.com/configuration/git-on-windows-location-of-global-configuration-file.html>
    - <https://security.stackexchange.com/questions/90077/ssh-key-ed25519-vs-rsa>
    - <https://www.shellhacks.com/git-config-username-password-store-credentials/>
    - <https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage>
    - <https://engineeringfordatascience.com/posts/how_to_manage_multiple_git_accounts_on_the_same_machine/>
    - <https://git-scm.com/docs/gitcredentials>
    - <https://www.baeldung.com/ops/git-configure-credentials>
    - <https://www.freecodecamp.org/news/manage-multiple-github-accounts-the-ssh-way-2dadc30ccaca/>
    - <https://blog.bitsrc.io/how-to-use-multiple-git-accounts-378ead121235>
    - <https://www.freecodecamp.org/news/the-ultimate-guide-to-ssh-setting-up-ssh-keys/>
    - <https://www.atlassian.com/git/tutorials/setting-up-a-repository/git-config>
---

Many people often find initially setting up their git user a bit unclear, especially when it comes to managing multiple
git users on a single machine. But even managing credentials for just a single user can be quite complicated without
looking into it a bit deeper. Git provides a lot of different options for credential storage, and picking one can be
hard without knowing the pros and cons of that option. 

Even if you already have your git set up, I'd still recommend at least looking at the possible options git has for
credential storage, find the method you're using and make sure it's actually secure enough for your purposes. But
looking over the other methods may be helpful too, as there may be a better option to what you're using which you
didn't even know about.

## Adding user into global configuration

Let's first look at the simple single local git user setup:

```bash
git config --global user.name ItsDrike
git config --global user.email itsdrike@example.com
git config --global user.signingkey B014E761034AF742  # Signing key isn't required
```

So what do these commands actually do? It's really quite simple. The git program has a single global configuration file
located in `~/.config/git/config` (or in `%APPDATA%/.gitconfig` for Windows). Once this git config command runs, it
actually just writes the settings into the config file using the TOML format:

```toml
[user]
    name = ItsDrike
    email = itsdrike@example.com
    signingkey = B014E761034AF742
```

## Adding user into local configuration

A thing you may have noticed in the section above is the use of `--global` flag when running the `git config` commands.
This flag means that this configuration will be stored into the global configuration that applies for every git
repository. But we can also define a configuration for a single repository, by using the `--local` flag instead. Local
configurations are actually also the default option, so we can even omit the flag entirely.

This local configuration will then be stored in the `.git` folder of your project, specifically in `.git/config`. The
settings set in this configuration will take precedence over the global ones, meaning you can have some default git
user, and some other user for a single specific local project.

```bash
git config --local user.name ItsDrike
git config --local user.email itsdrike@example.com
git config --local user.signingkey B014E761034AF742  # Signing key isn't required
```

## Git credentials

User configuration is one thing, but there's another important part of account configuration to consider, that is
storing the credentials. Even though you don't technically need to store the credentials, since git can just ask you to
enter them each time you clone a private repo, or push into a repo, it's a huge annoyance to have to do this each time.
So instead, we can use one of the below methods to store the credentials with git for longer.

### Credentials in remote-url

The most basic way of specifying credentials is to just provide them via HTTPS. You can do this in more ways, but let's
first take a look at the most straight-forward method, which is to store them into the remote URL directly:

```bash
# While clonning:
git clone https://<USERNAME>:<PASSWORD>@github.com/path/to/repo.git
# After initialized repo without any added remote:
git remote add origin 
# On an already clonned repository without the credentials:
git remote set-url origin https://<USERNAME>:<PASSWORD>@github.com/path/to/repo.git
```

Since this method requires you to specify these credentials for every repository individually, it's easily usable with
multiple accounts, but it's also still quite annoying since you'll need to set the credentials with each new repo.

{{< notice note >}}
The password here is generally meant to be a user password for the git hosting provider site, however many platforms do
also have support for "Personal Access Tokens", which are a safer, because they're limited in what they can do with
your account (for example they may only allow you to pull/push code, but not to change the account's email).
{{< /notice >}}

{{< notice warning >}}
This method stores your credentials in the project's git config file in `.git/config`. Since this is a simple URL to
one of the proejcts remotes, it will just be stored in this config file in **plaintext** without any form of encryption.

Bear this in mind when giving someone access to the project directory, your credentials will be present in that
directory!
{{< /notice >}}

### Git credential contexts

To avoid some repetition, git supports configuring per context credentials. You can configure a specific git context to
use a specific username:

```bash
git config --global credential.https://github.com.username <USERNAME>
```

Alternatively, we can directly edit the global git configuration:

```toml
[credential "https://github.com"]
	username = <USERNAME>

[credential "https://gitlab.com"]
	username = <USERNAME2>

[credential "https://gitlab.work_company.com"]
	username = <USERNAME2>
```

Each credential context is defined by a URL. This context will then be used to look up specific configuration. For
example if we're accessing `https://github.com/ItsDrike/itsdrike.com`, git looks into the config file to see if a
section matches this context. It will consider the two a match, if the context matches on both the protocols
(`http`/`https`), and then on the host portion (`github.com`/`gitlab.com`/...). It can also optionally check the paths
too, if they are present (`/ItsDrike/itsdrike.com`)

{{< notice note >}}
Git matches the hosts directly, without considering if they come from the same domain, so if subdomain differs, it will not register as a match.
For example, for context of `https://gitlab.work_company.com/user/repo.git`, it wouldn't match a configuration section
for `https://work_company.com`, since `wokr_company.com != gitlab.work_company.com`.

The paths are also matched exactly (if they're included), so for the example context from above, we would not get a
match on a config section with `https://gitlab.work_company.com/user`, only on
`https://gitlab.work_company.com/user/repo.git` (in addition to the config entry without path
`https://gitlab.work_company.com`).
{{< /notice >}}

This does sound like a great option for multi-account usage, however the issue with this approach is that these
credential contexts can only be used to store usernames, they don't support storing passwords, and you'll instead be
prompted to enter your password each time. But it does save you from re-typing the username each time.

{{< notice info >}}
The username will be stored in git's global config file in **plaintext**, making it potentially unsafe if you're
worried about leaking your **username** (not password) for the git hosting provider.

If you're using the global configuration, this generally shouldn't be a big concern, since the username won't actually
be in the project file unlike with the remote-urls. However if you share a machine with multiple people, you may want
to consider securing your global configuration file (`~/.config/git/config`) using your filesystem's permission
controls to prevent others from reading it. 

If you're defining contexts in local project's config though, you should be aware that the username will be present in
`.git/config`, and sharing this project with others may leak it.
{{< /notice >}}

### Git credential helpers

If you want to avoid both username and password repetition, and to have a safer way of storing your credentials, you
can use git's "credential helpers". These allow you to store your data in multiple ways, and even integrate with 3rd
party systems like password keychains. These credential helpers still use the same form of sending credentials, which
is to send them over HTTPS.

Out of the box, git provides 2 credential helpers:

- **Cache:** credentials stored in RAM memory for short durations
- **Store:** credentials stored indefinitely on disk

#### Store credential helper

To configure the store credential helper, you can run:

```bash
git config --global credential.helper store
```

By default, this file will be stored in `~/.git-credentials`, but this path can be changed. I'd suggest using
`~/.config/git/git-credentials` to avoid clutter in your home directory. To change the file, you can use the `file`
option:

```bash
git config --global credentials.helper 'store --file=/full/path/to/git-credentials'
```

Once the helper is configured, you will first still get asked for your username and password, and only after that first
time you enter them will the get cached into this credentials file.

{{< notice info >}}

The credentials file will cache the data in this format:

```txt
https://<USERNAME>:<PASSWORD>@github.com
```

Which is indeed a **plaintext** format, however the file will be protected with your file system permissions, and
access should be limited to you (as the user who owns the file). And since this file should live somewhere outside of
the project's directory, the project can be safely shared with others without worrying about leakage.
{{< /notice >}}

#### Cache credential helper

To configure the cache credential helper, you can run:

```bash
git config --global credential.helper cache
```

A `timeout` option can also be provided, allowing us to define how long should the credentials be kept in memory in
seconds.

```bash
git config --global credential.helper 'cache --timeout=86400'
```

The cache credential helper will never write your credential data to disk, although credentials are accessible using
Unix sockets. These sockets are protected using file permissions that are limited to the user who stored them though,
so even in multi-user machine, generally speaking, they are secure.


#### Custom credential helpers

Apart from these default options, you can also use [custom
helpers](https://git-scm.com/docs/gitcredentials#_custom_helpers). These allow us to do more sophisticated credential
management by delegating to 3rd party applications and services.

A commonly used external credential helper is for example the [Git Credential Manager
(GCM)](https://github.com/GitCredentialManager/git-credential-manager). GCM can even handle things like 2 factor
authentication, or using OAuth2.

If you want to, you can even write your own custom credential helper to handle your exact needs, in which case I'd
recommend going over git's official documentation about the credential helper system
[here](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage), where they go over this system in depth, including
some examples of a basic custom provider.

### SSH Keys

Most modern git servers also provide a way to access their repositories using SSH keys rather than username and
password over HTTPS. This approach is significantly better, since guessing SSH keys is generally much harder, and they
can easily be revoked. They also generally aren't nowhere near as powerful as full user passwords, so even if they are
compromised, the attacker would only have a limited access.

SSH uses public-private key pair, which means you will need to give out the public key over to the git hosting
platform, and keep the private part on your machine for authentication. Using the public key, the server will then be
able to safely verify that your connection is valid, without even actually knowing the key. This means that even if the
git hosting server has leaked your stored SSH key, it would be useless without the private key on your machine.

The main downside to using SSH is that it uses non-standard ports. This may mean hitting the firewall some networks or
proxies, making communication with the remote server impossible.

#### Generating an SSH key

To generate an SSH key, you can use `ssh-keygen` command line utility. Generating keys should always be done
independently from the git hosting provider, since they don't shouldn't need to see your private key at any point.

The command for this key generation looks like this:

```bash
ssh-keygen -t ed25519 -C "<COMMENT>"
```

- The `-C` flag allows you to specify a comment, which you can use to specify what this key will be used for. If you
  don't need a comment, you can also omit this flag.
- The `-t` flag specifies the key type. The default type for SSH keys is `rsa`, however I'd suggest using `ed25519`
  which is considered safer and more performant than RSA keys. If you will decide to use `rsa`, make sure to use a
  key size of at least 2048 bits, but for better security, but ideally you should try to use a key size of `4096`.

After running this command, you will be asked to specify a file where this key should be stored. You will probably want
to use some meaningful name, so that you can easily find it later. I'd recommend storing the keys in `~/.ssh/git`, so
you can have all of your git ssh keys grouped together and separated from SSH keys for actual machines or other things.

{{< notice info >}}
Make sure to add the `~/.ssh` (or `C:\Users\your_username\.ssh` for Windows) prefix to your filename, so the key is
correctly added to the `.ssh` folder. You should keep your keys in this folder, since it is already protected by the
filesystem from reading by other users.
{{< /notice >}}

Once you select a file name, you will be asked to set a passphrase. You can opt to leave this empty by pressing enter
without entering anything. Going with a passphrase protected key is safer, however it will also mean you will need to
type your password each time, which may be annoying. However there is a way to cache this passphrase with SSH agent,
which you can read more about in the [GitHub's
docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent).
Using passphrase is significantly better for your system's security, since it means that even if the private key got
leaked somehow, it would be pretty much useless without the passphrase, which the attacker likely wouldn't have.

This will then generate two keys: a public key, denoted by the file extension `.pub` and a private key, with no file
extension.

#### Add public key to your hosting provider's account

Now that you've create a public and private SSH key pair, you will need to let your git hosting provider know about it.
It is important that you only give the public key (file with `.pub` extension) to your provider, and not your private
key.

Instructions on how to add the public SSH key will differ for each platform, here are some links to documentations for
the most commonly used platforms:

- [GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
- [GitLab](https://docs.gitlab.com/ee/user/ssh.html#add-an-ssh-key-to-your-gitlab-account)
- [BitBucket](https://support.atlassian.com/bitbucket-cloud/docs/set-up-an-ssh-key/#Step-3.-Add-the-public-key-to-your-Account-settings)

{{< notice tip >}}
The documentation may tell you to use `pbcopy` or some other command line tool to copy the SSH key contents to your clipboard. For example:

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

However, if you are having trouble with this command, you can use `xsel --clipboard --input < ~/.ssh/id_ed25519.pub`
instead, or you can also just simply open up the public key file in any editor of your choosing, and copy the
**entire** file contents with Ctrl+C.
{{< /notice >}}

#### Test if it works

After adding the public key to your git hosting provider, you can verify that everything went well and the SSH key is
recognized. To run this test, you can simply issue this command (should work on both Unix and Windows systems):

```bash
ssh -T git@github.com -i ~/.ssh/id_ed25519
```

Running this command should produce a welcome message informing you that the connection works. 

If you are unsuccessful, you can run the command in verbose mode in order to get more details on why your connection
was not established.

```bash
ssh -Tvvv git@github.com -i ~/.ssh/id_ed25519
```

#### SSH Configuration file

To meaningfully use your key, you'll want register some specific host name for your key, so you won't need to use the
`-i` flag. You can do this by editing (or creating) `~/.ssh/config` file (or `C:\Users\your_username\.ssh\config` for
Windows).

An example configuration file with multiple git accounts:

```ini
# Personal GitHub account
HOST github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/git/personal_gh

# Personal GitLab account
HOST gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/git/personal_gl

# Work GitHub account
HOST work.github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/git/work_gh
```

When you have multiple accounts with the same `HostName` (same git hosting provider), you will need to specify a unique
`Host` name.

To then make sure this configuration works, you can run another test command, but this time without specifying the
key file explicitly, as it should now be getting picked up from the settings:

```bash
ssh -T git@github.com
ssh -T git@gitlab.com
ssh -T git@work.github.com
# If you've specified the `User git` in your config file, you can even omit the username here:
ssh -T github.com
ssh -T gitlab.com
ssh -T work.github.com
```

#### Using the SSH keys

No let's finally get to actually using these keys in your repositories. Doing this can be pretty straight-forward, as
it is very similar to the first method of handling credentials which I've talked about, being storing the credentials
in the remote-url. However this time, instead of using the actual credentials, and therefore making the project
directory unsafe to share, as it contains your password in plaintext, it will actually only contain the `HOST` name
you've set in your config, without leaking any keys.

The commands to set this up are very similar, however instead of `https://<USERNAME>:<PASSWORD>@github.com`, we now use
`git@HOST`:

```bash
# While clonning:
git clone git@github.com/user/repo.git
# After initialized repo without any added remote:
git remote add origin git@gitlab.com/user/repo.git
# On an already clonned repository without the credentials:
git remote set-url origin git@work.github.com/user/repo.git
```

This method does have the same disadvantage as the with the credentials passed directly into the remote-urls, which is
that you will need to do something extra for every repository where you need the credentials, but unlike with
remote-urls, it does not introduce security issues with storing the credentials in plaintext, and you also don't need
to remember the username or the password, instead you just need to know the host you set in your ssh config.

## Which method to use for credentials

Generally, using SSH keys is the safest approach, but it can also be a bit annoying since it requires you to specify
the SSH host for each repository in it's remote url. For that reason, the approach that I would recommend is using
git's credential helper system to store your credentials instead. 

However if you will go with this method, make sure that you're using a personal access token instead of the actual
account's password, to limit the permissions an attacker would gain in case your credentials were leaked. 

If your git hosting platform doesn't provide access tokens, this method becomes a lot more dangerous to use, since if
an attacker would somehow obtain the credentials file from your system, they would be able to gain full access to your
account on that git host platform. That's why in that case, you should really consider using SSH keys instead, even if
it's a bit less convenient, as they can be easily revoked and only allow limited access, just like personal access
tokens.

## Tackling credentials for multiple accounts

### Credentials for differing hosts

When it comes to managing multiple accounts, this gets a bit more tricky. But if each of your accounts lives on a
different domain/host, you can still use credential helpers without any issues, since it can handle multiple
credentials for multiple websites out of the box. If you're using the file credential helper, this would result in the
`git-credentials` file looking like this:

```txt
https://<USERNAME>:<PASSWORD>@github.com
https://<USERNAME2>:<PASSWORD2>@gitlab.com
```

With that, whenever you'd try to pull/push with the remote url, git will go through this file in order, searching for
the first matching host. So for example when using a remote url belonging to `github.com` domain, the first line would
apply, while if your remote url belongs to `gitlab.com`, the second line would apply. This means that if your accounts
are from different providers, you can avoid the hassle of doing anything more complicated.

However if you have more accounts on a single host, you will need to somehow let git know what to do.

### Using credential contexts

The good news is that even with same domains, you can actually still use the git credentials as your default method,
and use git credential contexts to find a username. With that, even if you're using the same host, git will know to
look for a specific username in the credentials file now, which should be sufficient distinction to match any amount of
different credentials.

However the issue with git contexts is that they need to match the path component exactly, so even though you can
configure git to use different contexts for different repositories in your global config, you can't configure it to use
a certain context for a partial match on path, so you'd need to specify each repository which should use custom
credentials into your global git configuration, which is not great.

Instead, you should use the local git configuration of each project and specify a git context with the username you
want to use for that project. That way, you won't need to keep config for every non-default project in your global
config, and yet still use the same file credential helper to store all of your credentials in a single place.

```bash
git config --local credential.https://github.com.username <USERNAME>
```

{{< notice info >}}
Once again, this will store the credential context into the local project's git configuration (in `.git/config`), which
is using **plaintext**, which means you might end up leaking your **username** (not password), if you give someone
access to this project's directory.

The actual password will however be completely safe, as it should only be present in the `git-credentials` file, which
should be located elsewhere, and configured from the global git config. So this only affects you if you want to keep
your username for that git hosting provider private too. If you do, you will need to keep this fact in mind when
sharing project files, or use a different method.
{{< /notice >}}

### Using different credentials file

The alternative to using credential contexts with your plaintext stored username would be using multiple
`git-credentials` files, and simply overriding the credential helper system in the local config, setting a different
file for the store credential helper. This could for example look like this:

```bash
git config credentials.helper 'store --file=/home/user/.config/git-credentials-work'
```

With this approach, you can have your credentials kept in multiple separate credential files, and just mention the path
to the file you need for each project. 

Security-wise, this method is better because your username will be kept outside of the project in the referenced git
credential file, which should be secured by the file system's permissions to prevent reads from other users. However
practicality-wise, it may be a bit more inconvenient to type and even to remember the path to each credential file. 

### SSH keys instead

The thing you may have noticed about all of these methods is that you'll generally need to do some extra work for all
repositories that require non-default credentials. So even though relying on git's file credential helper is convenient
for the default case, extending it to non-default cases will always require doing some extra configuration.

This extra configuration is inevitable, which is why I'd suggest going with SSH keys instead, which are pretty much
equally as annoying, requiring you to do something extra for each non-default project (specifying them in the remote
URL). However as I've already explained, they're pretty much the most secure way to handle credentials. So instead of
doing some extra work just to configure a less secure method, you might as well do an equal amount of work and
use the more secure way with SSH keys.

The only disadvantage to this method is then the use of non-standard ports, which some networks might end up blocking,
making connection to the server [*pretty much*]({{< ref "posts/escaping-isolated-network#port-22-is-blocked" >}})
unreachable from those networks.

## Make convenience aliases

If you really dislike the idea of all of this repetition, I'd suggest making short-hands for whichever method you
ended up picking, in the form of git aliases (you can also use shell aliases though). Git supports defining aliases
through it's configuration file, where you can use the `[alias]` section for them.

```toml
[alias]
# Clone the repository with the SSH host prefixed
work-clone="!sh -c 'git clone git@work.github.com:$1'"
# Make current repository use the work git credentials file
make-work="config --local credentials.helper 'store --file=/path/to/work/credentials'"
# Set the username for credentials to your work account, so it can find it in default git credentials
use-work-uname="config --local credential.https://github.com.username my-work-username"
```

To then use these aliases, you can simply execute them as you would any other git command:

```bash
git work-clone ItsDrike/itsdrike.com
git make-work
git user-work-uname
```
