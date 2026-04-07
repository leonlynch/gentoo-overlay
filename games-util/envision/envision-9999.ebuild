# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.85.0"

inherit cargo git-r3 meson xdg

DESCRIPTION="Orchestrator for the free XR stack"
HOMEPAGE="https://gitlab.com/gabmus/envision/"
EGIT_REPO_URI="https://gitlab.com/gabmus/envision.git"

LICENSE="AGPL-3+"
# Crate licenses (non-exhaustive)
LICENSE+=" Apache-2.0 BSD MIT MPL-2.0 Unicode-3.0 ZLIB"
SLOT="0"
KEYWORDS=""

RESTRICT="mirror"
PROPERTIES="live"

# Compile-time deps for building the Envision binary (Meson/Cargo)
DEPEND="
	dev-libs/libusb:1
	>=gui-libs/gtk-4.10.0:4
	>=gui-libs/libadwaita-1.5.0:1
	>=gui-libs/vte-0.72.0:2.91-gtk4
	media-libs/openxr-loader
"

# Deps above plus everything Envision needs at runtime to build and run
# the WMR XR stack (Reverb G2 profile uses Monado + Basalt + Mercury).
RDEPEND="
	${DEPEND}
	app-arch/bzip2
	app-arch/lz4
	app-misc/jq
	dev-build/cmake
	dev-build/ninja
	dev-cpp/eigen
	dev-cpp/gtest
	dev-cpp/tbb
	dev-lang/python
	dev-libs/boost
	dev-libs/libbsd
	dev-libs/libfmt
	dev-libs/wayland
	dev-libs/wayland-protocols
	dev-util/glslang
	dev-util/vulkan-headers
	dev-vcs/git
	dev-vcs/git-lfs
	games-util/xr-hardware
	llvm-runtimes/clang-runtime
	media-libs/glew
	media-libs/libepoxy
	media-libs/libsdl2
	media-libs/mesa
	media-libs/opencv
	media-libs/shaderc
	media-libs/vulkan-loader
	sys-auth/polkit
	sys-devel/bc
	virtual/libudev
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXrandr
"

BDEPEND="
	dev-build/meson
	dev-build/ninja
"

QA_FLAGS_IGNORED="usr/bin/envision"

pkg_setup() {
	rust_pkg_setup
}

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_configure() {
	local emesonargs=(
		-Dprofile=release
	)
	meson_src_configure
	ln -s "${ECARGO_HOME}" "${BUILD_DIR}/cargo-home" || die
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
