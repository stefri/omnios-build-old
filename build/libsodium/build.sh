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

PROG=libsodium
VER=0.7.0
VERHUMAN=$VER
PKG=library/security/libsodium
SUMMARY="The Sodium crypto library (libsodium)"
DESC="Sodium is a new, easy-to-use software library for encryption, decryption, signatures, password hashing and more.  It is a portable, cross-compilable, installable, packageable fork of NaCl, with a compatible API, and an extended API to improve usability even further.  Its goal is to provide all of the core operations needed to build higher-level cryptographic tools.  Sodium supports a variety of compilers and operating systems, including Windows (with MingW or Visual Studio, x86 and x64), iOS and Android.  The design choices emphasize security, and magic constants have clear rationales.  The same cannot be said of NIST curves, where the specific origins of certain constants are not described by the standards.  And despite the emphasis on higher security, primitives are faster across-the-board than most implementations of the NIST standards." 

CONFIGURE_OPTS="--enable-static=yes --enable-shared=no"

CFLAGS="-std=c99 -I/usr/include"
CPPFLAGS="-Wno-long-long -I/usr/include"
LDFLAGS="-lssp -R/usr/lib -L/usr/lib"

LDRUNPATH=/opt/gcc-4.8.1/lib:/usr/local/lib
export LDRUNPATH

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
