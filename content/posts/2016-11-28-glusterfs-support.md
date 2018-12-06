---
title: 'GlusterFS support for Libvirt, Qemu, Samba & TGT in Ubuntu'
date: 2016-11-28 19:00:00
categories: ["ubuntu", "glusterfs", "libvirt", "qemu", "samba", "launchpad", "tgt"]
tags: ["Blog"]
---

***

Update: As i don't use GlusterFS at the moment my repo is outdated. Maybe you can use my old buildscripts to create your own DEB packages

 * https://github.com/monotek/glusterfs-launchpad-buildscripts

***

Unfortunately GlusterFS is in the Ubuntu universe repository. Therefore Libvirt, Qemu, Samba, TGT and other packages from main repository are build without GlusterFS LibGfApi support.

For this reason i've created some PPAs on Launchpad which contain these packages with GlusterFS support.

Just visit: [https://launchpad.net/~monotek](https://launchpad.net/~monotek)

Updates to this PPAs are announced on my [Twitter channel](https://twitter.com/mono_tek)
