# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake git-r3

DESCRIPTION="VIO/SLAM tracker for XR devices; Monado fork implementing the VIT interface"
HOMEPAGE="https://gitlab.freedesktop.org/mateosss/basalt"
EGIT_REPO_URI="https://gitlab.freedesktop.org/mateosss/basalt.git"

# Fetch only submodules needed for the shared-library-only build:
#   basalt-headers  – custom Monado fork of the basalt header library
#     └─ Sophus    – C++ Lie-group library (no Gentoo package)
#     └─ cereal    – serialisation library (bundled; avoids patching)
#   CLI11           – CLI parsing (include-dirs hard-coded in CMakeLists)
#   magic_enum      – enum reflection (include-dirs hard-coded in CMakeLists)
# Excluded: Pangolin (visualisation=OFF), opengv/ros/fastcdr (not linked
# when BASALT_BUILD_SHARED_LIBRARY_ONLY=ON).
EGIT_SUBMODULES=(
	thirdparty/basalt-headers
	thirdparty/basalt-headers/thirdparty/Sophus
	thirdparty/basalt-headers/thirdparty/cereal
	thirdparty/CLI11
	thirdparty/magic_enum
)

LICENSE="BSD"
SLOT="0"

# Runtime consumers link against libbasalt.so at a path encoded in the
# VIT_SYSTEM_LIBRARY_PATH environment variable, or the default
# /usr/lib/libbasalt.so.  No KEYWORDS for a live ebuild.

DEPEND="
	dev-cpp/eigen:3
	dev-cpp/tbb:=
	dev-libs/libfmt:=
	media-libs/opencv:=
"
RDEPEND="${DEPEND}"
BDEPEND="dev-build/cmake"

src_configure() {
	local mycmakeargs=(
		# Build only libbasalt.so (the VIT tracker); skip binaries, tests,
		# calibration tools, and the ROS bag reader.
		-DBASALT_BUILD_SHARED_LIBRARY_ONLY=ON
		# Pangolin (GUI) pulls in many display deps; unneeded for headless use
		# by Monado.
		-DBASALT_BUILD_VISUALIZATION=OFF
		# Use Gentoo's dev-cpp/eigen instead of the bundled submodule.
		-DBASALT_BUILTIN_EIGEN=OFF
		-DEIGEN_ROOT="${ESYSROOT}/usr/include/eigen3"
		# rosbag2 would require dev-cpp/yaml-cpp and dev-db/sqlite; skip it.
		-DBASALT_ENABLE_ROSBAG2=OFF
	)
	cmake_src_configure
}
