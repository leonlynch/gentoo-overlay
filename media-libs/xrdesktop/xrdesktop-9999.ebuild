# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11,12,13,14} )

inherit meson python-single-r1

DESCRIPTION="A library for XR interaction with traditional desktop compositors."
HOMEPAGE="https://gitlab.freedesktop.org/xrdesktop/xrdesktop"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0/9999"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject[${PYTHON_USEDEP}]
	')
	>=media-libs/g3k-0.16.0
	${PYTHON_DEPS}
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

pkg_setup() {
	python_setup
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}/usr/bin/xrd-settings"
	python_optimize
}
