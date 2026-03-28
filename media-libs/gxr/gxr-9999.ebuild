# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A glib wrapper for the OpenXR API."
HOMEPAGE="https://gitlab.freedesktop.org/xrdesktop/gxr"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}/-/archive/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0/9999"
IUSE="introspection"

DEPEND="
	dev-libs/glib
	dev-libs/json-glib
	>=media-libs/gulkan-0.16.0
	media-libs/openxr-loader
	introspection? ( dev-libs/gobject-introspection )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use introspection)
		-Dexamples=false
		-Dtests=false
		-Dapi_doc=false
	)
	meson_src_configure
}
