# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
inherit distutils-r1

DESCRIPTION="Confuse is a configuration library for Python that uses YAML"
HOMEPAGE="https://github.com/bebraw/pypandoc"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="app-text/pandoc"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-haskell/pandoc-citeproc )
"

python_test() {
	${EPYTHON} tests.py || die "Tests failed"
}
