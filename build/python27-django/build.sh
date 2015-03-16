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

PROG=django
VER=1.5.12
VERHUMAN=$VER
PKG=library/python-27/django
SUMMARY="The web framework for perfectionists with deadlines"
DESC="Django is a high-level Python Web framework that encourages rapid development and clean, pragmatic design. Built by experienced developers, it takes care of much of the hassle of Web development, so you can focus on writing your app without needing to reinvent the wheel."

# uulm.mawi python is 64-bit only
BUILDARCH=64
LDFLAGS64="-L$PYTHONLIB -R$PYTHONLIB -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64"
PYTHON=/opt/python27/bin/python
PATH=/usr/local/bin:/opt/python27/bin:$PATH

DEPENDS_IPS="runtime/python-27"
BUILD_DEPENDS_IPS="library/python-27/setuptools"

init
download_source python-$PROG $PROG $VER
patch_source
prep_build
python_build
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
