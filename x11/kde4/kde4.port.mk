# $OpenBSD$

MODKDE4_VERSION =	4.9.2
MODKDE_VERSION =	${MODKDE4_VERSION}

AKONADI_VERSION =	1.8.0
ATTICA_VERSION =	0.4.0
AUTOMOC_VERSION =	0.9.88
CAGIBI_VERSION =	0.2.0

CALLIGRA_VERSION =	2.5.3
CALLIGRA_BRANCH =	stable

DIGIKAM_VERSION =	2.9.0

KDEVELOP_VERSION =	4.4.0
KDEVPLATFORM_VERSION =	1.4.0

KILE_VERSION =		2.1.3

KTORRENT_VERSION =	4.3.0
LIBKTORRENT_VERSION =	1.3.0

LIBKGAPI_VERSION =	0.4.0
QIMAGEBLITZ_VERSION =	0.0.6
YAKUAKE_VERSION =	2.9.9

# this is outside x11/kde4 but tied into x11/kde4
SOPRANO_VERSION =	2.8.0

# General options set by module
SHARED_ONLY ?=		Yes
ONLY_FOR_ARCHS ?=	${GCC4_ARCHS}
EXTRACT_SUFX ?=		.tar.xz

CATEGORIES +=		x11/kde4
MODULES +=		devel/cmake
SEPARATE_BUILD ?=	flavored

# CONFIGURE_STYLE needs separate handling because it is set to empty
# string in bsd.port.mk initially.
.if "${CONFIGURE_STYLE}" == ""
CONFIGURE_STYLE =	cmake
.endif

# MODKDE4_RESOURCES: Yes/No
#   If enabled, disable default Qt and KDE LIB_DEPENDS and RUN_DEPENDS,
#   and set PKG_ARCH=*. Also, FLAVORS will not be touched. "libs"
#   dependencies in MODKDE4_USE (see below) will become a BUILD_DEPENDS.

MODKDE4_RESOURCES ?=	No

# MODKDE4_USE: [libs | runtime] [PIM]
#   - Set to empty for stuff that is a prerequisite for kde base blocks:
#     kdelibs, kde-runtime, kdepimlibs or kdepim-runtime.
#
#   - Set to "libs" for ports that need only libs, without runtime support.
#     All options below imply "libs". If no from "none", "libs" or
#     "runtime" were specified, "libs" is implied. This is the default
#     value when MODKDE4_RESOURCES is enabled.
#
#   - Set to "runtime" for ports which depend on base KDE libraries and
#     runtime components. This is the default setting until
#     MODKDE4_RESOURCES is enabled.
#
#   - Set to "workspace" for ports that require KDE workspace libraries.
#     This automatically implies "runtime".
#
#   - Add "pim" when port depends on KDE PIM framework.
#
# NOTE: There are no options like "Kate" or "Okular", they should be handled
#       with simple LIB_DEPENDS on corresponding packages in addition to
#       options above.
#

.if ${MODKDE4_RESOURCES:L} == "no"
MODKDE4_USE ?=		runtime
.else
MODKDE4_USE ?=		libs
MODKDE_NO_QT ?=		Yes
.endif

_MODKDE4_USE_ALL =	libs runtime workspace pim
.for _modkde4_u in ${MODKDE4_USE:L}
.   if !${_MODKDE4_USE_ALL:M${_modkde4_u}}
ERRORS += "Fatal: unknown KDE 4 use flag: ${_modkde4_u}"
ERRORS += "Fatal: (not one from ${_MODKDE4_USE_ALL})."
.   endif
.endfor
.if ${MODKDE4_USE:L} == "pim" || ${MODKDE4_USE:Mworkspace}
MODKDE4_USE +=		runtime
.endif

# 1. Force CMake which has merged KDE modules
# 2. Various distfiles contain long paths, necessitating an archiver
# compliant with POSIX.1-2001 extended headers.
MODKDE4_BUILD_DEPENDS =	archivers/gtar \
			STEM->=2.8.8:devel/cmake \
			textproc/docbook \
			textproc/docbook-xsl
MODKDE4_LIB_DEPENDS =	
MODKDE4_RUN_DEPENDS =	
MODKDE4_WANTLIB =
MODKDE4_CONF_ARGS =

TAR =			${LOCALBASE}/bin/gtar

FLAVOR ?=

.ifdef MODKDE_NO_QT
MODKDE4_NO_QT ?=	${MODKDE_NO_QT}
.endif

.if ${MODKDE4_USE:L:Mruntime} || ${MODKDE4_USE:L:Mpim}
MODKDE4_USE +=		libs
.endif

.if ${MODKDE4_RESOURCES:L} != "no"
PKG_ARCH ?=		*
MODKDE4_NO_QT ?=	Yes	# resources usually don't need Qt
.   if ${MODKDE4_USE:L:Mworkspace}
MODKDE4_BUILD_DEPENDS +=	STEM->=${MODKDE4_VERSION}:x11/kde4/workspace
.   endif
.   if ${MODKDE4_USE:L:Mlibs}
MODKDE4_BUILD_DEPENDS +=	STEM->=${MODKDE4_VERSION}:x11/kde4/libs
.   endif
.else
# Small hack, until automoc4 will be gone
PKGNAME ?= ${DISTNAME}
.   if !${PKGNAME:Mautomoc4-*}
MODKDE4_BUILD_DEPENDS +=	x11/kde4/automoc
.   endif

MODKDE4_NO_QT ?=	No
.   if ${MODKDE4_USE:L:Mlibs}
.       if ${MODKDE4_NO_QT:L} == "yes"
ERRORS +=	"Fatal: KDE libraries require Qt."
.       endif

MODKDE4_LIB_DEPENDS +=		STEM->=${MODKDE4_VERSION}:x11/kde4/libs
MODKDE4_WANTLIB +=		kdecore>=8
.       if ${MODKDE4_USE:L:Mpim}
MODKDE4_LIB_DEPENDS +=		STEM->=${MODKDE4_VERSION}:x11/kde4/pimlibs
.       endif

.       if ${MODKDE4_USE:L:Mruntime}
MODKDE4_RUN_DEPENDS +=		STEM->=${MODKDE4_VERSION}:x11/kde4/runtime
.           if ${MODKDE4_USE:L:Mpim}
MODKDE4_RUN_DEPENDS +=		STEM->=${MODKDE4_VERSION}:x11/kde4/pim-runtime
.           endif

.           if ${MODKDE4_USE:L:Mworkspace}
MODKDE4_LIB_DEPENDS +=		STEM->=${MODKDE4_VERSION}:x11/kde4/workspace
.           endif
.       endif
.   endif    # ${MODKDE4_USE:L:Mlibs}

.if ${CONFIGURE_STYLE:Mcmake}
.   if ${FLAVOR:Mdebug}
MODKDE4_CONF_ARGS +=	-DCMAKE_BUILD_TYPE:String=Debug
MODKDE4_CMAKE_PREFIX =	-debug
.   else
MODKDE4_CONF_ARGS +=	-DCMAKE_BUILD_TYPE:String=Release
MODKDE4_CMAKE_PREFIX =	-release
.   endif

# Use right directories
CONFIGURE_ARGS +=	-DMAN_INSTALL_DIR=${PREFIX}/man \
			-DINFO_INSTALL_DIR=${PREFIX}/info \
			-DLIBEXEC_INSTALL_DIR=${PREFIX}/libexec

# NOTE: due to bugs in make-plist, plist may contain
# ${FLAVORS} instead of ${MODKDE4_CMAKE_PREFIX}.
# You've been warned.
SUBST_VARS +=		MODKDE4_CMAKE_PREFIX

FLAVORS +=	debug
.endif

# ${MODKDE4_RESOURCES:L} != "no"
.endif

.if ${CONFIGURE_STYLE:Mcmake}
. if "${NO_REGRESS:L}" != "yes"
# Enable regression tests if any
MODKDE4_CONF_ARGS +=	-DKDE4_BUILD_TESTS:Bool=Yes
. endif

# Set up directories
MODKDE4_CONF_ARGS +=	-DKDE4_INCLUDE_INSTALL_DIR:String=${PREFIX}/include \
			-DKDE4_INSTALL_DIR:String=${PREFIX} \
			-DKDE4_LIB_INSTALL_DIR:String=${PREFIX}/lib \
			-DKDE4_LIBEXEC_INSTALL_DIR:String=${PREFIX}/libexec \
			-DKDE4_INFO_INSTALL_DIR:String=${PREFIX}/info \
			-DKDE4_MAN_INSTALL_DIR:String=${PREFIX}/man \
			-DKDE4_SYSCONF_INSTALL_DIR:String=${SYSCONFDIR}
.endif

# FIXME
MODKDE4_CONFIGURE_ENV =	HOME=${WRKDIR}
PORTHOME ?=		${WRKDIR}

MODKDE4_NO_QT ?=	No
MODKDE_NO_QT ?=		${MODKDE4_NO_QT}
.if ${MODKDE4_NO_QT:L} == "no"
MODULES +=			x11/qt4
MODQT4_OVERRIDE_UIC ?=		No
MODKDE4_CONFIGURE_ENV +=	QTDIR=${MODQT_LIBDIR}
.endif

MODKDE_BUILD_DEPENDS =	${MODKDE4_BUILD_DEPENDS}
MODKDE_LIB_DEPENDS =	${MODKDE4_LIB_DEPENDS}
MODKDE_RUN_DEPENDS =	${MODKDE4_RUN_DEPENDS}
MODKDE_WANTLIB =	${MODKDE4_WANTLIB}
MODKDE_CONFIGURE_ENV =	${MODKDE4_CONFIGURE_ENV}

BUILD_DEPENDS +=	${MODKDE_BUILD_DEPENDS}

LIB_DEPENDS +=		${MODKDE_LIB_DEPENDS}

RUN_DEPENDS +=		${MODKDE_RUN_DEPENDS}
WANTLIB +=		${MODKDE_WANTLIB}
CONFIGURE_ENV +=	${MODKDE_CONFIGURE_ENV}
CONFIGURE_ARGS +=	${MODKDE4_CONF_ARGS}
# MAKE_FLAGS +=		${MODKDE4_CONF_ARGS}

# System (CMake) FindGettext.cmake requires having PO_FILES marker
MODKDE4_post-patch =	@echo '====> Fixing GETTEXT_PROCESS_PO_FILES() calls'; \
	cd ${WRKSRC} && find . -name CMakeLists.txt | sort | \
		while read F; do \
			perl -pi.pofilesfix -e '\
			if (/GETTEXT_PROCESS_PO_FILES/ and !/\sPO_FILES/) { \
				s@\$$\{_po_files\}@PO_FILES $$&@; \
			}' "$$F"; \
			if cmp -s "$$F" "$$F".pofilesfix; then \
				rm "$$F".pofilesfix; \
			else \
				echo "$$F" >&2; \
			fi; \
		done
