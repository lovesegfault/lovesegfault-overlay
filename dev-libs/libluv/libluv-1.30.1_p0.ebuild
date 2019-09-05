# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MIN_VERSION="2.8"
inherit cmake-utils unpacker

MY_PN="${PN/lib/}"
MY_PV="${PV/_p/-}"
MY_P="${MY_PN}-${MY_PV}"

DESCRIPTION="Bare libuv bindings for lua"
HOMEPAGE="https://github.com/luvit/luv"
# XXX: Remember to check this hash between bumps!
# https://github.com/luvit/luv/tree/master/deps
LUA_COMPAT_HASH="daebe77a2f498817713df37f0bb316db1d82222f"
SRC_URI="
	https://github.com/luvit/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/keplerproject/lua-compat-5.3/archive/${LUA_COMPAT_HASH}.zip -> ${PN}-lua-compat-${PV}.zip
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit test"

BDEPEND="
	dev-util/cmake
	virtual/pkgconfig
	test? (
		luajit? ( dev-lang/luajit )
		!luajit? ( dev-lang/lua )
	)
"
DEPEND="dev-libs/libuv"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Fix libdir
	libdir="$(get_libdir)"
	# Match '/lib/' and '/lib"' without capturing / or ", replacing with libdir
	sed -i -r "s/\/lib(\"|\/)/\/${libdir}\1/g" CMakeLists.txt || die "Failed to sed CMakeLists.txt"
	cmake-utils_src_prepare
}

src_configure() {
	lua_compat_dir="${WORKDIR}/lua-compat-5.3-${LUA_COMPAT_HASH}"
	local mycmakeargs=(
		-DBUILD_MODULE=OFF
		-DBUILD_SHARED_LIBS=ON
		-DLUA_BUILD_TYPE=System
		-DLUA_COMPAT53_DIR="${lua_compat_dir}"
		-DWITH_LUA_ENGINE=$(usex luajit LuaJIT Lua)
		-DWITH_SHARED_LIBUV=ON
	)
	cmake-utils_src_configure
}

src_test() {
	ELUA="$(usex luajit luajit lua)"
	# We need to copy the library back so that the tests see it
	cp "${BUILD_DIR}/libluv.so" "./luv.so" || die "Failed to copy library for tests"
	${ELUA} "tests/run.lua" || die "Tests failed"
}
