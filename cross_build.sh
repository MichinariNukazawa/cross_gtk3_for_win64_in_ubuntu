#!/bin/bash
#
# gtk3 app cross build
# host:		Ubuntu (Ubutn16.04 LTS amd64)
# target:	Win64
#
# depend: sudo apt-get install mingw-w64 -y
#
# Author: michinari.nukazawa@gmail.com
#

set -eu
set -o pipefail

trap 'echo "error:$0($LINENO) \"$BASH_COMMAND\" \"$@\""' ERR


SCRIPT_DIR=$(cd $(dirname $0); pwd)
CACHE_DIR=${SCRIPT_DIR}/download

WORK_DIR=${SCRIPT_DIR}
GTK3LIBRARY_DIR=${WORK_DIR}/gtk3_win64
BUILD_DIR=${WORK_DIR}/build

PACKAGE_NAME=test
PACKAGE_DIR=${BUILD_DIR}/${PACKAGE_NAME}


# download gkt3 library binary
if [ ! -e ${CACHE_DIR}/gtk+-bundle_3.10.4-20131202_win64.zip ] ; then
	mkdir -p ${CACHE_DIR}
	wget --tries=3 --wait=5 --continue http://win32builder.gnome.org/gtk+-bundle_3.10.4-20131202_win64.zip -P ${CACHE_DIR}
fi


# decompress gtk3
rm -rf ${GTK3LIBRARY_DIR}
mkdir -p ${GTK3LIBRARY_DIR}
pushd ${GTK3LIBRARY_DIR}

unzip ${CACHE_DIR}/gtk+-bundle_3.10.4-20131202_win64.zip > /dev/null
find -name '*.pc' | while read pc; do sed -e "s@^prefix=.*@prefix=$PWD@" -i "$pc"; done

popd


# build app source
rm -rf ${BUILD_DIR}
mkdir -p ${BUILD_DIR}
pushd ${BUILD_DIR}

cp ${SCRIPT_DIR}/gtk3_test.c .
export PKG_CONFIG_PATH=${GTK3LIBRARY_DIR}/lib/pkgconfig
x86_64-w64-mingw32-gcc gtk3_test.c -o gtk3_test.exe  `pkg-config --cflags --libs gtk+-3.0` -mwindows

popd


# packaging
rm -rf ${PACKAGE_DIR}
mkdir -p ${PACKAGE_DIR}
pushd ${PACKAGE_DIR}
cp ${BUILD_DIR}/gtk3_test.exe ${PACKAGE_DIR}/
cp ${GTK3LIBRARY_DIR}/bin/*.dll ${PACKAGE_DIR}/

zip -r9 ${WORK_DIR}/${PACKAGE_NAME}.zip *

popd

