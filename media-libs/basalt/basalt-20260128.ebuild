# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="VIO/SLAM tracker for XR devices; Monado fork implementing the VIT interface"
HOMEPAGE="https://gitlab.freedesktop.org/mateosss/basalt"
EGIT_REPO_URI="https://gitlab.freedesktop.org/mateosss/basalt.git"
EGIT_COMMIT="release-e4e81cb3"

# Sophus has no Gentoo package. CLI11 and magic_enum include-dirs are
# hard-coded in CMakeLists, so system packages cannot be used without patching.
# Excluded: ros/fastcdr (not linked when BASALT_BUILD_SHARED_LIBRARY_ONLY=ON).
EGIT_SUBMODULES=(
	thirdparty/basalt-headers
	thirdparty/basalt-headers/thirdparty/Sophus
	thirdparty/basalt-headers/thirdparty/cereal
	thirdparty/CLI11
	thirdparty/magic_enum
	thirdparty/opengv
	thirdparty/Pangolin
)

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

# Monado loads libbasalt.so via VIT_SYSTEM_LIBRARY_PATH or /usr/lib/libbasalt.so.

DEPEND="
	dev-cpp/eigen:3
	dev-cpp/tbb:=
	dev-libs/libfmt:=
	media-libs/libepoxy:=
	media-libs/opencv:=
	virtual/opengl
	x11-libs/libX11
"
RDEPEND="
	dev-cpp/tbb:=
	dev-libs/libfmt:=
	media-libs/libepoxy:=
	media-libs/opencv:=
	virtual/opengl
	x11-libs/libX11
"

PATCHES=( "${FILESDIR}/${P}-gentoo-build-fixes.patch" )

src_prepare() {
	# cmake_modules/FindEigen3.cmake reads Eigen/Version which does not exist in
	# Gentoo's dev-cpp/eigen; the patch drops MODULE from find_package(Eigen3)
	# and this rm together switch cmake to config-mode (Eigen3Config.cmake).
	rm cmake_modules/FindEigen3.cmake || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBASALT_BUILD_SHARED_LIBRARY_ONLY=ON
		-DBASALT_BUILTIN_EIGEN=OFF
		-DEIGEN_ROOT="${ESYSROOT}/usr/include/eigen3"
	)
	cmake_src_configure
}
