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

PROG="neo4j"
VER="2.0.0-M04"
VERHUMAN=$VER
SUMMARY="Neo4j is a robust (fully ACID) transactional property graph database."
DESC="Neo4j is a robust (fully ACID) transactional property graph database. Due to its graph data model, Neo4j is highly agile and blazing fast. For connected data operations, Neo4j runs a thousand times faster than relational databases."

PREFIX="/opt/neo4j"
NO_AUTO_DEPENDS=true

case $FLAVOR in 

    # Default - build community edition
    ""|default)
        EDITION=community
    ;;

    # Advanced - build ad 
    advanced)
        EDITION=advanced
    ;;

    enterprise)
        EDITION=enterprise
    ;;
esac
 
PKG="database/neo4j/$EDITION"
BUILDDIR=$PROG-$EDITION-$VER

build() {
    logmsg "Building Neo4j $EDITON edition"
    logmsg "Installing files"
    logmsg "--- Neo4j binaries"
    logcmd mkdir -p $DESTDIR$PREFIX
    logcmd cp -r $TMPDIR/$BUILDDIR/* $DESTDIR$PREFIX

    logmsg "--- Configuration"
    logcmd mkdir -p $DESTDIR/opt/etc
    logcmd mv $DESTDIR$PREFIX/conf $DESTDIR/opt/etc/neo4j
    logcmd ln -s /opt/etc/neo4j $DESTDIR$PREFIX/conf

    logmsg "--- SMF manifest"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/database
    logcmd cp $SRCDIR/files/manifest-neo4j.xml $DESTDIR/lib/svc/manifest/database/neo4j.xml
}

init
download_source $PROG $PROG-$EDITION $VER
prep_build
patch_source
build
VER=${VER//-M0/.0.}
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
