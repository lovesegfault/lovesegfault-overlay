# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION=0.40

inherit xdg-utils meson vala

DESCRIPTION="A simple, focused eBook reader"
HOMEPAGE="https://github.com/babluboy/bookworm"
SRC_URI="https://github.com/babluboy/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

BDEPEND="
	$(vala_depend)
	dev-libs/appstream
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
	virtual/pkgconfig
"
DEPEND="
	app-text/poppler:=[introspection]
	>=dev-db/sqlite-3.5.9:3
	>=dev-libs/granite-0.5.0
	dev-libs/libgee:0.8[introspection]
	dev-libs/libxml2:2
	net-libs/webkit-gtk:4[introspection]
	x11-libs/gtk+:3[introspection]
"
RDEPEND="${DEPEND}"

src_prepare() {
	vala_src_prepare
	eapply_user
}

src_configure() {
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
