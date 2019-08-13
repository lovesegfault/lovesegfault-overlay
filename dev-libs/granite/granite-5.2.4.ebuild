# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_MIN_API_VERSION=0.40

inherit xdg-utils meson vala

DESCRIPTION="Elementary OS library that extends GTK+"
HOMEPAGE="https://github.com/elementary/granite"
SRC_URI="https://github.com/elementary/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc test"

BDEPEND="
	$(vala_depend)
	>=dev-util/meson-0.48.2
	virtual/pkgconfig
"
DEPEND="
	>=dev-libs/glib-2.50:2
	dev-libs/libgee:0.8[introspection]
	>=x11-libs/gtk+-3.22:3[introspection]
"
RDEPEND="${DEPEND}"

#S="${WORKDIR}"/"${PN}"-"$(ver_cut 1-2)"

src_prepare() {
	vala_src_prepare
	eapply_user
}

src_configure() {
	local emesonargs=(
		$(meson_use doc documentation)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
