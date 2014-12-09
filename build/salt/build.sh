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

PROG=salt
VER=2014.7.0.100
VERHUMAN=$VER
PKG=system/management/salt
SUMMARY="Portable, distributed, remote execution and configuration management system"
DESC="Salt is a new approach to infrastructure management. Easy enough to get running in minutes, scalable enough to manage tens of thousands of servers, and fast enough to communicate with them in seconds."

# uulm.mawi python is 64-bit only
BUILDARCH=64
export CFLAGS="-I$PYTHONPATH/include -I/usr/local/include"
export LDFLAGS="-L$PYTHONLIB -R$PYTHONLIB -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64"
PYTHON=/opt/python27/bin/python
PATH=/usr/local/bin:/opt/python27/bin:$PATH

DEPENDS_IPS="runtime/python-27 service/network/zeromq library/python-27/jinja2 library/python-27/libcloud library/python-27/m2crypto
             library/python-27/markupsafe library/python-27/msgpack library/python-27/pycrypto library/python-27/pyyaml
             library/python-27/requests library/python-27/pyzmq"
BUILD_DEPENDS_IPS="$DEPENDS_IPS library/python-27/setuptools"

INSTALL_OPTIONS="--prefix=$PREFIX \
    --install-lib=$PYTHONLIB/python2.7/site-packages \
    --salt-root-dir=/var/salt \
    --salt-config-dir=/var/salt/etc \
    --salt-cache-dir=/var/salt/cache \
    --salt-sock-dir=/var/salt/run \
    --salt-srv-root-dir=/var/salt/srv \
    --salt-base-file-roots-dir=/var/salt/base \
    --salt-base-pillar-roots-dir=/var/salt/pillars \
    --salt-base-master-roots-dir=/var/salt/master \
    --salt-logs-dir=/var/salt/logs \
    --salt-pidfile-dir=/var/salt/run"

buildpython64() {
    logmsg "Building using python setup.py"
    pushd $TMPDIR/$BUILDDIR > /dev/null

    ISALIST="amd64 i386"
    export ISALIST
    pre_python_64
    logmsg "--- setup.py (64) build"
    logcmd $PYTHON ./setup.py build ||
        logerr "--- build failed"
    logmsg "--- setup.py (64) install"
    logcmd $PYTHON \
        ./setup.py install --root=$DESTDIR $INSTALL_OPTIONS ||
        logerr "--- install failed"
    popd > /dev/null
}

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network/salt
    logcmd cp $SRCDIR/files/salt-master.xml \
        $DESTDIR/lib/svc/manifest/network/salt/master.xml
    logcmd cp $SRCDIR/files/salt-minion.xml \
        $DESTDIR/lib/svc/manifest/network/salt/minion.xml
    logcmd cp $SRCDIR/files/salt-syndic.xml \
        $DESTDIR/lib/svc/manifest/network/salt/syndic.xml
}

runtime_config() {
    logmsg "Creating runtime directories and configuration"
    logmsg "--- Make directories"
    logcmd mkdir -p $DESTDIR/var/salt
    logcmd mkdir $DESTDIR/var/salt/etc
    logcmd mkdir $DESTDIR/var/salt/etc/master.d
    logcmd mkdir $DESTDIR/var/salt/etc/minion.d
    logcmd mkdir $DESTDIR/var/salt/cache
    logcmd mkdir $DESTDIR/var/salt/run
    logcmd mkdir $DESTDIR/var/salt/srv
    logcmd mkdir $DESTDIR/var/salt/base
    logcmd mkdir $DESTDIR/var/salt/pillars
    logcmd mkdir $DESTDIR/var/salt/master
    logcmd mkdir $DESTDIR/var/salt/logs
    logmsg "--- Copy example config"
    logcmd cp $TMPDIR/$BUILDDIR/conf/* $DESTDIR/var/salt/etc
}

add_modules() {
    logmsg "Adding experimental and custom modules"
    logcmd cp $SRCDIR/modules/solarisips.py $TMPDIR/$BUILDDIR/salt/modules/
}

init
download_source $PROG $PROG $VER
patch_source
add_modules
prep_build
python_build
service_configs
runtime_config
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
