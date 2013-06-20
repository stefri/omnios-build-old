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

PROG=openldap
VER=2.4.35
VERHUMAN=$VER
PKG=library/libldap
SUMMARY="OpenLDAP - Tools and Libraries"
DESC="$SUMMARY ($VER)"

BUILD_DEPENDS_IPS="developer/build/libtool library/libtool/libltdl"
DEPENDS_IPS="system/library/gcc-4-runtime"

CONFIGURE_OPTS="--sysconfdir=/etc
    --disable-slapd
    --disable-bdb
    --disable-hdb
    --disable-mdb
    --disable-monitor
    --disable-relay
    --disable-wrappers
    --disable-syncprov
    --enable-static=no
    --enable-ipv6=yes
    --with-tls=openssl"

save_function make_prog make_prog_orig
make_prog(){
    logmsg "--- make depend"
    logcmd $MAKE depend || \
        logerr "--- make depend failed"
    make_prog_orig
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
