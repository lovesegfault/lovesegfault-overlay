# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6} )
PYTHON_REQ_USE="sqlite"
inherit distutils-r1

DESCRIPTION="Media library management system for obsessive-compulsive music geeks"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	absubmit? ( x86? ( ftp://ftp.acousticbrainz.org/pub/acousticbrainz/abzsubmit-0.1-linux-i686.tar.gz ) )
	absubmit? ( amd64? ( ftp://ftp.acousticbrainz.org/pub/acousticbrainz/abzsubmit-0.1-linux-x86_64.tar.gz ) )
"
HOMEPAGE="http://beets.io/ https://pypi.org/project/beets/"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="MIT"
#IUSE="badfiles chromaprint discogs doc ffmpeg gstreamer icu lastfm mpd replaygain test thumbnail webserver"
IUSE="absubmit doc test"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"
RDEPEND="
	>=dev-python/confuse-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/jellyfish-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/mediafile-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/munkres-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/python-musicbrainz-ngs-0.4[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]

	absubmit? (
		dev-python/requests[${PYTHON_USEDEP}]
	)

	test? (
		dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
		dev-python/flask[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pylast[${PYTHON_USEDEP}]
		dev-python/rarfile[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
		dev-python/python-mpd[${PYTHON_USEDEP}]
		dev-python/discogs-client[${PYTHON_USEDEP}]
	)
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

src_prepare() {
	rm_use_plugins() {
		[[ -n "${1}" ]] || die "rm_use_plugins: No use option given"
		local use=${1}
		local plugins=${use}
		use ${use} && return
		einfo "no ${use}:"
		[[ $# -gt 1 ]] && plugins="${@:2}"
		for arg in ${plugins[@]}; do
			einfo "  removing ${arg}"
			if [[ -e "beetsplug/${arg}.py" ]]; then
				rm beetsplug/${arg}.py || die "Unable to remove ${arg} plugin"
			fi
			if [[ -d "beetsplug/${arg}" ]]; then
				rm -r beetsplug/${arg} || die "Unable to remove ${arg} plugin"
			fi
			sed -e "s:'beetsplug.${arg}',::" -i setup.py || \
				die "Unable to disable ${arg} plugin "
		done
	}

	default

	rm_use_plugins chromaprint chroma
	rm_use_plugins ffmpeg convert
	rm_use_plugins icu loadext
	rm_use_plugins lastfm lastgenre lastimport
	rm_use_plugins mpd bpd mpdstats
	rm_use_plugins webserver web
	rm_use_plugins thumbnail thumbnails

	# remove plugins that do not have appropriate dependencies installed
	for flag in badfiles discogs replaygain; do
		rm_use_plugins ${flag}
	done

	if ! use mpd; then
		rm -f test/test_player.py || die
	fi
}

python_compile_all() {
	use doc && emake -j1 -C docs html
}

python_test() {
	cd test || die
	if ! use webserver; then
		rm test_web.py || die "Failed to remove test_web.py"
	fi
	"${PYTHON}" testall.py || die "Testsuite failed"
}

python_install_all() {
	distutils-r1_python_install_all

	doman man/beet.1 man/beetsconfig.5
	use doc && local HTML_DOCS=( docs/_build/html/. )
	einstalldocs
}
