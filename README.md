# openjdk-bin overlay

This is an overlay for Gentoo which includes binary packages for OpenJDK 10+. These packages do not integrate with Gentoo's java support; they just extract official OpenJDK builds to */opt/*. They are meant as a stopgap to automatically install a current JDK or JRE until Gentoo officially supports anything beyond Java 8.

## Setting up the overlay using Layman

This overlay is most easily integrated into Portage using [Layman](https://wiki.gentoo.org/wiki/Layman).

1. Install Layman, if it is not already installed (using `emerge layman`), making sure the *git* `USE` flag is enabled (since this overlay is accessed through Git).
2. Download [openjdk-bin.xml](https://raw.githubusercontent.com/dapete42/gentoo-openjdk-bin-overlay/master/openjdk-bin.xml) and place it in */etc/layman/overlays/*
3. Update overlays and add the *openjdk-bin* overlay: `layman -S && layman -a openjdk-bin`

## Installation

`emerge openjdk-bin` will install the latest stable version. The ebuilds are slotted; so using e.g. `emerge openjdk-bin:11` it is possible to always get the newest version of OpenJDK 11.

The JDK is extracted to */opt/*. The exact name depends on the version installed; if necessary a symlink will be created so that, going back to the example, */opt/openjdk-11* will now always point to an installation of the OpenJDK.

The builds are the official Oracle builds of OpenJDK. The `USE` flags supported are *alsa*, *headless-awt* and *source*. These function in the same way as on official Gentoo Java ebuilds.
