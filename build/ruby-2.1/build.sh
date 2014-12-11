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
VER=2.1.5
MAIN_VER=2.1
VERHUMAN=$VER
PKG="runtime/ruby-$MAIN_VER"
SUMMARY="A dynamic, open source programming language with a focus on simplicity and productivity. It has an elegant syntax that is natural to read and easy to write."
DESC="$SUMMARY ($VER)"

BUILD_DEPENDS_IPS="runtime/ruby-1.8 custom/library/libffi custom/library/readline developer/build/autoconf"
DEPENDS_IPS="library/yaml"
BASERUBY="$PREFIX/$PROG/1.8/bin/ruby"
PREFIX="$PREFIX/$PROG/$MAIN_VER"

# Ruby doesn't have the concept of library paths,
#   so only one arch can be installed in $PREFIX
# Default to 32-bit
[[ "$BUILDARCH" == "both" ]] && BUILDARCH=32


CONFIGURE_OPTS="--prefix=$PREFIX
    --without-gcc \
    --with-baseruby=$BASERUBY \
    --without-miniruby \
    --enable-shared \
    ac_cv_func_dl_iterate_phdr=no \
    "
CONFIGURE_OPTS_32=

export CFLAGS="-std=c99"
#export CLFAGS="-std=gnu99 -I/usr/local/lib/libffi-3.1/include -I/usr/local/include -I/usr/include/openssl"
#export EXTLIBS=-lm
#export CPPFLAGS="-I/usr/local/lib/libffi-3.1/include -I/usr/local/include -I/usr/include/libelf -I/usr/include"

init
download_source $PROG $PROG $VER
patch_source
prep_build
#run_autoconf
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
