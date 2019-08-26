# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
inherit distutils-r1

DESCRIPTION="Confuse is a configuration library for Python that uses YAML"
HOMEPAGE="https://github.com/beetbox/confuse"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"
BDEPEND="
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]
"

python_compile_all() {
	use doc && emake -j1 -C docs html
	default
}

python_install_all() {
	distutils-r1_python_install_all
	if use doc; then
		rm -r docs/_build/html/_sources || die
		local HTML_DOCS=( docs/_build/html/. )
	fi
	einstalldocs
}
