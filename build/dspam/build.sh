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

PROG=dspam
VER=3.10.2
VERHUMAN=$VER
PKG=service/network/dspam
SUMMARY="DSPAM Statistical anti-spam filter"
DESC="$SUMMARY ($VER)"

BUILDARCH=32
BUILD_DEPENDS_IPS=""
DEPENDS_IPS="system/library/gcc-4-runtime database/bdb library/libpq5"

CONFIGURE_OPTS="--sysconfdir=/etc/dspam
    --localstatedir=/var/$PROG
    --mandir=$PREFIX/man
    --enable-daemon
    --enable-split-configuration
    --enable-external-lookup
    --enable-clamav
    --enable-syslog
    --enable-preferences-extension
    --enable-long-usernames
    --enable-virtual-users
    --with-dspam-home=/var/spool/$PROG
    --with-dspam-home-owner=dspam
    --with-dspam-home-group=dspam
    --with-logdir=/var/log/$PROG
    --with-storage-driver=hash_drv,pgsql_drv"

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/manifest-dspam.xml \
        $DESTDIR/lib/svc/manifest/network/dspam.xml
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
