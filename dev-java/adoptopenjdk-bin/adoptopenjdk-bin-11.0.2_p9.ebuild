# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Original version based on:
# dev-java/oracle-jdk-bin/oracle-jdk-bin-9.0.4-r2.ebuild

EAPI=7

KEYWORDS="-* amd64"

PV_MAJOR="$(ver_cut 1)"
PV_FULL="$(ver_cut 1-3)"
PV_BUILD="$(ver_cut 5)"

declare -A ARCH_FILES
ARCH_FILES[amd64]="https://github.com/AdoptOpenJDK/openjdk${PV_MAJOR}-binaries/releases/download/jdk-${PV_FULL}%2B${PV_BUILD}/OpenJDK11U-jdk_x64_linux_hotspot_${PV_FULL}_${PV_BUILD}.tar.gz"

for keyword in ${KEYWORDS//-\*} ; do
	SRC_URI+=" ${keyword#\~}? ( ${ARCH_FILES[${keyword#\~}]} )"
done

DESCRIPTION="AdoptOpenJDK (only extracted to /opt, not properly installed)"
HOMEPAGE="https://adoptopenjdk.net/"
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
	S="${WORKDIR}/jdk-${PV_FULL}+${PV_BUILD}"
}

src_install() {
	local dest="/opt/adoptopenjdk-${PV_FULL}+${PV_BUILD}"
	local linkdest="/opt/adoptopenjdk-${PV_MAJOR}"
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

	if [ "${dest}" != "${linkdest}" ] ; then
		dosym "${dest}/" "${linkdest}"
	fi
}

pkg_postinst() {
	elog "AdoptOpenJDK ${PV_FULL}+${PV_BUILD} has been installed here:"
	elog "\t/opt/adoptopenjdk-${PV_FULL}+${PV_BUILD}"
	elog
	if [ "${PV}" != "${PV_MAJOR}" ] ; then
		elog "Additionally, a symlink pointing to this has been created here:"
		elog "\t/opt/adoptopenjdk-${PV_MAJOR}"
		elog "This symlink will be the same for all AdoptOpenJDK ${PV_MAJOR} versions"
		elog "installed like this."
		elog
	fi
	elog "Gentoo's Java configuration is not aware of this. If you want to use"
	elog "AdoptOpenJDK ${PV_FULL}+${PV_BUILD}, use the binaries here:"
	elog "\t/opt/adoptopenjdk-${PV_MAJOR}/bin/"
}
