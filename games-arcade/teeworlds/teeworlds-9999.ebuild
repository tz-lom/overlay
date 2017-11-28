# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs eutils games fdo-mime subversion

DESCRIPTION="A retro multiplayer shooter"
HOMEPAGE="http://www.teeworlds.com"
ESVN_REPO_URI="http://tdtw.googlecode.com/svn/trunk/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="debug dedicated"

RDEPEND="!dedicated? (
		media-libs/alsa-lib
		media-sound/wavpack
		media-libs/libpnglite
		sys-libs/zlib
		x11-libs/libX11
		x11-libs/libXrandr
		virtual/opengl
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/system-libs.patch
	epatch "${FILESDIR}"/new-wavpack.patch

	sed -i -e "s:audio/:${GAMES_DATADIR}/${PN}/data/audio/:g" datasrc/content.py || die "sed failed"
	sed -i -e "s:/usr/share/${PN}:${GAMES_DATADIR}/${PN}:g" src/engine/e_engine.c || die "sed failed"
	sed -i -e "s:mapres/:${GAMES_DATADIR}/${PN}/data/mapres/:g" $(grep -Rl '"mapres\/' *) || die "sed failed"
	sed -i -e "s:\"maps/:\"${GAMES_DATADIR}/${PN}/data/maps/:g" $(grep -Rl '"maps\/' *) || die "sed failed"
	sed -i -e "s:skins/:${GAMES_DATADIR}/${PN}/data/skins/:g" $(grep -Rl '"skins\/' *) || die "sed failed"
	sed -i -e "s:editor/:${GAMES_DATADIR}/${PN}/data/editor/:g" $(grep -Rl '"editor\/' *) || die "sed failed"
	sed -i -e "s:fonts/:${GAMES_DATADIR}/${PN}/data/fonts/:g" $(grep -Rl '"fonts\/' *) || die "sed failed"
	sed -i -e "s:[a-z_]*\.png:${GAMES_DATADIR}/${PN}/data\/&:ig" datasrc/content.py || die "sed failed"
	sed -i -e "s:[a-z_]*\.png:${GAMES_DATADIR}/${PN}/data\/&:ig" scripts/png.py || die "sed failed"
	sed -i -e "s:[a-z_]*\.png:${GAMES_DATADIR}/${PN}/data\/&:ig" src/engine/client/ec_client.c || die "sed failed"
	sed -i -e "s:[a-z_]*\.png:${GAMES_DATADIR}/${PN}/data\/&:ig" src/game/client/components/menus.cpp || die "sed failed"
	sed -i -e "s:x_ninja:${GAMES_DATADIR}/${PN}/data\/&:ig" src/game/client/components/players.cpp || die "sed failed"
	sed -i -e "s:\"skins\"\,:\"${GAMES_DATADIR}/${PN}/data\/skins\"\,:i" src/game/client/components/skins.cpp || die "sed failed"
}

src_compile() {
	sed -i \
		-e "s|cc.flags = \"-Wall -pedantic-errors\"|cc.flags = \"${CXXFLAGS}\"|" \
		-e "s|linker.flags = \"\"|linker.flags = \"${LDFLAGS}\"|" \
		-e "s|-Wall -fstack-protector -fstack-protector-all -fno-exceptions|${CXXFLAGS}|" \
		default.bam|| die "sed failed"

	if use dedicated ; then
		bam -v server_release || die "bam failed"
	else
		bam -v release || die "bam failed"
	fi
}

src_install() {
	dogamesbin ${PN}_srv || die "dogamesbin failed"
	insinto "${GAMES_DATADIR}"/${PN}/data/maps
	doins data/maps/* || die "doins failed"

	if ! use dedicated ; then
		dogamesbin ${PN} || die "dogamesbin failed"
		insinto "${GAMES_DATADIR}"/${PN}
		doins -r data || die "doins failed"
		doicon "${FILESDIR}"/"${PN}".svg
		make_desktop_entry ${PN} "Teeworlds" "/usr/share/pixmaps/${PN}.svg"
	fi

	dodoc *.txt

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	fdo-mime_desktop_database_update
	elog "For more information about server setup read:"
	elog "http://www.teeworlds.com/?page=docs"
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}