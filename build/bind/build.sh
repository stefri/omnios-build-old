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

PROG=bind
VER=9.10.0-P1
PKG=service/network/dns/bind
SUMMARY="BIND DNS server and tools"
DESC="$SUMMARY ($VER)"

DEPENDS_IPS="library/libxml2 library/security/openssl library/zlib
             system/library system/library/gcc-4-runtime system/library/math"

CONFIGURE_OPTS="
    --bindir=$PREFIX/sbin
    --sbindir=$PREFIX/sbin
    --libdir=$PREFIX/lib/dns
    --sysconfdir=/etc
    --localstatedir=/var
    --with-libtool
    --without-openssl
    --disable-static
"

basic_named_config() {
    logmsg "Installing basic named.conf"
    logcmd mkdir -p $DESTDIR/etc
    logcmd cp $SRCDIR/files/named.conf \
        $DESTDIR/etc/named.conf.sample
    logcmd mkdir -p $DESTDIR/var/named/master
    logcmd mkdir -p $DESTDIR/var/named/rev
    logcmd cp $SRCDIR/files/root.servers \
        $DESTDIR/var/named/root.servers
    logcmd cp $SRCDIR/files/zone.localhost \
        $DESTDIR/var/named/master/zone.localhost
    logcmd cp $SRCDIR/files/127.0.0.rev \
        $DESTDIR/var/named/rev/127.0.0.rev
}

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network/dns
    logcmd cp $SRCDIR/files/manifest-dns-server.xml \
        $DESTDIR/lib/svc/manifest/network/dns/server.xml
    logmsg "Installing SMF control methods"
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp $SRCDIR/files/dns-server \
        $DESTDIR/lib/svc/method/dns-server
    logcmd chmod 555 $DESTDIR/lib/svc/method/dns-server
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
basic_named_config
service_configs
VER=${VER//-P/.}
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
