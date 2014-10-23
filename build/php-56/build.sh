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

PROG=php
VER=5.6.2
PKG=runtime/php56
SUMMARY="PHP Server 5.6"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."

BUILD_DEPENDS_IPS="compress/bzip2
    mawi/database/sqlite
    database/bdb
    library/libtool/libltdl
    library/libxml2
    library/libxslt
    system/library/iconv/unicode
    system/library/iconv/utf-8
    system/library/iconv/utf-8/manual
    system/library/iconv/xsh4/latin
    local/web/curl
    local/library/zlib
    library/libldap
    library/freetype2
    library/libgd
    library/libjpeg
    library/libmcrypt
    library/libpng
    library/libpq5
    library/libssh2
    library/libtiff
    library/security/cyrus-sasl
    library/mhash
    library/libmysqlclient18"

# Though not strictly needed since we override build(), still nice to set
BUILDARCH=64
PREFIX=$PREFIX/php56
reset_configure_opts

#CFLAGS="-O2 -DZLIB_INTERNAL=1 -std=c99"
CFLAGS="-O2 -DZLIB_INTERNAL=1 -std=gnu99"
CPPFLAGS=""
CPPFLAGS64="-I/usr/local/include/$ISAPART64 -I/usr/local/include/$ISAPART64/curl \
    -I/usr/local/include"
LDFLAGS64="$LDFLAGS64 -L/usr/local/lib/$ISAPART64 -R/usr/local/lib/$ISAPART64 \
    -L$PREFIX/lib -R$PREFIX/lib"


export EXTENSION_DIR=$PREFIX/lib/modules
CONFIGURE_OPTS_32=""
CONFIGURE_OPTS_64=""
CONFIGURE_OPTS="
        --prefix=$PREFIX
        --with-libdir=lib/$ISAPART64
        --sysconfdir=$PREFIX/etc
        --includedir=$PREFIX/include
        --bindir=$PREFIX/bin
        --sbindir=$PREFIX/sbin
        --libdir=$PREFIX/lib
        --libexecdir=$PREFIX/libexec
        --datarootdir=$PREFIX/share
        --mandir=$PREFIX/man
        --with-pear=$PREFIX/pear
        --enable-dtrace
        --enable-cgi
        --enable-fpm
        --enable-zip=shared
        --with-zlib=shared,/usr/local
        --with-zlib-dir=/usr/local
        --with-sqlite3=shared,/usr/local
        --with-db4=/usr/local
        --enable-pdo=shared
        --with-pgsql=shared,/usr/local
        --with-pdo-pgsql=shared,/usr/local
        --with-pdo-sqlite=shared
        --with-mysql=shared,mysqlnd
        --with-mysqli=shared,mysqlnd
        --with-pdo-mysql=shared,mysqlnd
        --enable-mbstring=shared
        --with-mhash=/usr/local
        --with-mcrypt=shared,/usr/local
        --with-gd=shared,/usr/local
        --with-jpeg-dir=/usr/local
        --with-png-dir=/usr/local
        --with-tiff-dir=/usr/local
        --with-freetype-dir=/usr/local
        --with-xpm=no
        --enable-gd-native-ttf
        --enable-exif=shared
        --enable-bcmath=shared
        --enable-calendar=shared
        --enable-ftp=shared
        --enable-mbstring=shared
        --enable-soap=shared
        --with-curl=shared
        --with-openssl
        --with-ldap=shared,/usr/local
        "

# TEST TODO
#        --with-bzip2=shared,/usr/local
#        --with-libxml-dir=/usr/local
#        --with-t1lib-dir=/usr/local # for gd


# DID NOT WORK
#        --with-ldap-sasl=shared,/usr/local -> did not find sasl.h in inc/sasl/sasl.h
#        --enable-sockets
#        --enable-intl=shared
#        --enable-intl=shared


make_install() {
    logmsg "--- make install"
    logcmd $MAKE DESTDIR=${DESTDIR} INSTALL_ROOT=${DESTDIR} install || \
        logerr "--- Make install failed"
    logmsg "--- copy php.ini examples"
    logcmd cp $TMPDIR/$BUILDDIR/php.ini-production $DESTDIR/$PREFIX/etc/php.ini-production
    logcmd cp $TMPDIR/$BUILDDIR/php.ini-development $DESTDIR/$PREFIX/etc/php.ini-development
}

# Create extension dir
create_extension_dir() {
    logmsg "--- Create extension directory"
    logcmd mkdir -p $DESTDIR/$EXTENSION_DIR
}

# PHP bcmath extension
install_ext_bcmath() {
    create_extension_dir
    logmsg "--- Moving files for bcmath extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/bcmath.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/bcmath.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving bcmath extensions failed."
}

# PHP calendar extension
install_ext_calendar() {
    create_extension_dir
    logmsg "--- Moving files for calendar extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/calendar.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/calendar.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving calendar extensions failed."
}

# PHP curl extension
install_ext_curl() {
    create_extension_dir
    logmsg "--- Moving files for curl extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/curl.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/curl.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving curl extensions failed."
}

# PHP exif extension
install_ext_exif() {
    create_extension_dir
    logmsg "--- Moving files for exif extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/exif.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/exif.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving exif extensions failed."
}

# PHP ftp extension
install_ext_ftp() {
    create_extension_dir
    logmsg "--- Moving files for ftp extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/ftp.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/ftp.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving ftp extensions failed."
}

# PHP gd extension
install_ext_gd() {
    create_extension_dir
    logmsg "--- Moving files for gd extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/gd.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/gd.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving gd extensions failed."
}

# PHP mbstring extension
install_ext_mbstring() {
    create_extension_dir
    logmsg "--- Moving files for mbstring extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/mbstring.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/mbstring.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving mbstring extensions failed."
}

# PHP mcrypt extension
install_ext_mcrypt() {
    create_extension_dir
    logmsg "--- Moving files for mcrypt extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/mcrypt.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/mcrypt.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving mcrypt extensions failed."
}

# PHP mysql extension
install_ext_mysql() {
    create_extension_dir
    logmsg "--- Moving files for mysql extensions"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/mysql.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/mysql.so $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/mysqli.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/mysqli.so $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/pdo_mysql.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/pdo_mysql.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving mysql extensions failed."
}

# PHP pdo extension
install_ext_pdo() {
    create_extension_dir
    logmsg "--- Moving files for pdo extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/pdo.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/pdo.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving pdo extensions failed."
}

# PHP sqlite extension
install_ext_sqlite() {
    create_extension_dir
    logmsg "--- Moving files for sqlite extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/sqlite3.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/sqlite3.so $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/pdo_sqlite.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/pdo_sqlite.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving sqlite extensions failed."
}

# PHP pgsql extension
install_ext_pgsql() {
    create_extension_dir
    logmsg "--- Moving files for pgsql extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/pgsql.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/pgsql.so $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/pdo_pgsql.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/pdo_pgsql.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving pgsql extensions failed."
}

# PHP zlib extension
install_ext_zlib() {
    create_extension_dir
    logmsg "--- Moving files for zlib extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/zlib.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/zlib.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving zlib extensions failed."
}

# PHP zip extension
install_ext_zip() {
    create_extension_dir
    logmsg "--- Moving files for zip extension"
    logcmd mv $INSTALLDIR/$EXTENSION_DIR/zip.a $DESTDIR/$EXTENSION_DIR/ && \
        logcmd mv $INSTALLDIR/$EXTENSION_DIR/zip.so $DESTDIR/$EXTENSION_DIR/ || \
            logerr "--- Moving zip extensions failed."
}


# There are some dotfiles/dirs that look like noise
clean_dotfiles() {
    logmsg "--- Cleaning up dotfiles in destination directory"
    logcmd rm -rf $DESTDIR/.??* || \
        logerr "--- Unable to clean up destination directory"
}

init
download_source $PROG $PROG $VER
patch_source
prep_build
build
clean_dotfiles


#################################
### CREATE EXTENSION PACKAGES ###
#################################

INSTALLDIR=$DESTDIR

PROG=php-bcmath
PKG=runtime/php56/php-bcmath
SUMMARY="PHP 5.6 - bcmath extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_bcmath
make_package ext.mog

PROG=php-calendar
PKG=runtime/php56/php-calendar
SUMMARY="PHP 5.6 - calendar extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_calendar
make_package ext.mog

PROG=php-curl
PKG=runtime/php56/php-curl
SUMMARY="PHP 5.6 - curl extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="local/web/curl library/security/cyrus-sasl library/libldap"
prep_build
install_ext_curl
make_package ext.mog

PROG=php-exif
PKG=runtime/php56/php-exif
SUMMARY="PHP 5.6 - exif extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_exif
make_package ext.mog

PROG=php-ftp
PKG=runtime/php56/php-ftp
SUMMARY="PHP 5.6 - ftp extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_ftp
make_package ext.mog

PROG=php-gd
PKG=runtime/php56/php-gd
SUMMARY="PHP 5.6 - gd extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="library/freetype2
    library/libjpeg
    library/libpng
    library/libtiff"
prep_build
install_ext_gd
make_package ext.mog

PROG=php-mbstring
PKG=runtime/php56/php-mbstring
SUMMARY="PHP 5.6 - mcrypt extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_mbstring
make_package ext.mog

PROG=php-mcrypt
PKG=runtime/php56/php-mcrypt
SUMMARY="PHP 5.6 - mcrypt extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="library/libmcrypt"
prep_build
install_ext_mcrypt
make_package ext.mog

PROG=php-mysql
PKG=runtime/php56/php-mysql
SUMMARY="PHP 5.6 - MySQL Extensions"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_mysql
make_package ext_mysql.mog

PROG=php-pdo
PKG=runtime/php56/php-pdo
SUMMARY="PHP 5.6 - pdo extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS=""
prep_build
install_ext_pdo
make_package ext.mog

PROG=php-pgsql
PKG=runtime/php56/php-pgsql
SUMMARY="PHP 5.6 - PostgreSQL Extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="library/libpq5"
prep_build
install_ext_pgsql
make_package ext_pgsql.mog

PROG=php-sqlite
PKG=runtime/php56/php-sqlite
SUMMARY="PHP 5.6 - sqlite extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="database/sqlite-3"
prep_build
install_ext_sqlite
make_package ext_sqlite.mog

PROG=php-zib
PKG=runtime/php56/php-zip
SUMMARY="PHP 5.6 - zip extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="local/library/zlib"
prep_build
install_ext_zip
make_package ext.mog

PROG=php-zlib
PKG=runtime/php56/php-zlib
SUMMARY="PHP 5.6 - zlib extension"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="local/library/zlib"
prep_build
install_ext_zlib
make_package ext.mog


##############################
### CREATE PHP 5.6 PACKAGE ###
##############################


DESTDIR=$INSTALLDIR
PROG=php
PKG=runtime/php56
SUMMARY="PHP Server 5.6"
DESC="PHP is a widely-used general-purpose scripting language that is especially suited for Web development and can be embedded into HTML."
DEPENDS_IPS="database/sqlite-3
    database/bdb
    system/library/iconv/unicode
    system/library/iconv/utf-8
    system/library/iconv/xsh4/latin
    local/library/zlib
    library/libssh2
    library/mhash"
make_package php56.mog

clean_up

# Vim hints
# vim:ts=4:sw=4:et:
