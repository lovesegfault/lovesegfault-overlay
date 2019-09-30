# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="My personal meta package for machine configuration."

SLOT="0"
KEYWORDS="~amd64"
IUSE="audio dev latex thinkpad video_cards_nvidia wm"

CORE_DEPEND="
	app-admin/eclean-kernel
	app-admin/gopass
	app-admin/sudo
	app-arch/unrar
	app-arch/unzip
	app-editors/vim[python,terminal,vim-pager]
	app-eselect/eselect-repository
	app-misc/jq
	app-misc/linux-logo
	app-misc/neofetch
	app-misc/ranger
	app-misc/skim
	app-misc/task
	app-misc/tmux
	app-portage/eix
	app-portage/gentoolkit
	app-portage/repoman
	app-portage/smart-live-rebuild
	app-shells/gentoo-zsh-completions
	app-shells/zsh
	app-text/odt2txt
	dev-ruby/gist
	dev-vcs/git
	dev-vcs/git-lfs
	media-libs/exiftool
	media-libs/libcaca
	media-video/ffmpegthumbnailer
	media-video/mediainfo
	net-dns/bind-tools
	net-irc/weechat[man,ruby]
	net-misc/mosh
	net-misc/networkmanager[iwd]
	net-news/newsboat
	net-vpn/wireguard
	sys-apps/bat
	sys-apps/exa
	sys-apps/fwupd[agent,nvme,pkcs7,thunderbolt,uefi]
	sys-apps/ripgrep
	sys-boot/grub:2[mount]
	sys-devel/gcc[lto,pgo]
	sys-fs/fuse
	sys-fs/fuse-exfat
	sys-fs/ntfs3g
	sys-fs/zfs
	sys-fs/zfs-auto-snapshot
	sys-kernel/dracut
	sys-kernel/gentoo-sources[experimental]
	sys-kernel/linux-firmware
	sys-process/htop
	www-client/elinks
	www-client/lynx
"

DEV_DEPEND="
	app-doc/eclass-manpages
	app-editors/neovim
	app-editors/sublime-text
	app-emulation/docker
	app-emulation/lxd[tools]
	app-emulation/lxc
	dev-lang/ghc
	dev-lang/rust[clippy,doc,rls,rustfmt]
	dev-libs/libcgroup
	dev-python/autopep8
	dev-python/bandit
	dev-python/bashate
	dev-python/pipenv
	dev-python/pylama
	dev-python/twine
	dev-python/vulture
	dev-util/beautysh
	dev-util/cppcheck
	dev-util/flawfinder
	dev-util/meld
	dev-util/perf
	dev-util/pkgcheck
	dev-util/shellcheck
	dev-util/strace
	sys-apps/nix
	sys-apps/yarn
	sys-devel/crossdev
	sys-devel/gdb[source-highlight]
"

FONT_DEPEND="
	media-fonts/terminus-font
	wm? (
		media-fonts/fontawesome
		media-fonts/hack
		media-fonts/noto
		media-fonts/noto-cjk
		media-fonts/noto-emoji
		media-fonts/powerline-symbols
	)
"

NV_DEPEND="
	sys-power/bbswitch
	x11-drivers/nvidia-drivers[uvm]
"

THINKPAD_DEPEND="
	app-laptop/tlp[rdw,tlp_suggests]
	app-laptop/tpacpi-bat
	dev-libs/light
	sys-firmware/intel-microcode[hostonly,initramfs]
	sys-auth/pam_u2f
	sys-power/acpi_call
	sys-power/powertop
	x11-misc/colord
	video_cards_nvidia? ( ${NV_DEPEND} )
"

TYPESETTING_DEPEND="
	app-text/texlive[extra,games,graphics,humanities,luatex,pstricks,publishers,science,tex4ht,texi2html,xetex,xml]
	app-text/pandoc
"

AUDIO_DEPEND="
	media-sound/beets[badfiles,chromaprint,discogs,doc,lastfm,mpd,thumbnail]
	media-plugins/gst-plugins-flac
	media-libs/taglib
	media-libs/libsamplerate
	media-libs/chromaprint
	dev-python/numpy
	media-sound/id3v2
	sys-process/parallel
"

WM_DEPEND="
	app-crypt/seahorse
	app-text/evince[djvu,dvi,postscript]
	mail-client/thunderbird
	media-gfx/shotwell
	media-sound/lollypop
	media-sound/pavucontrol
	media-sound/playerctl
	media-sound/spotify[systray]
	media-video/vlc[dav1d,fdk,opus,mp3,vorbis,x265]
	net-im/slack-bin
	www-client/firefox[lto,-system-libvpx,pgo]
	www-client/google-chrome
	x11-misc/libinput-gestures
	x11-terms/alacritty
	x11-terms/kitty
	gui-apps/grim
	gui-apps/mako
	gui-apps/slurp
	gui-apps/waybar[mpd,network,tray]
	gui-apps/wl-clipboard
	gui-wm/sway[tray,wallpapers]
	x11-libs/libnotify
"

BDEPEND=""
DEPEND=""
RDEPEND="
	${CORE_DEPEND}
	${FONT_DEPEND}
	audio? ( ${AUDIO_DEPEND} )
	dev? ( ${DEV_DEPEND} )
	latex? ( ${TYPESETTING_DEPEND} )
	thinkpad? ( ${THINKPAD_DEPEND} )
	wm? ( ${WM_DEPEND} )
"
