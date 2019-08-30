# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# WIP
# NOT DONE

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE='threads(+)' # Required by waf
# NB: This package is highly non-compliant to usual waf-isms, thus we don't use
# waf-utils.
inherit distutils-r1 multilib multiprocessing toolchain-funcs unpacker

DESCRIPTION="C++ library for audio and music analysis, description and synthesis"
HOMEPAGE="https://essentia.upf.edu"
# XXX: Remember to verify that the commit hash for the test data URL is still
# the correct one during version bumps.
SRC_URI="https://github.com/MTG/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
test? ( https://github.com/MTG/essentia-audio/archive/beeca09181f6671dc3abe9115289038f097a227d.zip -> audio.zip )
"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples python test static vamp"

BDEPEND="
	doc? (
		app-doc/doxygen
		app-text/pandoc
		dev-python/sphinx
		dev-python/sphinxcontrib-doxylink
		dev-python/sphinxcontrib-pretty-searchresults
	)
"
DEPEND="
	>=media-libs/libsamplerate-0.1.8
	>=sci-libs/fftw-3.3.3:=
	>=media-libs/taglib-1.9.1
	>=dev-libs/libyaml-0.1.5
	>=media-libs/chromaprint-1.4.2:=
"
RDEPEND="${DEPEND}"

WAF="${S}/waf"

waf-run() {
	[ $# -ge 1 ] || die "Insufficient arguments given to waf-run"
	local target="${1}"
	local args="${@:2}"
	local jobs="--jobs=$(makeopts_jobs)"
	local cmd=(
		"${EPYTHON}"
		"${WAF}"
		"${target}"
		"${jobs}"
		--verbose
	)
	[ -z "${args}" ] || cmd+=("${args[*]}")
	echo "${cmd[@]}" >&2
	"${cmd[@]}" || die "Target ${target} failed"
}

src_configure() {
	# We need to move the test data into the expected dir
	if use test; then
		cp -r "${WORKDIR}/essentia-audio-master/." "./test/audio" || die
	fi
	# Waf is a python script, so this is always needed
	python_setup

	# Get tools, libdir, etc
	# ${S}/build is a workaround for tests
	local libdir="${EPREFIX}/usr/$(get_libdir)"
	use test && libdir="${libdir}:${S}/build"

	# Deal with all the build options
	local wafconfargs=(
		--fft=FFTW
		--libdir="${libdir}"
		--mode=release
		--prefix="${EPREFIX}/usr"
	)
	use "test" && wafconfargs+=( --with-cpptests )
	use python && wafconfargs+=( --with-python )
	use static && wafconfargs+=( --build-static )
	use vamp && wafconfargs+=( --with-vamp )

	if use examples; then
		if use static; then
			wafconfargs+=( --with-static-examples )
		else
			wafconfargs+=( --with-examples )
		fi
	fi

	# Run configure commands
	tc-export AR CC CPP CXX RANLIB

	if use python ; then
		cd "${PYTHON_SRC_DIR}" || die
		distutils-r1_src_configure
	fi

	CCFLAGS="${CFLAGS}"
	LINKFLAGS="${CFLAGS} ${LDFLAGS}"
	PKGCONFIG="$(tc-getPKG_CONFIG)"
	waf-run "configure" "${wafconfargs[*]}"
}

src_compile() {
	waf-run "build"

	if use doc ; then
		waf-run 'doc'
	fi
}

src_test() {
	waf-run "run_tests"

	if use python ; then
		waf-run "run_python_tests"
	fi
}

src_install() {
	waf-run "install" "--destdir=\"${D}\""

	if use examples; then
		echo "noop"
	fi

	if use python ; then
		echo "noop"
	fi

	if use doc; then
		echo "noop"
	fi
}
