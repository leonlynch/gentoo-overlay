# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson

DESCRIPTION="A 3DUI widget toolkit."
HOMEPAGE="https://gitlab.freedesktop.org/xrdesktop/g3k"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.freedesktop.org/xrdesktop/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0/9999"
IUSE="introspection"

DEPEND="
	dev-libs/json-glib
	>=media-libs/gxr-0.16.0
	media-libs/libcanberra
	media-libs/shaderc
	gui-libs/gtk:4
	x11-libs/pango
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

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
