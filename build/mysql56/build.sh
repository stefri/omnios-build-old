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
# Copyright 2013 Steffen Kram. All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=mysql
VER=5.6.14
VERHUMAN=$VER

BUILD_DEPENDS_IPS="developer/build/cmake system/library/g++-4-runtime system/library/gcc-4-runtime"
DEPENDS_IPS="system/library/g++-4-runtime system/library/gcc-4-runtime"
NO_PARALLEL_MAKE=1


FLAVORRUN=$FLAVOR
FLAVOR=
case $FLAVORRUN in
    ""|default|server)
        # Default - build full server, 64-bit only
        PKG=database/mysql-56
        SUMMARY="MySQL Community Edition open source database (server)"
        DESC="$SUMMARY"
        BUILDARCH=64
        PREFIX=/usr/local/mysql/5.6
        LOCAL_MOG_FILE=$SRCDIR/server.mog
        CONFIGURE_OPTS_64=""
    ;;
    client)
        # For use with external programs - dual-arch, lives in /opt/omni
        PKG=database/mysql-client
        SUMMARY="MySQL Community Edition open source database (client and libraries)"
        DESC="$SUMMARY"
        BUILDARCH=64
        PREFIX=/usr/local
        CONFIGURE_OPTS_32="-DINSTALL_BINDIR=bin/$ISAPART
                           -DINSTALL_SBINDIR=sbin/$ISAPART
                           -DINSTALL_INCLUDEDIR=include/mysql"
        CONFIGURE_OPTS_64="-DINSTALL_BINDIR=bin/$ISAPART64
                           -DINSTALL_SBINDIR=sbin/$ISAPART64
                           -DINSTALL_LIBDIR=lib/$ISAPART64
                           -DINSTALL_INCLUDEDIR=include/mysql"
        LOCAL_MOG_FILE=$SRCDIR/client.mog
    ;;
    libs)
        # For use with external programs - dual-arch, lives in /opt/omni
        PKG=library/libmysqlclient18
        SUMMARY="MySQL Community Edition open source database (client and libraries)"
        DESC="$SUMMARY"
        BUILDARCH=64
        PREFIX=/usr/local
        CONFIGURE_OPTS_32="-DWITHOUT_SERVER=1
                           -DINSTALL_BINDIR=bin/$ISAPART
                           -DINSTALL_SBINDIR=sbin/$ISAPART
                           -DINSTALL_INCLUDEDIR=include/mysql"
        CONFIGURE_OPTS_64="-DWITHOUT_SERVER=1
                           -DINSTALL_BINDIR=bin/$ISAPART64
                           -DINSTALL_SBINDIR=sbin/$ISAPART64
                           -DINSTALL_LIBDIR=lib/$ISAPART64
                           -DINSTALL_INCLUDEDIR=include/mysql"
        LOCAL_MOG_FILE=$SRCDIR/libs.mog
    ;;
esac

# Generic options for all flavors
CPPFLAGS="-D__EXTENSIONS__"
CONFIGURE_OPTS="-DCMAKE_INSTALL_PREFIX=$PREFIX
                -DENABLE_DTRACE=1
                -DMYSQL_DATADIR=/var/mysql/5.6/data
                -DMYSQL_SHAREDIR=$PREFIX/share/mysql
                -DMYSQL_UNIX_ADDR=/var/run/mysql56.socket
                -DBUILD_CONFIG=mysql_release
                -DHAVE_FAKE_PAUSE_INSTRUCTION=1
                -DHAVE_PAUSE_INSTRUCTION=0"
CONFIGURE_CMD="/usr/local/bin/cmake .."

save_function configure32 configure32_orig
configure32() {
    logmsg "--- create build directory (32-bit)"
    logcmd mkdir bld32 && cd bld32 && \
    logcmd mkdir -p sql/share || \
        logerr "Failed to create build directory"
    configure32_orig
}

save_function configure64 configure64_orig
configure64() {
    logmsg "--- create build directory (64-bit)"
    logcmd mkdir bld64 && cd bld64 && \
    logcmd mkdir -p sql/share || \
        logerr "Failed to create build directory"
    configure64_orig
}

remove_source() {
    logmsg "--- Patches are present, removing source directory"
    logcmd rm -rf $BUILDDIR || \
        logerr "Failed to remove source directory"
}

make_clean() {
    # Cmake doesn't have a distclean, so we just spike the cache file
    logmsg "--- make clean"
    logcmd $MAKE clean
    logcmd rm CMakeCache.txt
}

# Turn the letter component of the version into a number for IPS versioning
ord26() {
    local ASCII=$(printf '%d' "'$1")
    ASCII=$((ASCII - 64))
    [[ $ASCII -gt 32 ]] && ASCII=$((ASCII - 32))
    echo $ASCII
}

save_function make_package make_package_orig
make_package() {
    if [[ -n "`echo $VER | grep [a-z]`" ]]; then
        NUMVER=${VER::$((${#VER} -1))}
        ALPHAVER=${VER:$((${#VER} -1))}
        VER=${NUMVER}.$(ord26 ${ALPHAVER})
    fi

    make_package_orig
}

prune_for_server() {
    logmsg "Pruning destination directory"
    pushd $DESTDIR$PREFIX > /dev/null
    logcmd rm COPYING INSTALL-BINARY README
    logcmd rm -rf docs mysql-test
    popd > /dev/null
}

prune_for_client() {
    # For libs flavor we just want the bare essentials and this is easier done here than via pkgmogrify
    logmsg "Pruning destination directory"
    pushd $DESTDIR$PREFIX > /dev/null
    logcmd rm COPYING INSTALL-BINARY README
    for file in `cat $SRCDIR/bins_to_prune`; do
        logcmd rm bin/$file bin/$ISAPART/$file bin/$ISAPART64/$file
    done
    logcmd rm -rf data docs lib/plugin man mysql-test sbin scripts sql-bench support-files
    popd > /dev/null
}

prune_for_libs() {
    logmsg "Pruning destination directory"
    pushd $DESTDIR$PREFIX > /dev/null
    logcmd rm COPYING INSTALL-BINARY README
    logcmd rm -rf docs support-files
    popd > /dev/null
}

init
remove_source
download_source $PROG $PROG $VER
patch_source
prep_build
build
make_isa_stub
case $FLAVORRUN in
    ""|default|server)
        prune_for_server
    ;;
    client)
        prune_for_client
    ;;
    libs)
        prune_for_libs
    ;;
esac
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
