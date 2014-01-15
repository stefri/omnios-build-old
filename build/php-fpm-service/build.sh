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

PROG=php-fpm-service
VER=1.0
VERHUMAN=$VER
PKG=application/php/fpm-service
SUMMARY="Service-Manifest and startup script for PHP FastCGI Process Manager"
DESC="$SUMMARY ($VER)"

copy_service() {
    logmsg "Create service directories"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/application/php
    logcmd mkdir -p $DESTDIR/lib/svc/method
    logmsg "Copying manifest and service script"
    logcmd cp $SRCDIR/files/manifest-php-fpm.xml $DESTDIR/lib/svc/manifest/application/php/php-fpm.xml
    logcmd cp $SRCDIR/files/php_fpm $DESTDIR/lib/svc/method/php_fpm
}

init
prep_build
copy_service
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
