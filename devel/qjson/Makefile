# $OpenBSD$

COMMENT=	Qt-based library that maps JSON data to QVariant objects
DISTNAME =	qjson-0.7.1
REVISION =	1
CATEGORIES =	devel
SHARED_ONLY =	Yes

SHARED_LIBS =	qjson	0.0

MODULES =	devel/cmake x11/qt4
WANTLIB =	m stdc++

MASTER_SITES =	${MASTER_SITE_SOURCEFORGE:=qjson/}
EXTRACT_SUFX =	.tar.bz2
WRKSRC =	${WRKDIR}/qjson

# LGPLv2
PERMIT_DISTFILES_CDROM =	Yes
PERMIT_DISTFILES_FTP =		Yes
PERMIT_PACKAGE_CDROM =		Yes
PERMIT_PACKAGE_FTP =		Yes

BUILD_DEPENDS =	devel/doxygen
DOCSDIR =	${PREFIX}/share/doc/qjson

# Test list taken from ${WRKSRC}/tests/CMakeLists.txt
CONFIGURE_ARGS =	-DQJSON_BUILD_TESTS:Bool=Yes
UNIT_TESTS =		testparser \
			testqobjecthelper \
			testserializer

post-build:
	cd ${WRKSRC}/doc && doxygen

post-install:
	${INSTALL_DATA_DIR} ${DOCSDIR}
	cd ${WRKSRC}/doc/html && find . -type d -print0 | \
		(cd ${DOCSDIR} && xargs -0 ${INSTALL_DATA_DIR})
	find ${WRKSRC}/doc/html -type f -print0 | \
		(cd ${DOCSDIR} && xargs -0 -J % ${INSTALL_DATA} % ${DOCSDIR})

do-regress:
.for T in ${UNIT_TESTS}
	cd ${WRKBUILD}/tests && ./$T
.endfor

.include <bsd.port.mk>
