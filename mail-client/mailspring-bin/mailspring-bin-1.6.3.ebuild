# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg-utils

DESCRIPTION="A beautiful, fast and maintained fork of Nylas Mail"
HOMEPAGE="https://getmailspring.com/"

MY_PN="Mailspring"
MY_P="${MY_PN}-${PV}"

SRC_URI="https://github.com/Foundry376/${MY_PN}/releases/download/${PV}/${MY_P,}-amd64.deb"
KEYWORDS="-* ~amd64"
RESTRICT="bindinst"
LICENSE="GPL-3"
SLOT="0"

QA_PRESTRIPPED="
	usr/share/mailspring/mailspring
	usr/share/mailspring/libEGL.so
	usr/share/mailspring/libffmpeg.so
	usr/share/mailspring/libGLESv2.so
	usr/share/mailspring/resources/app.asar.unpacked/.*
"

BDEPEND=""
DEPEND=""
RDEPEND="
	app-crypt/libsecret
	dev-lang/python:2.7
	dev-libs/libgcrypt
	dev-libs/nss
	dev-vcs/git
	gnome-base/gconf:2
	gnome-base/gvfs
	gnome-base/libgnome-keyring[introspection]
	virtual/libudev
	x11-libs/gtk+:2
	x11-libs/libXtst
	x11-libs/libnotify
	x11-misc/xdg-utils
"

S="${WORKDIR}/usr"

src_install() {
	dodoc "share/doc/mailspring/copyright"
	# Install files
	insinto "/usr/share"
	doins -r "share/mailspring"
	# Install aux files
	doins -r "share/appdata" "share/lintian"
	# Install & Symlink binary
	fperms +x "/usr/share/${MY_PN~}/${MY_PN~}"
	dosym "../share/${MY_PN~}/${MY_PN~}" "/usr/bin/${MY_PN~}"
	fperms +x "/usr/share/${MY_PN~}/resources/app.asar.unpacked/mailsync"
	fperms +x "/usr/share/${MY_PN~}/resources/app.asar.unpacked/mailsync.bin"
	# share/applications share/icons  share/pixmaps
	# Desktop
	domenu "share/applications/${MY_PN~}.desktop"
	# Pixmap
	doicon "share/pixmaps/${MY_PN~}.png"
	# Icons
	doicon -s 16 "share/icons/hicolor/16x16/apps/${MY_PN~}.png"
	doicon -s 32 "share/icons/hicolor/32x32/apps/${MY_PN~}.png"
	doicon -s 64 "share/icons/hicolor/64x64/apps/${MY_PN~}.png"
	doicon -s 128 "share/icons/hicolor/128x128/apps/${MY_PN~}.png"
	doicon -s 256 "share/icons/hicolor/256x256/apps/${MY_PN~}.png"

}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
