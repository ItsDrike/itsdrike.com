---
title: Managing (multiple) git credentials
date: 2022-07-27
lastmod: 2024-06-05
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
changelog:
  2023-01-30:
    - Add note about disabling commit signing
    - Add alternative command for copying on wayland
    - Fix typos and text wrapping
  2024-06-05:
    - Improve path matching explanation/note on git credentials helper, detailing the pitfalls it has with multiple
      accounts on the same git hosting platform.
    - Wording improvements
    - Rewrite tackling multiple accounts section
    - Include bash aliases example
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

{{< notice tip >}}
If your global git config has commit signing enabled by default, but you don't want to sign commits for the locally
configured account, you can disable it with:

```bash
git config --local commit.gpgsign false
```

{{< /notice >}}

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
one of the projects remotes, it will just be stored in this config file in **plaintext** without any form of encryption.

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
section matches this context.

Git will consider the two a match, if the context matches on both the protocols (`http`/`https`), and then on the host
portion (`github.com`/`gitlab.com`/...). It can also optionally check the paths too, if they are present
(`/ItsDrike/itsdrike.com`)

{{< notice note >}}
Git matches the paths exactly (if they're included). That means a configured credential like `https://github.com/user1`
will NOT match an origin of `https://github.com/user1/repo.git`, so you would need a credential entry for each repository.

This may not be an issue, if you're trying to use this with multiple accounts on different git host platforms (like on
`github.com` and `gitlab.com`), where you could just leave the credential to match only on the host, and not include
any path. However, if you're trying to use multiple accounts with the same host, it will not work very well.

Similarly, git matches the hosts directly too, without considering if they come from the same domain, so if subdomain
differs, it will not register as a match either. This means that for origin like:
`https://gitlab.work_company.com/user/repo.git`, git wouldn't match a configuration credential section for
`https://work_company.com`, since `work_company.com != gitlab.work_company.com`.
{{< /notice >}}

This does sound like a great option for multi-account usage, however the issue with this approach is that these
credential contexts can only be used to store usernames, they don't support storing passwords, and you'll instead be
prompted to enter your password each time. But it does save you from re-typing the username each time.

{{< notice info >}}
The username will be stored in git's global config file in **plaintext**, making it potentially unsafe if you're
worried about leaking your **username** (not password) for the git hosting provider.

If you're using the global configuration, this generally shouldn't be a big concern, since the username won't actually
be in the project file unlike with the remote-urls. However, if you share a machine with multiple people, you may want
to consider securing your global configuration file (`~/.config/git/config`) using your file system's permission
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

{{< notice note >}}
This has the same matching pitfalls as credential contexts defined in settings, the URL paths are matched exactly, and
so are URL hosts.
{{< /notice >}}

{{< notice info >}}
The credentials file will cache the data in this format:

```txt
https://<USERNAME>:<PASSWORD>@github.com
https://<USERNAME2>:<PASSWORD>@gitlab.com
```

Which is indeed a **plaintext** format, however the file will be protected with your file system permissions, and
access should be limited to you (as the user who owns the file). And since this file should live somewhere outside
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
(GCM)](https://github.com/GitCredentialManager/git-credential-manager). GCM can even handle things like 2-factor
authentication, or using OAuth2.

If you want to, you can even write your own custom credential helper to handle your exact needs, in which case I'd
recommend going over git's official documentation about the credential helper system
[here](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage), where they go over this system in depth, including
some examples of a basic custom provider.

### SSH Keys

Most modern git servers also provide a way to access their repositories using SSH keys rather than username and
password over HTTPS. This approach is significantly better, since guessing SSH keys is generally much harder, and they
can easily be revoked. They also generally aren't anywhere near as powerful as full user passwords, so even if they are
compromised, the attacker would only have limited access.

SSH uses public-private key pair, which means you will need to give out the public key over to the git hosting
platform, and keep the private part on your machine for authentication. Using the public key, the server will then be
able to safely verify that your connection is valid, without even actually knowing the key. This means that even if the
git hosting server has leaked your stored SSH key, it would be useless without the private key on your machine.

The main downside to using SSH is that it uses non-standard ports. This may mean hitting the firewall some networks or
proxies, making communication with the remote server impossible.

#### Generating an SSH key

To generate an SSH key, you can use `ssh-keygen` command line utility. Generating keys should always be done
independently of the git hosting provider. The git hosting provider shouldn't need to see your private key at any
point!

The command for this key generation looks like this:

```bash
ssh-keygen -t ed25519 -C "<COMMENT>"
```

- The `-C` flag allows you to specify a comment, which you can use to specify what this key will be used for. If you
  don't need a comment, you can also omit this flag.
- The `-t` flag specifies the key type. The default type for SSH keys is `rsa`, however I'd suggest using `ed25519`
  which is considered safer and more performant than RSA keys. If you decide to use `rsa`, make sure to use a
  key size of at least 2048 bits, but for better security, but ideally you should try to use a key size of `4096`.

After running this command, you will be asked to specify a file where this key should be stored. You will probably want
to use some meaningful name, so that you can easily find it later. I'd recommend storing the keys in `~/.ssh/git`, so
you can have all of your git ssh keys grouped together and separated from SSH keys for actual machines or other things.

{{< notice info >}}
Make sure to add the `~/.ssh` (or `C:\Users\your_username\.ssh` for Windows) prefix to your filename, so the key is
correctly added to the `.ssh` folder. You should keep your keys in this folder, since it is already protected by the
file system from reading by other users.
{{< /notice >}}

Once you select a file name, you will be asked to set a passphrase. You can opt to leave this empty by pressing enter
without entering anything. Going with a passphrase protected key is safer, however it will also mean you will need to
type your password each time, which may be annoying. However, there is a way to cache this passphrase with SSH agent,
which you can read more about in the [GitHub's
docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#adding-your-ssh-key-to-the-ssh-agent).
Using passphrase is significantly better for your system's security, since it means that even if the private key got
leaked somehow, it would be pretty much useless without the passphrase, which the attacker likely wouldn't have.

This will then generate two keys: a public key, denoted by the file extension `.pub` and a private key, with no file
extension.

#### Add public key to your hosting provider's account

Now that you've created a public and private SSH key pair, you will need to let your git hosting provider know about it.
It is important that you only give the public key (file with `.pub` extension) to your provider, and not your private
key.

Instructions on how to add the public SSH key will differ for each platform, here are some links to documentations for
the most commonly used platforms:

- [GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
- [GitLab](https://docs.gitlab.com/ee/user/ssh.html#add-an-ssh-key-to-your-gitlab-account)
- [BitBucket](https://support.atlassian.com/bitbucket-cloud/docs/set-up-an-ssh-key/#Step-3.-Add-the-public-key-to-your-Account-settings)

{{< notice tip >}}
The documentation may tell you to use `pbcopy` or some other command line tool to copy the SSH key contents to your
clipboard. For example:

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

However, if you are having trouble with this command, you can use `xsel --clipboard --input < ~/.ssh/id_ed25519.pub`
instead, or `wl-copy < ~/.ssh/id_ed25519` on wayland. You can also just simply open up the public key file in any
editor of your choosing, and copy the **entire** file contents with Ctrl+C (if you're one of the weird people that use
windows, this is your only option).
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

To meaningfully use your key, you'll want to register some specific host name for your key, so you won't need to use
the `-i` flag. You can do this by editing (or creating) `~/.ssh/config` file (or `C:\Users\your_username\.ssh\config`
for Windows).

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
`HOST` name. One way which I like to do is to make it appear as a subdomain, like `work.github.com`. Another common way
to define these, is to use a dash at the end, like: `github.com-user2`. FINALLY, We've cracked the issue of storing
multiple credentials even on the same git hosting platform.

Let's first make sure this configuration works though. To do that, you can run another test command, but this time
without specifying the key file explicitly, as it should now be getting picked up from the settings:

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

Now let's get to actually using these keys in your repositories. Doing this can be pretty straight-forward, as it is
very similar to the first method of handling credentials which I've talked about, being storing the credentials in the
remote-url, but this time, instead of using the actual credentials, and therefore making the project directory unsafe
to share, it will just contain the `HOST` name you've set in your config, without leaking any keys.

The commands to set this up are therefore very similar, except that instead of
`https://<USERNAME>:<PASSWORD>@github.com/<PATH>`, we now use `git@HOST/<PATH>`:

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

Generally, using SSH keys is the safest and probably the best approach, but it can also be a bit annoying since it
requires you to specify the SSH host for each repository in its remote url. For that reason, the approach that I would
recommend is using git's file credential helper system to store your credentials instead.

However, if you will go with this method, make sure that you're using a personal access token instead of the actual
account's password, to limit the permissions an attacker would gain in case your credentials were leaked.

If your git hosting platform doesn't provide access tokens, this method becomes a lot more dangerous to use, since if
an attacker would somehow obtain the credentials file from your system, they would be able to gain full access to your
account on that git host platform. That's why in that case, you should really consider using SSH keys instead, even if
it's a bit less convenient, as they can be easily revoked and only allow limited access, just like personal access
tokens.

From what we've seen up until for now, the store credential helper method is only good if you only have a single account
per git hosting platform though; so... what if you have multiple accounts?

### Combine both store credential helper & SSH keys

The simple solution to this issue is to just use both SSH and store credential helpers. That way, you can just clone
with regular unmodified URLs, letting the store credential helper figure out which credential to use on a per-platform
basis. Leaving the alt accounts you have on a single platform to SSH, where your store credential helper only knows
about your primary account, and you have SSH config entries set for each of your alt accounts.

Whenever you then want to use an alt account for a repo, instead of cloning with the regular URL, you will clone with
the SSH url for your alt account.

This method is pretty much perfect, and there's not many downsides to it. However, I will also show you some other
interesting methods, which you might like more if you don't want to mess around with SSH keys, or if your git hosting
provider doesn't support them. You might also just not like the idea of having to change the remote URL path of your
repository to this special path with the SSH host, which the other solutions will avoid.

### Using credential contexts

Remember the credential contexts we were defining? (The URLs that git could match against to figure out which
username to use.) Well, we can actually use these, but set the username to be used for the platform in local
configuration. To do that, you can just run:

```bash
git config --local credential."https://github.com".username <USERNAME>
```

This will mean git will now know what username should be used for the given remote url. With that, our store
credentials helper can now be a bit smarter, and instead of just picking the first entry in your `git-credentials`
file, that matches the given remote url, it will also look for a username match. So for example, if you set the
username in that local config to `user2`, and you had this in your `git-credentials`:

```
https://user1:<PASSWORD>@github.com
https://user2:<PASSWORD2>@github.com
```

It would actually pick the 2nd record now, because of the username match. (When no username is configured, the store
credentials helper will always pick the 1st record.)

{{< notice info >}}
This will however store the credential context into the local project's git configuration (in `.git/config`), which is
using **plaintext**, which means you might end up leaking your **username** (not password), if you give someone access
to this project's directory.

The actual password will however be completely safe, as it should only be present in the `git-credentials` file, which
should be located elsewhere, and configured from the global git config. So this only affects you if you want to keep
your username for that git hosting provider private too. If you do, you will need to keep this fact in mind when
sharing project files, or use a different method.
{{< /notice >}}

This method is fine, but in my opinion, it's a bit clunky, since you need to also specify the remote URL here, and it
leaks your username on the platform. Because of that, I think the method below is a better option, but this method is
still good to know about, and might be a better option for you, depending on your preferences.

### Using different credentials file

Let's try and hack our way through the problem and do everything while sticking to just the store credentials helper.
Do you remember how when we first configured the credential helpers, we specified the path to the `git-credentials`
file it should write the credentials to?

Well, we stored that value to our global config, but of course, local config will override global config, so we could
just set a different file for the store credential helper, which contains our alt account! Doing that is a simple as
running this command:

```bash
git config --local credentials.helper 'store --file=/home/user/.config/git-credentials-alt'
```

Security-wise, this method is pretty good too, since your credentials will be kept outside the project in the referenced git
credential file, which should be secured by the file system's permissions to prevent reads from other users. When done
properly, this won't even leak your usernames, just make sure not to include the username as a part of the file name.
(That is, if you care about not leaking your username)

## Make convenience aliases

Like I've already mentioned, if you work with different accounts a lot, you will certainly want to make convenience
aliases to hide all the account switching logic away. You can do this in the form of git aliases, or bash aliases,
by putting this to your `~/.config/git/config`:

```toml
[alias]
# Clone the repository with the SSH host prefixed
work-clone="!sh -c 'git clone git@work.github.com:$1'"
# Make current repository use the work git credentials file
make-work="config --local credentials.helper 'store --file=/path/to/work/credentials'"
# Set the username for credentials to your work account, so it can find it in default git credentials
use-work-uname="config --local credential.'https://github.com'.username my-work-username"
```

To then use these aliases, you can simply execute them as you would any other git command:

```bash
git work-clone ItsDrike/itsdrike.com
git make-work
git user-work-uname
```

What I like to do is to define a bash function, which will not only set the appropriate credentials, but also a
different local committer name and email, with the commands shown at the beginning. That could then look like this:

```bash
git-work() {
    git config --local user.email "john_doe@work.com"
    git config --local user.name "John Doe"
    git config --local user.signingkey 4F3C14B2C3AE9246
    git config --local credential."https://github.com.username" johndoe_work
}

git-alt() {
    git config --local user.email "pseudonym@example.com"
    git config --local user.name "pseudonym"
    git config --local user.signingkey 522DC4E2A20A92B8
    git config --local credential."https://github.com.username" jogndoe_2
}
```

While leaving my primary account defined in my global git configuration.
