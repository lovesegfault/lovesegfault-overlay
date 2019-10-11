# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Very fast, header only, C++ logging library"
HOMEPAGE="https://github.com/gabime/spdlog"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gabime/spdlog"
else
	SRC_URI="https://github.com/gabime/spdlog/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0/1"
IUSE="test static-libs"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/libfmt-5.0.0
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		-Dexternal_fmt=true
		-Dlibrary_type=$(usex static-libs static shared)
		$(meson_use test enable_tests)
	)

	meson_src_configure
}
