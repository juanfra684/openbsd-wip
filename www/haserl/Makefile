# $OpenBSD: Makefile.template,v 1.54 2008/01/13 16:43:57 espie Exp $

COMMENT=	tiny cgi web script handler using shell or Lua

DISTNAME=	haserl-0.9.29

CATEGORIES=	www

HOMEPAGE=	http://haserl.sourceforge.net/

MAINTAINER=	Stuart Henderson <sthen@openbsd.org>

# GPLv2 only
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM= Yes
PERMIT_DISTFILES_FTP=	Yes

WANTLIB += c

MASTER_SITES= ${MASTER_SITE_SOURCEFORGE:=haserl/}

FLAVORS=	no_lua static
FLAVOR?=

USE_GMAKE=	Yes
CONFIGURE_STYLE= autoconf
AUTOCONF_VERSION= 2.68
CONFIGURE_ARGS+= --enable-bash-extensions \
		LDFLAGS="${LDFLAGS}"
LDFLAGS=	-L${LOCALBASE}/lib

.if !${FLAVOR:Mno_lua}
MODULES+=	lang/lua
CONFIGURE_ARGS+= --with-lua
WANTLIB+=	${MODLUA_WANTLIB} m
LIB_DEPENDS=	${MODLUA_LIB_DEPENDS}
.endif

.if ${FLAVOR:Mstatic}
LDFLAGS+=	-static
.endif

.include <bsd.port.mk>
