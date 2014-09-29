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
VER=4.2.7
VERHUMAN=$VER
PKG=service/network/dhcp/isc-dhcp
SUMMARY="ISC DHCP server"
DESC="$SUMMARY ($VER)"

BUILDDIR=$PROG-$VER
BUILDARCH=32

DEPENDS_IPS="system/library system/library/gcc-4-runtime"

CONFIGURE_OPTS="
    --bindir=$PREFIX/sbin
    --sbindir=$PREFIX/sbin
    --libdir=$PREFIX/lib
    --sysconfdir=/etc/isc-dhcp
    --localstatedir=/var/isc-dhcp
    --mandir=$PREFIX/man
    --docdir=$PREFIX/doc
    --with-srv-lease-file=/var/db/isc-dhcp/dhcpd.leases
    --with-srv6-lease-file=/var/db/isc-dhcp/dhcpd6.leases
    --with-cli-lease-file=/var/db/isc-dhcp/dhclient.leases
    --with-cli6-lease-file=/var/db/isc-dhcp/dhclient6.leases
    --with-ldap=no
    --with-ldapcrypto=no
"

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network/dhcp
    logcmd cp $SRCDIR/files/manifest-isc-dhcp-server.xml \
        $DESTDIR/lib/svc/manifest/network/dhcp/isc-dhcp-server.xml
    logcmd cp $SRCDIR/files/manifest-isc-dhcp-relay.xml \
        $DESTDIR/lib/svc/manifest/network/dhcp/isc-dhcp-relay.xml
    logmsg "Installing SMF control methods"
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logcmd cp $SRCDIR/files/isc-dhcp \
        $DESTDIR/lib/svc/method/isc-dhcp
    logcmd chmod 555 $DESTDIR/lib/svc/method/isc-dhcp
}

rename_config_examples() {
    logmsg "Renaming configuration examples"
    logcmd mv $DESTDIR/etc/isc-dhcp/dhcpd.conf \
        $DESTDIR/etc/isc-dhcp/dhcpd.conf.sample
    logcmd mv $DESTDIR/etc/isc-dhcp/dhclient.conf \
        $DESTDIR/etc/isc-dhcp/dhclient.conf.sample
    logmsg "Creating var-directory"
    logcmd mkdir -p $DESTDIR/var/db/isc-dhcp
}

init
download_source isc-$PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
service_configs
rename_config_examples
VER=${VER//-P/.}
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
