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

PROG="in-ulm-munin-plugins"
VER=0.5
VERHUMAN=$VER
PKG="monitoring/munin/in-ulm-plugins"
SUMMARY="Customized and self-developed munin plugins for in-ulm NAS"
DESC="$SUMMARY ($VER)"

copy_plugins() {
    logmsg "Create custom plugin directory"
    logcmd mkdir -p $DESTDIR/usr/local/munin/custom-plugins
    logmsg "Copying all munin-plugins"
    logcmd cp -R $SRCDIR/plugins/* $DESTDIR/usr/local/munin/custom-plugins
}

init
prep_build
copy_plugins
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
