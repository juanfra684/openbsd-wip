# $OpenBSD$

COMMENT =		equinox desktop library

DISTNAME =		edelib-${V}

API_VER =		0.0
.for l in edelib edelib_dbus edelib_gui
SHARED_LIBS +=		$l	${API_VER}
.endfor

WANTLIB += X11 Xau Xdmcp Xext Xft Xinerama c dbus-1 fltk fltk_images
WANTLIB += fontconfig jpeg m png pthread stdc++ z

BUILD_DEPENDS =		devel/jam \
			devel/doxygen,-main
LIB_DEPENDS =		x11/fltk \
			x11/dbus

MAKE_ENV =		EDE_VERSION="${FULL_V}"

CONFIGURE_STYLE =	gnu
CONFIGURE_ARGS +=	${CONFIGURE_SHARED}
CONFIGURE_ENV =		API_VER="${API_VER}"

NO_REGRESS =		Yes

do-build:
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} jam -d x

do-install:
	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ${ALL_FAKE_FLAGS} \
		DESTDIR=${WRKINST} jam -d x install

.include <bsd.port.mk>
