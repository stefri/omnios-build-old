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

PROG=openvpn
VER=2.3.4
VERHUMAN=$VER
PKG=service/network/openvpn
SUMMARY="Secure IP tunnel daemon"
DESC="$SUMMARY ($VER)"

DEPENDS_IPS="system/network/tuntap library/lzo"
CONFIGURE_OPTS="--sysconfdir=/etc/openvpn
    --localstatedir=/var/openvpn"

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/manifest-openvpn.xml \
        $DESTDIR/lib/svc/manifest/network/openvpn
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp $SRCDIR/files/openvpn \
        $DESTDIR/lib/svc/method/openvpn
}

copy_samples() {
    logmsg "Copying sample files"
    logcmd mkdir -p $DESTDIR/etc/openvpn
    logcmd cp -R $TMPDIR/$BUILDDIR/samples $DESTDIR/etc/openvpn
    logcmd rm $DESTDIR/etc/openvpn/Makefile*
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
service_configs
copy_samples
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
