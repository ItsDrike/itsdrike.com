---
title: Jumping on the BTRFS hype wagon
date: 2024-01-27
tags: [linux]
sources:
  - <https://wiki.archlinux.org/title/btrfs>
  - <https://docs.kernel.org/filesystems/btrfs.html>
  - <https://en.wikipedia.org/wiki/Btrfs>
  - <https://www.thegeekdiary.com/features-of-the-btrfs-filesystem/>
---

After a long time constantly hearing about BTRFS filesystem, I decided to make the jump, leaving EXT4 behind. And I
have to say, I couldn't be happier.

For those unaware, BTRFS is a B-tree based filesystem, which you can use as an alternative to EXT4, with some really
cool new features, which I'll mention in the post here. In many ways, it is similar to ZFS, but it is meant for
personal use, rather than being enterprise focused, and unlike with ZFS, there aren't any licensing controversies
accompanying it.

## Subvolumes

First thing to mention (and for me probably the most important thing) about BTRFS is it's feature allowing you to
create subvolumes.

Volumes are sort of like partitions, however instead of being done on the device level, specified in a partition table
with concrete start and end sectors, making it occupy a very specific, well, "partiton" of the drive, subvolumes are a
feature of the filesystem, allowing you to split it up into individual portions, that all live on a single BTRFS
partition.

### Dynamic space

This is really cool, because these subvolumes can act almost like plain folders within the BTRFS root, and that means
they don't have to have a size specified. They will all simply share the single partition, and all of the subvolumes
will have the same amount of free space as there is available on the entire partition.

You can therefore really easily create separate subvolumes for your home (/home) and root (/), mount them individually,
and pretty much treat them like regular partitions, but without having to make the decision about how to divide your
disk space between them during installation.

For me, this is a HUGE benefit, because I'm a major proponent for the split architecture, where your home and root (or
at least root and some kind of persistent data partition) are separate. This is because it allows you to only wipe out
one of them when reinstalling, without the need to copy-over potentially hundreds of gigabytes of data from a backup.

In EXT4, it was always annoying to have to decide on how much space to allocate to each partition, because I knew that
I could use the extra space for my data, but if I ever ran out of space in my root partition, it would pretty much mean
I'm gonna have to reinstall, and re-partition, as there's really no good way to expand a partition without corrupting
the one right below.

This setup finally changed that, and I can keep my data separate and persistent across installations, without having to
compromise on space for my root partition.

{{< notice tip >}}
While subvolumes are dynamic by default, it is actually possible to set a cap for the max size that subvolume can reach
if you need to do so. This can be useful to prevent something growing unpredictably in size. This limit can later be
easily increased if needed, making it far superior to regular partitions, which would need to be moved/recreated.
{{< /notice >}}

### Automatic compression

Another great feature BTRFS subvolumes give you is the ability to specify different compression levels on each of your
subvolumes. BTRFS allows you to pick from various compression algorithms, but the most common one which you'll probably
want to use too is `zstd`. You can then a compression level 1-10, which will control how aggressive the compression
will be.

This is really nice, because you can set up a separate subvolume for your cache or static data files, to be compressed
at high levels, which will cost some CPU time and slow down the read/write speeds to the data stored there, but at the
benefit of greatly reducing the disk size, while keeping your root subvolume, which will be written to a lot at a low
compression level (or even disable the compression there), and will therefore have a much quicker disk speeds.

Because cache files usually aren't accessed that often, and contain a lot of data (like for example the pacman package
cache, which will contain the older versions of packages you installed, to allow easily reverting), I find it really
worth it to be able to create a highly compressed subvolume mounted on `/var/cache`. Additionally, I also have a pretty
high compression level on my data subvolume, though since it does contain videos, I don't necessarily use the highest
compression level there, to allow me to seamlessly watch them without disk buffering.

## Snapshots

Another really cool feature that BTRFS has is the ability to take instant snapshots of a volume, for great backups.
This is possible because the snapshot create will essentially just be a link, pointing to the current state of the
subvolume it targets, so the only thing that happens on the file-system side is basically a creation of that link,
there's no copying done anywhere!

### Technical explanation

You can basically think of these as hard-links, pointing to the subvolume itself. Since BTRFS is a **copy-on-write**
filesystem, rather than modifying the blocks affected (a single file can take up a lot of physical blocks), which is
what EXT4 would do, it instead creates new blocks, where the data for that file is written to, and updating the file
metadata, telling it that it should now use these new blocks.

This is really nice, because when writing to the disk, you're gonna be writing a whole block at a time anyway, so
instead of overwriting the existing old one, BTRFS will use a new one, leaving the old ones behind. So if a file is
composed of a lot of blocks, only the blocks that actually changed will be copied, and BTRFS will store the information
that a part of that file is now in some other physical blocks.

(Not updating the original location also eliminates the risk of a partial update or data corruption during a power
failure.)

That means you can create hard-links that point to the original blocks, rather than the original files, and since BTRFS
won't change those original blocks, but instead will copy the changes to new blocks, these hard-links remain unaffected
by any new changes.

In an EXT4 filesystem, is you have a hard-link, it will always be linked to the inode, representing the hard-linked
file, and whenever the file is updated, it's the blocks specified by that inode that get updated, meaning you'll end up
with it being modified both on the original (system) file, and in the hard-link pointing to it.

This kind of hard-link behavior is also possible on BTRFS systems, however you can also hard-link in a way that doesn't
update, and instead just holds the original blocks, so as the real system is changing, it's pretty much only the
deltas/diffs that get stored, making the backup only take as much space, as the newly made changes since it was taken.

Once a snapshot is deleted, the old blocks that aren't used in the primary volume anymore will be allowed to get
overwritten, hence gaining that space back.

### Backups at no cost

Because of the way BTRFS handles snapshots, it therefore allows us to make backups which are essentially just the size
of a single link, and are instant. They only get expensive as the original subvolume gets updated. This means it's
really beneficial to set up an auto-snapshot routine with auto-rotation, and taking a lot of snapshots. For example,
this is mine:

- 8 hourly snapshots (taken using cron, once we reach 9th snapshot, the oldest one is deleted)
- 4 quaterly snapshots (taken using cron, every 15 minutes, except on the full hour, as that's covered by hourly)
- 8 daily snapshots (taken by anacron, every day)
- 4 weekly snapshots (taken by anacron)
- 3 monthly snapshots (taken by anacron)

Notice just how many hourly and quaterly snapshots I'm able to take, literally I make a snapshot of my system every 15
minutes, and i don't even notice!! It comes at no performance cost, not high CPU usage as the files are being copied
over, all perfectly seamless.

To achieve this, I made a bash script that can handle this auto-rotation and snapshot taking, which I'm just calling
from cron/anacron. If you're interested, you can find it in my
[dotfiles](https://github.com/ItsDrike/dotfiles/blob/main/root/usr/local/bin/btrfs-backup).

The only backups that I do see some actual space cost from are the monthly ones, which do get out of sync eventually,
and so a lot of files are indeed different there.

### Stupid simple restore

Snapshots of subvolumes themselves are just another subvolumes, and if you need to restore a snapshot, all you need to
do is change the path where your main subvolume is pointing to, switching it to that backup, and done, you've restored
from a snapshot.

This is super cool, because you can for example take some snapshots during your installation, and if you want to
reinstall, you can just revert back to those.

Another really useful thing this allows is to take a snapshot before installing some big app that you really only need
to use once, and then revert back, making sure that no residual files from that app will be left behind. Having
quaterly snapshots is especially useful here, since you may install something you think you'll want to be using for a
long time, only to realize it's actually not all that good.

{{< notice warning >}}

With all this great talk about snapshots, you may think that once set up, you'll never need to do those tedious full
system backups ever again. Well, that's not true. While snapshots really are amazing, remember that they still all live
on a single partition in a single drive. If this drive were to fail, all of your data on it, including the snapshots
might get corrupted.

For that reason, it is very important that you don't just blindly replace your full backup strategies here.

{{< /notice >}}

## Multiple system versions

Another amazing thing you can set up is creating automated boot records for every snapshot, allowing you to boot into
an older version of your system completely seamlessly.

All you need to do to make this work is changing the kernel arguments and defining a different subvolume as your
root, specifically, the subvolume containing the snapshot you want to boot into.

Not only is this really useful for getting into an older system version by booting into snapshots, you can actually use
non-snapshot subvolumes too. That means you could easily even keep multiple distributions on a single BTRFS partition.
(With dynamic space, shared for each system.)

## Built-in RAID

BTRFS also has a built-in support for RAID-0, RAID-1 and RAID-10 levels.

This type of RAID will ensure that for every block, there are "x" amount of copies. For RAID-1 for example, BTRFS
just stores two copies of everything on two different devices.

Unlike a simple `mdadm` software raid, BTRFS supports self-healing redundant arrays and online balancing, as BTRFS
maintains CRC's for all metadata and data so everything is checksummed to preserve the integrity of data against
corruption. With RAID-1 or RAID-10 configuration, if the checksum fails on the first read, data is pulled off from
another copy.

## Great SSD performance

Another benefit of BTRFS is it's automatic detection of solid state drives (SSDs). If an SSD is detected, BTRFS will
turn off all optimization for rotational media (i.e. optimizations to reduce seeking, by storing related data close
together on spinning drives, which isn't important with SSDs). Alongside that, there's also TRIM support, which tells
the SSD which blocks are no longer needed and are available to be written over.

These will improve reading/writing speed, since the useless CPU intensive operations for spinning drives are disabled,
and it can also extend your SSD's lifespan, due to that TRIM support.

## Efficient storage for small files

All Linux filesystems address storage in blocks. These blocks have some pre-defined size, like say 4KB. That means
storing a file that's smaller than this size will result in the block not being completely utilized. Using a smaller
block size isn't a good option either, because it means having to store more metadata (there's more blocks to keep
track of).

On BTRFS, for very small files, the data will actually be stored in the metadata, without taking up any of the data
blocks!
