# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6} )

inherit distutils-r1

MY_PN="${PN/sphinxcontrib/sphinx}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Decently styled search results for sphinx-doc projects"
HOMEPAGE="https://github.com/sphinx-contrib/sphinx-pretty-searchresults"
SRC_URI="https://github.com/sphinx-contrib/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/sphinx-testing-0.7[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/recommonmark-0.4.0[${PYTHON_USEDEP}]
	)
"
DEPEND="
	>=dev-python/docutils-0.1[${PYTHON_USEDEP}]
	dev-python/namespace-sphinxcontrib[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.2[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

python_test() {
	cd tests || die
	"${EPYTHON}" run.py || die
}
