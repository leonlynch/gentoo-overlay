# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info meson systemd

DESCRIPTION="Userspace system daemon to enable security levels for Thunderbolt 3"
HOMEPAGE="https://gitlab.freedesktop.org/bolt/bolt"
SRC_URI="https://gitlab.freedesktop.org/${PN}/${PN}/-/archive/${PV}/${P}.tar.gz
	https://gitlab.freedesktop.org/bolt/bolt/merge_requests/210.patch -> ${PN}-210.patch"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc systemd"

DEPEND="
	>=dev-libs/glib-2.50.0:2
	dev-util/glib-utils
	virtual/libudev
	virtual/udev
	sys-auth/polkit[introspection]
	systemd? ( sys-apps/systemd )
	doc? ( app-text/asciidoc )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${DISTDIR}/${PN}-210.patch"
)

pkg_pretend() {
	CONFIG_CHECK="THUNDERBOLT"
	ERROR_THUNDERBOLT="This package requires the thunderbolt kernel driver, so please enable it."
	check_extra_config

	CONFIG_CHECK="HOTPLUG_PCI"
	ERROR_HOTPLUG_PCI="Thunderbolt requires PCI hotplug support, so please enable it."
	check_extra_config
}

src_configure() {
	local emesonargs=(
		-Dman=$(usex doc true false)
		--sysconfdir=/etc
		--localstatedir=/var
		--sharedstatedir=/var/lib
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	cp "${FILESDIR}"/${PN}-init.d "${T}"/boltd
	doinitd "${T}"/boltd

	keepdir /var/lib/boltd
}
