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

PROG=gnutls
VER=3.0.32
VERHUMAN=$VER
PKG=library/security/gnutls
SUMMARY="The GnuTLS Transport Layer Security Library"
DESC="$SUMMARY ($VER)"

DEPENDS_IPS="library/security/nettle library/libtasn1 local/library/zlib"

CONFIGURE_OPTS="--disable-static"
CFLAGS="-I/usr/include -I/usr/local/include --std=c99"
CPPFLAGS="-I/usr/include -I/usr/local/include"
LDFLAGS32="-L/usr/lib -R/usr/lib -L/usr/local/lib -R/usr/local/lib"
LDFLAGS64="-L/usr/lib/${ISAPART64} -R/usr/lib/${ISAPART64} -L/usr/local/lib/${ISAPART64} -R/usr/local/lib/${ISAPART64}"

NO_PARALLEL_MAKE="true"

init
download_source $PROG $PROG $VER
patch_source
prep_build
build32

DONT_REMOVE_INSTALL_DIR=true
download_source $PROG $PROG $VER
patch_source
prep_build
build64

make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
