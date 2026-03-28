# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev

DESCRIPTION="XR Hardware Rules"
HOMEPAGE="https://gitlab.freedesktop.org/monado/utilities/xr-hardware"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/monado/utilities/xr-hardware.git"
	EGIT_BRANCH="main"
else
	SRC_URI="https://gitlab.freedesktop.org/monado/utilities/xr-hardware/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64"
fi

LICENSE="Boost-1.0"
SLOT="0"

DOCS=( README.md LICENSE.txt )

src_compile() { :; }

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install_package
	einstalldocs
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
