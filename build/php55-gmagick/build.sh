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

PROG=gmagick
VER=1.1.7RC2
PKG=runtime/php55/php-gmagick
SUMMARY="Provides a wrapper to the GraphicsMagick library."
DESC="$SUMMARY ($VER)"

BUILD_DEPENDS_IPS="library/pkgconf"
DEPENDS_IPS="runtime/php55 application/image/graphicsmagick"

BUILDARCH=64
CONFIGURE_OPTS="--with-gmagick=/usr/local \
    --with-php-config=/usr/local/php55/bin/php-config"
#CPPFLAGS64="$CPPFLAGS64 \
#    -I/usr/local/include/amd64/ImageMagick-6 \
#    -I/usr/local/include/amd64/ImageMagick-6/magick \
#    -I/usr/local/include/amd64/ImageMagick-6/wand"

save_function configure64 configure64.orig
configure64() {
    logmsg "--- phpize the extension"
    logcmd /usr/local/php55/bin/phpize
    configure64.orig
}

make_install() {
    logmsg "--- make install"
    logcmd mkdir -p $DESTDIR/usr/local/php55/lib/modules/ && \
    logcmd cp modules/gmagick.so $DESTDIR/usr/local/php55/lib/modules/ || \
        logerr "--- Make install failed"
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
VER=${VER//RC/.}
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
