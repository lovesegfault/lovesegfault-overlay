# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN="github.com/erroneousboat/slack-term"

inherit golang-build

DESCRIPTION="Slack client for your terminal"
HOMEPAGE="https://github.com/erroneousboat/slack-term"
if [[ ${PV} == 9999 ]]; then
	inherit golang-vcs
	EGIT_REPO_URI="https://${EGO_PN}.git"
else
	inherit golang-vcs-snapshot
	SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=""
RDEPEND=""
BDEPEND=">=dev-lang/go-1.12"
