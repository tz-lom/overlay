# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils qt4-r2 cmake-utils

DESCRIPTION="Records Skype calls to MP3/Ogg/WAV files"
HOMEPAGE="http://atdot.ch/scr/"
SRC_URI="https://github.com/jlherren/skype-call-recorder/archive/${PV}.zip -> ${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-qt/qtgui:4
	media-sound/lame
	media-libs/id3lib
	>=media-libs/libvorbis-1.2.0
	sys-apps/dbus"
RDEPEND="${RDEPEND}
	net-im/skype"
