# openjdk-bin overlay

This is an overlay for Gentoo which includes binary packages for OpenJDK 10+ that are not long term support versions.

Gentoo's official Portage tree contains ebuilds for the long term support versions (currently OpenJDK 11). The ebuilds in this overlay are based on these. Just as the official ebuilds, these do not integrate with Gentoo's java support; they just extract official OpenJDK builds to */opt/*.

## Setting up the overlay using Layman

This overlay is most easily integrated into Portage using [Layman](https://wiki.gentoo.org/wiki/Layman).

1. Install Layman, if it is not already installed (using `emerge layman`), making sure the *git* `USE` flag is enabled (since this overlay is accessed through Git).
2. Download [openjdk-bin.xml](https://raw.githubusercontent.com/dapete42/gentoo-openjdk-bin-overlay/master/openjdk-bin.xml) and place it in */etc/layman/overlays/*
3. Update overlays and add the *openjdk-bin* overlay: `layman -S && layman -a openjdk-bin`

## Installation

`emerge openjdk-bin` will install the latest stable version. The ebuilds are slotted; so using e.g. `emerge openjdk-bin:13` it is possible to always get the newest version of OpenJDK 13.

The JDK is extracted to */opt/*. The exact name depends on the version installed.
