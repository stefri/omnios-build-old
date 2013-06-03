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

PROG=dovecot-antispam-plugin
VER=0.2.1
VERHUMAN=$VER
COMMIT="5ebc6aae4d7c"
PKG=service/network/imap/dovecot
SUMMARY="Dovecot antispam plugin."
DESC="$SUMMARY ($VER)"

BUILDDIR=$PROG-$COMMIT
BUILDARCH=32
BUILD_DEPENDS_IPS=""
DEPENDS_IPS="system/library/gcc-4-runtime database/bdb library/libpq5
             system/network/imap/dovecot"

CONFIGURE_OPTS="--sysconfdir=/etc
    --localstatedir=/var/$PROG
    --mandir=$PREFIX/man
    --enable-static=no
    --with-nnss
    --with-gssapi=plugin
    --with-ldap=plugin
    --with-sql=plugin
    --with-pgsql
    --with-zlib
    --with-bzlib
    --with-libwrap
    --with-ssl=openssl"

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
