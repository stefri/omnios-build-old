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
VER=2.4.39
VERHUMAN=$VER
PKG=database/ldap/openldap
SUMMARY="OpenLDAP - LDAP Server, Tools and Libraries"
DESC="$SUMMARY ($VER)"

BUILDARCH=32
BUILD_DEPENDS_IPS="developer/build/libtool library/libtool/libltdl"
DEPENDS_IPS="system/library/gcc-4-runtime database/bdb library/security/cyrus-sasl service/network/slp"

CONFIGURE_OPTS="--sysconfdir=/etc
    --localstatedir=/var/slapd
    --enable-static=no
    --enable-modules
    --enable-wrappers
    --enable-ipv6=yes
    --enable-crypt=yes
    --enable-spasswd=yes
    --with-tls=openssl
    --with-cyrus-sasl
    --enable-aci
    --enable-bdb
    --enable-hdb
    --enable-rewrite
    --enable-ldap=yes
    --enable-meta=mod
    --enable-monitor=yes
    --enable-slp
    --enable-overlays=mod
    --enable-syncprov=yes
    --enable-ppolicy=yes
    --with-yielding-select"

save_function make_prog make_prog_orig
make_prog(){
    logmsg "--- make depend"
    logcmd $MAKE depend || \
        logerr "--- make depend failed"
    make_prog_orig
}

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network/ldap
    logcmd cp $SRCDIR/files/manifest-slapd.xml \
        $DESTDIR/lib/svc/manifest/network/ldap/slapd.xml
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp $SRCDIR/files/slapd \
        $DESTDIR/lib/svc/method/slapd
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
