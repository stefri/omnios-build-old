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

PROG=cyrus-sasl2
VER=2.1.26
VERHUMAN=$VER
PKG=library/security/cyrus-sasl
SUMMARY="Simple Authentication and Security Layer library"
DESC="$SUMMARY ($VER)"

DEPENDS_IPS="system/library/gcc-4-runtime"

ARCHIVENAME=cyrus-sasl
BUILDDIR=$ARCHIVENAME-$VER

CONFIGURE_OPTS="--prefix=$PREFIX
    --includedir=$PREFIX/include
    --sysconfdir=/etc/sasl2
    --enable-shared=yes
    --enable-static=no
    --enable-sql=no
    --enable-java=no
    --enable-gssapi=no
    --enable-ldapdb=no
    --without-saslauthd
    --without-libdb"
CONFIGURE_OPTS_32="--includedir=$PREFIX/include
    --bindir=$PREFIX/bin/$ISAPART
    --sbindir=$PREFIX/sbin/$ISAPART
    --libdir=$PREFIX/lib
    --libexecdir=$PREFIX/libexec
    --with-plugindir=/usr/local/lib/sasl2
    --with-configdir=/usr/local/lib/sasl2"
CONFIGURE_OPTS_64="--bindir=$PREFIX/bin/$ISAPART64
    --sbindir=$PREFIX/sbin/$ISAPART64
    --libdir=$PREFIX/lib/$ISAPART64
    --libexecdir=$PREFIX/libexec/$ISAPART64
    --with-plugindir=/usr/local/lib/$ISAPART64/sasl2
    --with-configdir=/usr/local/lib/$ISAPART64/sasl2"

make_install64() {
    logmsg "--- Move 32-bit plugin-dir out of the way"
    logcmd mv $DESTDIR/$PREFIX/lib/sasl2 $DESTDIR/$PREFIX/lib/sasl2-32
    make_install
    logmsg "--- Move 64-bit plugin-dir to right place"
    logcmd mkdir -p $DESTDIR/$PREFIX/lib/$ISAPART64
    logcmd mv $DESTDIR/$PREFIX/lib/sasl2 $DESTDIR/$PREFIX/lib/$ISAPART64/sasl2
    logmsg "--- Move 32-bit plugin-dir back into place"
    logcmd mv $DESTDIR/$PREFIX/lib/sasl2-32 $DESTDIR/$PREFIX/lib/sasl2
}

init
download_source $PROG $ARCHIVENAME $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
