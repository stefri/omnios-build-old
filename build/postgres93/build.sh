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

PROG=postgresql
VER=9.3.5
VERHUMAN=$VER
PKG=database/postgresql-93
SUMMARY="$PROG - Open Source Database System"
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="system/library/gcc-4-runtime"
DEPENDS_IPS="database/postgresql/common system/library/gcc-4-runtime"

PREFIX="/usr/local/postgresql/9.3"
BUILDARCH=64
reset_configure_opts

CFLAGS="-O3"

CONFIGURE_OPTS="--sysconfdir=/etc/postgresql/9.3
    --enable-thread-safety
    --enable-debug
    --with-openssl
    --with-libxml
    --prefix=$PREFIX
    --with-readline"

# We don't want the default settings for CONFIGURE_OPTS_64
CONFIGURE_OPTS_64="--enable-dtrace DTRACEFLAGS=\"-64\""

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/application/database
    logcmd cp $SRCDIR/files/manifest-postgresql-93.xml \
        $DESTDIR/lib/svc/manifest/application/database/postgresql.xml
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp $SRCDIR/files/postgresql_93 \
        $DESTDIR/lib/svc/method/postgresql_93
    logcmd mkdir -p $DESTDIR/var/postgres
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
