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

PROG=setuptools
VER=5.7
VERHUMAN=$VER
PKG=library/python-27/setuptools
SUMMARY="Easily download, build, install, upgrade, and uninstall Python packages"
DESC="Setuptools is a fully-featured, actively-maintained, and stable library designed to facilitate packaging Python projects"

DEPENDS_IPS="runtime/python-27"
BUILD_DEPENDS_IPS="runtime/python-27"

# uulm.mawi python is 64-bit only
BUILDARCH=64
PYTHON=/opt/python27/bin/python

remove_broken_file()
{
  echo "Removing files that break pkgmogrify"
  logcmd rm "${DESTDIR}${PYTHONLIB}/python2.7/site-packages/setuptools/script (dev).tmpl" || printf "FAILED\n\n"

}


init
download_source python-$PROG $PROG $VER
patch_source
prep_build
python_build
remove_broken_file
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
