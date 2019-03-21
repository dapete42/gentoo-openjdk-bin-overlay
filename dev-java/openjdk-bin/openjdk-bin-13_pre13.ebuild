# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Original version based on:
# dev-java/oracle-jdk-bin/oracle-jdk-bin-9.0.4-r2.ebuild

EAPI=7

KEYWORDS="-* ~amd64"

PV_MAJOR="$(ver_cut 1)"
PV_BUILD="$(ver_cut 3)"

declare -A ARCH_FILES
ARCH_FILES[amd64]="https://download.java.net/java/early_access/jdk${PV_MAJOR}/${PV_BUILD}/GPL/openjdk-${PV_MAJOR}-ea+${PV_BUILD}_linux-x64_bin.tar.gz"

for keyword in ${KEYWORDS//-\*} ; do
	SRC_URI+=" ${keyword#\~}? ( ${ARCH_FILES[${keyword#\~}]} )"
done

DESCRIPTION="OpenJDK (only extracted to /opt, not properly installed)"
HOMEPAGE="http://jdk.java.net/"
LICENSE="GPL-2-with-classpath-exception"
SLOT="${PV_MAJOR}"
IUSE="alsa headless-awt source"
REQUIRED_USE=""
RESTRICT="mirror preserve-libs strip"
QA_PREBUILT="*"

RDEPEND="!headless-awt? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXtst
	)
	alsa? ( media-libs/alsa-lib )"

src_unpack() {
	unpack ${A}
	S="${WORKDIR}/jdk-${PV_MAJOR}"
}

src_install() {
	local dest="/opt/openjdk-${PV_MAJOR}-ea+${PV_BUILD}"
	local linkdest="/opt/openjdk-${PV_MAJOR}-latest"
	local ddest="${ED%/}/${dest#/}"

	if ! use alsa ; then
		rm -vf lib/libjsoundalsa.* || die
	fi

	if use headless-awt ; then
		rm -vf lib/lib*{[jx]awt,splashscreen}* \
		   bin/appletviewer || die
	fi

	if ! use source ; then
		rm -v lib/src.zip || die
	fi

	dodir "${dest}"
	cp -pPR * "${ddest}" || die

	dosym "${dest}/" "${linkdest}"
}

pkg_postinst() {
	elog "OpenJDK ${PV_MAJOR} early access build ${PV_BUILD} has been installed here:"
	elog "\t/opt/openjdk-${PV_MAJOR}-ea+${PV_BUILD}"
	elog
	elog "Additionally, a symlink pointing to this has been created here:"
	elog "\t/opt/openjdk-${PV_MAJOR}"
	elog "This symlink will be the same for all OpenJDK ${PV_MAJOR} versions installed"
	elog "like this."
	elog
	elog "Gentoo's Java configuration is not aware of this. If you want to use"
	elog "OpenJDK ${PV_MAJOR} EA ${PV_BUILD}, use the binaries here:"
	elog "\t/opt/openjdk-${PV_MAJOR}/bin/"
}
