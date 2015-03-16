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

PROG=nettle
VER=2.7
VERHUMAN=$VER
PKG=library/security/nettle
SUMMARY="Nettle - a low-level cryptographic library"
DESC="Nettle is a cryptographic library that is designed to fit easily in more or less any context: In crypto toolkits for object-oriented languages (C++, Python, Pike, ...), in applications like LSH or GNUPG, or even in kernel space."

CONFIGURE_OPTS="--enable-shared --disable-assembler"
CFLAGS="-I/usr/include -I/usr/local/include"
CPPFLAGS="-I/usr/include -I/usr/local/include"
LDFLAGS32="-L/usr/lib -R/usr/lib -L/usr/local/lib -R/usr/local/lib"
LDFLAGS64="-L/usr/lib/${ISAPART64} -R/usr/lib/${ISAPART64} -L/usr/local/lib/${ISAPART64} -R/usr/local/lib/${ISAPART64}"

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
