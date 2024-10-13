# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Orchestrator for the free XR stack"
HOMEPAGE="https://gitlab.com/gabmus/envision/"
#SRC_URI="" # TODO: remove?

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="X"

BDEPEND="
	dev-build/meson
	dev-build/ninja
"

DEPEND="
	games-util/xr-hardware
	media-libs/vulkan-loader[layers]
	media-libs/openxr-loader
	media-libs/glew
	media-libs/shaderc
	gui-libs/vte
	gui-libs/libadwaita
	dev-cpp/tbb
	<dev-cpp/catch-3
	app-misc/jq
	dev-vcs/git-lfs
	X? ( x11-apps/xrandr )
"
RDEPEND="${DEPEND}"
