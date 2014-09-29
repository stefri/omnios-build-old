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

PROG=GraphicsMagick
VER=1.3.20
VERHUMAN=$VER
PKG=application/image/graphicsmagick
SUMMARY="GraphicsMagick is the swiss army knife of image processing."
DESC="$SUMMARY"

BUILD_DEPENDS_IPS="library/freetype2 library/libjpeg library/libpng library/libtiff"
DEPENDS_IPS="library/freetype2 library/libjpeg library/libpng library/libtiff"

CONFIGURE_OPTS="--enable-shared \
        --disable-openmp"

init
download_source graphicsmagick $PROG $VER
patch_source
prep_build
build
make_isa_stub
PROG=graphicsmagick
VER=${VER//-/.}
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
