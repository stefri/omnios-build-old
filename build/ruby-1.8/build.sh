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

PROG=ruby
PATCH_LEVEL=374
VER=1.8.7.374
VERHUMAN=1.8.7
MAIN_VER=1.8
PKG="runtime/ruby-$MAIN_VER"
SUMMARY="A dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write."
DESC="$SUMMARY ($VER)"

PREFIX="$PREFIX/$PROG/$MAIN_VER"

# Ruby doesn't have the concept of library paths,
#   so only one arch can be installed in $PREFIX
# Default to 32-bit
[[ "$BUILDARCH" == "both" ]] && BUILDARCH=32


CONFIGURE_OPTS="--prefix=$PREFIX
    --without-gcc \
    --with-baseruby=$PREFIX/bin/ruby \
    --enable-shared \
    ac_cv_func_dl_iterate_phdr=no \
    "
CONFIGURE_OPTS_32=

BUILDDIR=$PROG-$VERHUMAN-p$PATCH_LEVEL

init
download_source $PROG $PROG $VERHUMAN-p$PATCH_LEVEL
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
