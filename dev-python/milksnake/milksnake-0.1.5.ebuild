# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{5,6,7})
inherit distutils-r1

DESCRIPTION="Confuse is a configuration library for Python that uses YAML"
HOMEPAGE="https://github.com/beetbox/confuse"
SRC_URI="https://github.com/getsentry/${PN}/archive/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-lang/rust
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"
DEPEND="
	>=dev-python/cffi-1.6.0[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

python_test() {
	py.test -v || die "Tests failed"
}
