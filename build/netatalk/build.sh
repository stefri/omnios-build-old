#!/usr/bin/bash
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2011-2012 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=netatalk
VER=3.1.7
VERHUMAN=$VER
PKG=service/network/netatalk
SUMMARY="Open Source Apple Filing Protocol (AFP) fileserver"
DESC="Netatalk is a freely-available, kernel level implementation of the AppleTalk Protocol Suite, originally for BSD-derived systems. A *NIX/*BSD system running netatalk is capable of serving many macintosh clients simultaneously as an AppleTalk router, AppleShare file server (AFP), *NIX/*BSD print server, and for accessing AppleTalk printers via Printer Access Protocol (PAP). Included are a number of minor printing and debugging utilities."


DEPENDS_IPS="database/bdb library/libevent service/network/dns/mdns
             system/library system/library/gcc-4-runtime system/library/math
             library/security/libgcrypt library/libldap library/security/cyrus-sasl
             library/libmysqlclient18"

export MYSQL_LIBS="-lstdc++"

BUILDARCH=32
CONFIGURE_OPTS="
    --bindir=$PREFIX/bin
    --mandir=$PREFIX/man
    --infodir=$PREFIX/info
    --with-spooldir=/var/spool/netatalk
    --with-uams-path=$PREFIX/lib/netatalk
    --sysconfdir=/etc
    --localstatedir=/var
    --with-bdb=/usr/local/
    --with-libevent-header=/usr/local/include/
    --with-libevent-lib=/usr/local/lib/
    --disable-ddp
    --enable-nfsv4acls
    --enable-krbV-uam
    --with-dtrace
"

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network/
    logcmd cp $SRCDIR/files/manifest-netatalk.xml \
        $DESTDIR/lib/svc/manifest/network/netatalk.xml
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
service_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
