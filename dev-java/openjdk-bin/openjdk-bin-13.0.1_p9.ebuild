# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Based on dev-java/openjdk-bin/openjdk-bin-11.0.5_p10.ebuild as of 2019-12-27

EAPI=6

inherit java-vm-2

abi_uri() {
	echo "${2-$1}? (
			https://github.com/AdoptOpenJDK/openjdk${SLOT}-binaries/releases/download/jdk-${MY_PV}/OpenJDK${SLOT}U-jdk_${1}_linux_hotspot_${MY_PV//+/_}.tar.gz
		)"
}

MY_PV=${PV/_p/+}
SLOT=${MY_PV%%[.+]*}

SRC_URI="
	$(abi_uri arm)
	$(abi_uri ppc64le ppc64)
	$(abi_uri x64 amd64)
"

DESCRIPTION="Prebuilt Java JDK binaries provided by AdoptOpenJDK"
HOMEPAGE="https://adoptopenjdk.net"
LICENSE="GPL-2-with-classpath-exception"
KEYWORDS="~amd64 ~arm ~ppc64"
IUSE="alsa cups doc examples headless-awt nsplugin selinux source +webstart"

RDEPEND="
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	>=sys-apps/baselayout-java-0.1.0-r1
	>=sys-libs/glibc-2.2.5:*
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	doc? ( dev-java/java-sdk-docs:${SLOT} )
	selinux? ( sec-policy/selinux-java )
	!headless-awt? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXtst
	)"

PDEPEND="webstart? ( >=dev-java/icedtea-web-1.6.1:0 )
	nsplugin? ( >=dev-java/icedtea-web-1.6.1:0[nsplugin] )"

RESTRICT="preserve-libs splitdebug mirror"
QA_PREBUILT="*"

S="${WORKDIR}/jdk-${MY_PV}"

pkg_pretend() {
	if [[ "$(tc-is-softfloat)" != "no" ]]; then
		die "These binaries require a hardfloat system."
	fi
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED%/}/${dest#/}"

	# Not sure why they bundle this as it's commonly available and they
	# only do so on x86_64. It's needed by libfontmanager.so. IcedTea
	# also has an explicit dependency while Oracle seemingly dlopens it.
	rm -vf lib/libfreetype.so || die

	# Oracle and IcedTea have libjsoundalsa.so depending on
	# libasound.so.2 but AdoptOpenJDK only has libjsound.so. Weird.
	if ! use alsa ; then
		rm -v lib/libjsound.* || die
	fi

	if ! use examples ; then
		rm -vr demo/ || die
	fi

	if use headless-awt ; then
		rm -v lib/lib*{[jx]awt,splashscreen}* || die
	fi

	if ! use source ; then
		rm -v lib/src.zip || die
	fi

	rm -v lib/security/cacerts || die

	dodir "${dest}"
	cp -pPR * "${ddest}" || die

	dosym "${EPREFIX}"/etc/ssl/certs/java/cacerts "${dest}"/lib/security/cacerts

	java-vm_set-pax-markings "${ddest}"
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
}

pkg_postinst() {
	java-vm-2_pkg_postinst

	ewarn "This JDK will not be recognised by the system. For example, simply"
	ewarn "calling \"java\" will launch a different JVM. This is necessary"
	ewarn "until Gentoo fully supports Java 13. This JDK must therefore be"
	ewarn "invoked using its absolute location under ${EPREFIX}/opt/${P}."
}
