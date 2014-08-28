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

PROG=tuntap
VER=1.3.3
VERHUMAN=$VER
PKG=system/network/tuntap
SUMMARY="Virtual Point-to-Point network device"
DESC="tuntap is a TAP driver for Solaris that can be used for OpenVPN, OpenConnect, and vpnc. The code is based on the Universal TUN/TAP driver. Some changes were made and code added for supporting Ethernet tunneling feature, since the Universal TUN/TAP driver for Solaris only supports IP tunneling known as TUN. Note: This release is straight from github https://github.com/kaizawa/tuntap/releases"

CONFIGURE_OPTS_32="--disable-64bit"

TAR=gtar
MAKE_JOBS=""
export PREFIX=$DESTDIR

copy_license() {
    logmsg "Copy license file"
    logcmd cp $SRCDIR/files/LICENSE $TMPDIR/$BUILDDIR
}

init
download_source $PROG $PROG $VER
patch_source
copy_license
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
