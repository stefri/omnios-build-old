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

PROG=postfix
VER=2.9.4
VERHUMAN=$VER
PKG=service/network/smtp/postfix
SUMMARY="[WIP][UNTESTED] Postfix Mail Transport Agent"
DESC="Postfix is a Mail Transport Agent (MTA), supporting LDAP, SMTP AUTH (SASL), TLS"

BUILDARCH=32
USER=postfix
GROUP=postfix

make_clean() {
    logmsg "--- make (dist)clean"
    logcmd $MAKE tidy || \
        logmsg "--- *** WARNING *** make (dist)clean Failed"
}

CONFIGURE_OPTS_32=""
CONFIGURE_OPTS_64=""
CONFIGURE_OPTS="-DNO_NIS"
CONFIGURE_CMD=create_makefiles

create_makefiles() {
    CCARGS='-DDEF_COMMAND_DIR=\"/usr/local/sbin\" -DDEF_DAEMON_DIR=\"/usr/local/libexec/postfix\"'
    logmsg "--- creating postfix makefiles"
    $MAKE -f Makefile.init makefiles CCARGS=$CCARGS $CONFIGURE_OPTS
    unset CCARGS
}

make_install() {
    logmsg "--- make install"
    $MAKE non-interactive-package \
        install_root=${DESTDIR} \
        config_directory=/etc/postfix \
        daemon_directory=${PREFIX}/libexec/postfix \
        command_directory=${PREFIX}/sbin \
        data_directory=/var/postfix \
        queue_directory=/var/spool/postfix \
        sendmail_path=${PREFIX}/sbin/sendmail \
        mailq_path=${PREFIX}/bin/mailq \
        newaliases_path=${PREFIX}/bin/newaliases \
        html_directory=${PREFIX}/html/postfix \
        manpage_directroy=${PREFIX}/man \
        mail_owner=${USER} \
        setgid_group=${GROUP} || \
            logerr "--- make install failed"
}

service_configs() {
    logmsg "Installing SMF"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/network/smtp
    logcmd cp $SRCDIR/files/manifest-postfix.xml \
        $DESTDIR/lib/svc/manifest/network/smtp/postfix.xml
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
