EAPI=6

inherit versionator

KEYWORDS="-* amd64"

# this changes for every version, see download link on HOMEPAGE
DOWNLOAD_PATH_SECRET="19aef61b38124481863b1413dce1855f/13"

PV_MAJOR="$(get_major_version)"

declare -A ARCH_FILES
ARCH_FILES[amd64]="https://download.java.net/java/GA/jdk${PV_MAJOR}/${PV}/${DOWNLOAD_PATH_SECRET}/openjdk-${PV}_linux-x64_bin.tar.gz"

for keyword in ${KEYWORDS//-\*} ; do
	SRC_URI+=" ${keyword#\~}? ( ${ARCH_FILES[${keyword#\~}]} )"
done

DESCRIPTION="OpenJDK (only extracted to /opt, not properly installed)"
HOMEPAGE="http://jdk.java.net/${PV_MAJOR}/"
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
	unpack "${A}"
	S="${WORKDIR}/jdk-${PV}"
}

src_install() {
	local dest="/opt/openjdk-${PV}"
	local linkdest="/opt/openjdk-${PV_MAJOR}"
	local ddest="${ED}${dest#/}"

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

	elog
	elog "OpenJDK ${PV} has been installed here:"
	elog "\t${dest}"
	elog
	elog "Additionally, a symlink pointing to this has been created here:"
	elog "\t${linkdest}"
	elog "This symlink will be the same for all OpenJDK ${PV_MAJOR} versions installed"
	elog "like this."
	elog
	elog "Gentoo's Java configuration is not aware of this. If you want to use"
	elog "OpenJDK ${PV}, use the binaries here:"
	elog "\t${linkdest}/bin/"
	elog
}

