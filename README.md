# dapete42-openjdk-bin overlay

This is an overlay for Gentoo which includes binary packages for OpenJDK 10+.

These packages do not integrate with Gentoo's java support; they just extract official OpenJDK builds to **/opt/**.

## Installation using Layman

This overlay is most easily integrated into Portage using [Layman](https://wiki.gentoo.org/wiki/Layman).

1. Install Layman, if it is not already installed: `emerge layman`
2. Download *[dapete42-openjdk-bin.xml](https://raw.githubusercontent.com/dapete42/gentoo-openjdk-bin-overlay/master/dapete42-openjdk-bin.xml)* and place it in **/etc/layman/overlays/**.
3. Add it to layman: `layman -a `dapete42-openjdk-bin`
