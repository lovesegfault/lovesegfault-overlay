# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson xdg

DESCRIPTION="Library for video acquisition using Genicam cameras"
HOMEPAGE="https://github.com/AravisProject/aravis"

if [[ ${PV} = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AravisProject/${PN}.git"
else
	MY_P="${PN^^}_${PV//./_}"
	SRC_URI="https://github.com/AravisProject/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# FIXME: As of right now tests are always built, once that chanes a USE flag
# should be added. c.f. https://github.com/AravisProject/aravis/issues/286
IUSE="doc fast-heartbeat gstreamer introspection packet-socket usb X"

GST_DEPEND="
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
"
BDEPEND="
	>=dev-util/meson-0.47.0
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	introspection? ( dev-libs/gobject-introspection )
"
DEPEND="
	>=dev-libs/glib-2.34
	dev-libs/libxml2:=
	sys-libs/zlib:=
	gstreamer? ( ${GST_DEPEND} )
	packet-socket? ( sys-process/audit )
	usb? ( virtual/libusb:1 )
	X? (
		${GST_DEPEND}
		>=x11-libs/gtk+-3.12:3
		x11-libs/libnotify
	)
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_P}"

src_configure() {
	local emesonargs=(
		$(meson_use doc documentation)
		$(meson_use fast-heartbeat)
		$(meson_use gstreamer gst-plugin)
		$(meson_use introspection)
		$(meson_use packet-socket)
		$(meson_use usb)
		$(meson_use X viewer)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	local install_pv="${PV:0:3}"
	local install_p="${PN}-${install_pv}"

	# Properly place icons
	if use X; then
		cp -r "${ED}/usr/share/${install_p}/icons" "${ED}/usr/share" || die "Failed to copy icons"
	fi

	# Symlink versioned binaries to non-versioned
	dosym "arv-tool-${install_pv}" "usr/bin/arv-tool"
	dosym "arv-fake-gv-camera-${install_pv}" "usr/bin/arv-fake-gv-camera"
	use X && dosym "arv-viewer-${install_pv}" "usr/bin/arv-viewer"
}
