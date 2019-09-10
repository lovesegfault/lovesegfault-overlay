# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7} )
inherit distutils-r1 gnome2-utils xdg

DESCRIPTION="Uberwriter is a GTK+ based distraction free Markdown editor"
HOMEPAGE="https://github.com/UberWriter/uberwriter"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/UberWriter/${PN}.git"
else
	SRC_URI="https://github.com/UberWriter/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="latex"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
DEPEND="
	app-text/gspell
	dev-python/pyenchant
	dev-python/regex
	>=dev-python/pypandoc-1.4
	net-libs/webkit-gtk
	x11-libs/gtk+:3
	latex? ( app-text/texlive-core )
"
RDEPEND="${DEPEND}"

pkg_postinst() {
	gnome2_schemas_update
	xdg_pkg_postinst
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_pkg_postrm
}
