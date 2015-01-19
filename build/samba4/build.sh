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

PROG=samba
VER="4.1.16"
VERHUMAN=$VER
PKG=service/network/samba4
SUMMARY="$PROG - CIFS server and active directory controller"
DESC="$SUMMARY ($VERS)"

DEPENDS_IPS="service/network/dns/mdns system/library system/library/gcc-4-runtime system/library/math
             library/libldap library/security/cyrus-sasl runtime/python-27"
# blkid, gnutls, readline, cups, bsd or setproctitle, xsltproc, docbook

BUILDARCH=64
CONFIGURE_OPTS="
    --bindir=$PREFIX/bin
    --sbindir=$PREFIX/sbin
    --mandir=$PREFIX/man
    --infodir=$PREFIX/info
    --sysconfdir=/etc/samba
    --localstatedir=/var/samba
    --sharedstatedir=/var/samba
    --with-configdir=/var/samba/etc
    --with-logfilebase=/var/samba/log
    --with-privatedir=/var/samba/private
    --with-modulesdir=$PREFIX/lib/samba
    --with-statedir=/var/samba/lib
    --with-piddir=/var/samba/run
    --with-cachedir=/var/samba/cache
    --with-sockets-dir=/var/samba/run
    --with-privileged-socket-dir=/var/samba/lib
    --fatal-errors
    --enable-fhs
    --without-systemd
    --with-acl-support
    --with-shared-modules=nfs4_acls,vfs_zfsacl,idmap_ad,idmap_ldap,idmap_rid,idmap_tdb2
"
CFLAGS="$CFLAGS -I/opt/python27/include"
LDFLAGS64="$LDFLAGS64 -L/opt/python27/lib -R/opt/python27/lib"

export PATH="/opt/python27/bin:$PATH"

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network
    logcmd cp $SRCDIR/files/manifest-samba4.xml \
        $DESTDIR/lib/svc/manifest/network/samba4.xml
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
service_configs
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
