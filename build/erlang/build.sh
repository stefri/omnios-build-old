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

PATH=$SRCDIR/bin:$PATH
export PATH

PROG=erlang
VER=17.1
VERHUMAN=$VER
PKG=runtime/erlang
SUMMARY="Erlang OTP Platform -- WIP --"
DESC="$SUMMARY ($OTPVER)"

TAR=gtar
BUILDDIR=otp_src_$VER
ERL_TOP=$TMPDIR/$BUILDDIR
export ERL_TOP
##
BUILDARCH=64
BUILD_DEPENDS_IPS="archiver/gnu-tar developer/java/jdk"
DEPENDS_IPS="library/security/openssl developer/dtrace
    system/library system/library/math"
NO_PARALLEL_MAKE=1

CONFIGURE_OPTS32="--prefix=$PREFIX"
CONFIGURE_OPTS="--sysconfdir=/etc
    --bindir=/usr/local/bin
    --sbindir=/usr/local/sbin
    --enable-smp-support
    --enable-threads
    --enable-dtrace
    --with-ssl=/usr
    --enable-dynamic-ssl-lib
    --enable-m64-build"

init
download_source $PROG otp_src_$VER
patch_source
prep_build
build
make_isa_stub

# Copy in an XML manifest for the Erlang Port Mapper Daemon
logcmd mkdir -p $DESTDIR/lib/svc/manifest/network/
logcmd cp $SRCDIR/files/erlang-empd.xml $DESTDIR/lib/svc/manifest/network/

# Setup working dir for epmd
logcmd mkdir -p $DESTDIR/var/lib/epmd
logcmd chown nobody:nobody $DESTDIR/var/lib/epmd

make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
