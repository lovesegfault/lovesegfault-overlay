# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# WIP
# NOT DONE

EAPI=7

PYTHON_COMPAT=( python3_{5,6} pypy3 )
PYTHON_REQ_USE='threads(+)' # Required by waf
# NB: This package is highly non-compliant to usual waf-isms, thus we don't use
# waf-utils.
inherit distutils-r1 multilib multiprocessing toolchain-funcs unpacker

DESCRIPTION="C++ library for audio and music analysis, description and synthesis"
HOMEPAGE="https://essentia.upf.edu"
# XXX: Remember to verify that the commit hash for the test data URL is still
# the correct one during version bumps.
DATA_HASH="beeca09181f6671dc3abe9115289038f097a227d"
SRC_URI="https://github.com/MTG/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
test? ( https://github.com/MTG/essentia-audio/archive/${DATA_HASH}.zip -> ${PN}-audio-${PV}.zip )
"

PATCHES=(
	"${FILESDIR}/${P}-libdir.patch"
	"${FILESDIR}/${P}-test-lib-path.patch"
)

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples python test static vamp"
REQUIRED_USE="doc? ( examples python vamp )"
RESTRICT="!test? ( test )"
QA_SONAME="/usr/lib64/libessentia.so"

BDEPEND="
	doc? (
		app-doc/doxygen
		app-text/pandoc
		<dev-python/sphinx-2.0.0
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
	# The build target, such as configure, build, test, etc
	local target="${1}"
	# The arguments, such as --destdir, --libdir, --jobs
	local args="${@:2}"
	# Construct command
	# --jobs=$(makeopts_jobs)
	local cmd=(
		"${EPYTHON}"
		"${WAF}"
		"--jobs=24"
		"--verbose"
	)
	# Only append args if any, waf will go nuts if you pass it a ''
	[ -z "${target}" ] || cmd+=(${target[*]})
	[ -z "${args}" ] || cmd+=(${args[*]})
	echo "${cmd[*]}" >&2
	${cmd[*]} || die "Target ${target} failed"
}

src_prepare() {
	default
	local libdir="${EPREFIX}/usr/$(get_libdir)"
	local pkgconfigfile="${WORKDIR}/${P}/essentia.pc.in"
	# We need to fix the pkgconfig file because it is silly and ignores libdir
	sed -i "s/libdir=\${prefix}\/lib/libdir=${libdir}/g" $pkgconfigfile
}

src_configure() {
	# We need to move the test data into the expected dir
	if use test; then
		cp -r "${WORKDIR}/essentia-audio-${DATA_HASH}/." "./test/audio" || die
	fi

	# Waf is a python script, so this is always needed
	python_setup

	# Get tools, libdir, etc
	# FIXME: I copy-pasted this from the waf-utils eclass, do I really need it?
	local libdir="${EPREFIX}/usr/$(get_libdir)"

	# Deal with all the build options
	local wafconfargs=(
		"--fft=FFTW"
		"--libdir=${libdir}"
		"--mode=release"
		"--prefix=${EPREFIX}/usr"
	)
	# FIXME: Do I need to quote test?
	use "test" && wafconfargs+=( "--with-cpptests" )
	use python && wafconfargs+=( "--with-python" )
	use static && wafconfargs+=( "--build-static" )
	use vamp && wafconfargs+=( "--with-vamp" )
	if use examples; then
		if use static; then
			wafconfargs+=( "--with-static-examples" )
		else
			wafconfargs+=( "--with-examples" )
		fi
	fi

	# Run configure commands
	# FIXME: I copy-pasted this from the waf-utils eclass, do I really need it?
	tc-export AR CC CPP CXX RANLIB

	if use python ; then
		cd "${PYTHON_SRC_DIR}" || die
		distutils-r1_src_configure
	fi

	# FIXME: I copy-pasted this from the waf-utils eclass, do I really need it?
	CCFLAGS="${CFLAGS}"
	# FIXME: This is a workaround to the lib being linked with no SONAME, should
	# be removed if/when upstream fixes it.
	# LDFLAGS="${LDFLAGS},-soname,essentia.so.1"
	# FIXME: The workaround above breaks tests, I don't know how to fix it
	LINKFLAGS="${CFLAGS} ${LDFLAGS}"
	PKGCONFIG="$(tc-getPKG_CONFIG)"
	echo "CFLAGS=${CFLAGS}" >&2
	echo "LDFLAGS=${LDFLAGS}" >&2
	echo "LINKFLAGS=${LINKFLAGS}" >&2
	echo "PKGCONFIG=${PKGCONFIG}" >&2
	waf-run configure ${wafconfargs[*]}
}

src_compile() {
	waf-run

	if use doc ; then
		waf-run doc
	fi
}

src_test() {
	waf-run run_tests

	if use python ; then
		waf-run run_python_tests
	fi
}

src_install() {
	waf-run install --destdir="${D}"

	# We need to correct the missing symlink
	dosym "libessentia.so" "./usr/$(get_libdir)/libessentia.so.1"

	if use examples; then
		echo "TODO: src_install_examples"
	fi

	if use python ; then
		echo "TODO: src_install_python"
	fi

	use doc && local HTML_DOCS=( build/doc/doxygen/html/. )
	einstalldocs
}
