# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="XR Hardware Rules"
HOMEPAGE="https://gitlab.freedesktop.org/monado/utilities/xr-hardware"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/monado/utilities/xr-hardware.git"
	EGIT_BRANCH="main"
else
	SRC_URI="https://gitlab.freedesktop.org/monado/utilities/xr-hardware/-/archive/${PV}/${P}.tar.bz2"
fi

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"

# TODO: use install_package

DOCS=( README.md LICENSE.txt )
