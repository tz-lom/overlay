# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="bam - A fast and flexible build system"
HOMEPAGE="http://www.teeworlds.com/bam"
SRC_URI="http://www.teeworlds.com/files/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.5.0"
RDEPEND="${DEPEND}"

src_compile() {
	./make_unix.sh || die "Make failed"
}

src_install() {
	dobin src/${PN} || die "Installation failed"
	dodoc docs/*.txt
}