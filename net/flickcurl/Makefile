# $OpenBSD: Makefile,v 1.10 2011/06/02 13:41:39 ajacoutot Exp $

COMMENT =		flickr API library and utility

DISTNAME =		flickcurl-1.23
REVISION =		0

SHARED_LIBS +=  	flickcurl   1.0      # .1.0
CATEGORIES =		net

HOMEPAGE =		http://librdf.org/flickcurl/
MAINTAINER =		Edd Barrett <edd@openbsd.org>

# LGPLv2.1/GPLv2/Apachev2.0
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

MODULES =		devel/gettext

WANTLIB =		c crypto curl>=10 idn>=16 m raptor2 ssl \
			xml2>=9 xslt z

MASTER_SITES =		http://download.dajobe.org/flickcurl/

USE_LIBTOOL =		Yes
USE_GROFF =		Yes

LIB_DEPENDS =		net/curl \
			devel/libidn \
			textproc/libxml,-main \
			textproc/raptor>=2

CONFIGURE_STYLE =	gnu
CONFIGURE_ARGS = 	${CONFIGURE_SHARED} --with-raptor=2

.include <bsd.port.mk>
