# $NetBSD

LIB=		fetch
SRCS=		fetch.c common.c ftp.c http.c file.c
DPSRCS= 	ftperr.h httperr.h
INCS=		fetch.h
MAN=		fetch.3
CLEANFILES=	ftperr.h httperr.h
MKLINT=		no
MKPIC=		no
MKPROFILE=	no

.include <bsd.own.mk>

CPPFLAGS+=	-I.
CPPFLAGS+=	-D_LARGEFILE_SOURCE -D_LARGE_FILES

FETCH_WITH_INET6?=	no
FETCH_WITH_OPENSSL?=	no

.if !empty(FETCH_WITH_INET6:M[yY][eE][sS])
CPPFLAGS+=	-DINET6
.endif

.if !empty(FETCH_WITH_OPENSSL:M[yY][eE][sS])
CPPFLAGS+=	-DWITH_SSL
LDADD=		-lssl -lcrypto
.endif

CPPFLAGS+=	-DFTP_COMBINE_CWDS

WARNS?=		4

ftperr.h: ${.CURDIR}/ftp.errors ${.CURDIR}/Makefile ${.CURDIR}/errlist.sh
	${.CURDIR}/errlist.sh ftp_errlist FTP \
	    ${.CURDIR}/ftp.errors > ${.TARGET}

httperr.h: ${.CURDIR}/http.errors ${.CURDIR}/Makefile ${.CURDIR}/errlist.sh
	${.CURDIR}/errlist.sh http_errlist HTTP \
	    ${.CURDIR}/http.errors > ${.TARGET}

.include <bsd.lib.mk>
