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

PROG=munin      # App name
VER=2.0.21      # App version
PKG=monitoring/munin-node     # Package name (e.g. library/foo)
SUMMARY="Munin is a networked resource monitoring tool."
DESC="Munin is a networked resource monitoring tool that can help analyze resource trends and 'what just happened to kill our performance?' problems. It is designed to be very plug and play. A default installation provides a lot of graphs with almost no work."

DEPENDS_IPS="perl/net-server"
BUILD_DEPENDS_IPS="archiver/gnu-tar"
BUILDARCH=32

TAR=gtar
PATH="$PERLBIN:$PATH"
export PATH

configure32() {
    logmsg "--- skipping configure"
}

MAKE_JOBS="build-common-prime build-node build-plugins"

make_install() {
    export LOGFILE
    export SRCDIR
    export DESTDIR
    logmsg "--- make install"
    logcmd $MAKE install-common-prime \
          install-node-prime  \
          install-plugins-prime || \
            logerr "--- make install failed"
}

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/monitoring
    logcmd cp $SRCDIR/files/manifest-munin-node.xml \
        $DESTDIR/lib/svc/manifest/monitoring/munin-node.xml
}

default_config() {
    logmsg "Copying default configuration files"
    logcmd cp $SRCDIR/files/munin-node.conf $DESTDIR/etc/munin/munin-node.conf
}


init
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
service_configs
default_config
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
