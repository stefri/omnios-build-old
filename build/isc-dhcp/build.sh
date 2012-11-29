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

PROG=dhcp
VER=4.2.4
VERHUMAN=$VER-P2
PKG=service/network/dhcp/isc-dhcp
SUMMARY="ISC DHCP server"
DESC="$SUMMARY ($VERHUMAN)"

MIRROR=ftp.isc.org/isc

DEPENDS_IPS="system/library system/library/gcc-4-runtime"

BUILDARCH=32

CONFIGURE_OPTS="
    --bindir=$PREFIX/sbin
    --sbindir=$PREFIX/sbin
    --libdir=$PREFIX/lib
    --sysconfdir=/etc
    --localstatedir=/var
    --mandir=$PREFIX/man
    --docdir=$PREFIX/doc
    --with-srv-lease-file=/var/db/dhcp/dhcpd.leases
    --with-srv6-lease-file=/var/db/dhcp/dhcpd6.leases
    --with-cli-lease-file=/var/db/dhcp/dhclient.leases
    --with-cli6-lease-file=/var/db/dhcp/dhclient6.leases
    --with-ldap=no
    --with-ldapcrypto=no
"

init
# url ftp://ftp.isc.org/isc/dhcp/4.2.4-P2/dhcp-4.2.4-P2.tar.gz
download_source $PROG/$VER $PROG $VERHUMAN
patch_source
prep_build
build
make_isa_stub
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
