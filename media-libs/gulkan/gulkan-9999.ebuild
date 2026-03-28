# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A GLib library for Vulkan abstraction."
HOMEPAGE="https://gitlab.freedesktop.org/xrdesktop/gulkan"

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
	>=dev-libs/glib-2.50
	dev-libs/wayland
	dev-libs/wayland-protocols
	media-libs/graphene
	media-libs/vulkan-loader
	x11-libs/cairo
	>=x11-libs/gdk-pixbuf-2.36
	x11-libs/libdrm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/xcb-util-keysyms
	introspection? ( dev-libs/gobject-introspection )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	|| ( media-libs/shaderc dev-util/glslang )
	dev-util/wayland-scanner
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
