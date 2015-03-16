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

PROG=mosh
VER=1.2.4
VERHUMAN=$VER
PKG=shell/mosh
SUMMARY="Mosh: the mobile shell"
DESC="Remote terminal application that allows roaming, supports intermittent connectivity, and provides intelligent local echo and line editing of user keystrokes. Mosh is a replacement for SSH. It's more robust and responsive, especially over Wi-Fi, cellular, and long-distance links."

DEPENDS_IPS="library/protobuf"

BUILDARCH=32
export PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/local/lib/pkgconfig"
#export PKG_CONFIG_PATH32="/usr/lib/pkgconfig:/usr/local/lib/pkgconfig"
#export PKG_CONFIG_PATH="/usr/lib/${ISAPART64}/pkgconfig:/usr/local/lib/${ISAPART64}/pkgconfig"
#export PKG_CONFIG_PATH64="/usr/lib/${ISAPART64}/pkgconfig:/usr/local/lib/${ISAPART64}/pkgconfig"

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
