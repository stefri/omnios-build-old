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

PROG=bdb48
VER=4.8.30
VERHUMAN=$VER
PKG=database/bdb48
SUMMARY="$PROG - Berkeley DB: an embedded database library for key/value data"
DESC="$SUMMARY"

PREFIX="/usr/local/db4.8"
BUILDDIR=db-$VER/build_unix
CONFIGURE_CMD="../dist/configure"
CONFIGURE_OPTS="--enable-compat185
    --prefix=$PREFIX
    --bindir=$PREFIX/bin
    --libdir=$PREFIX/lib
    --includedir=$PREFIX/include"
LDFLAGS32="$LDFLAGS32 -L/usr/local/lib -R/usr/local/lib"
LDFLAGS64="$LDFLAGS64 -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64"

export EXTLIBS=-lm

save_function build64 build64_orig
build64() {
  export DLDFLAGS="-L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64"
  build64_orig
}

init
download_source bdb db $VER
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
