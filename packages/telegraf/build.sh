#!/bin/sh
CWD=$(pwd)
set -e

BUILD_ARCH=amd64
if dpkg-architecture -iarm64; then
	BUILD_ARCH=arm64
fi

SRC=telegraf
if [ ! -d ${SRC} ]; then
    echo "Source directory does not exists, please 'git clone'"
    exit 1
fi

PLUGIN_DIR=${CWD}/plugins

echo "I: Selecting Input plugins"
cp ${PLUGIN_DIR}/inputs/all/all.go ${SRC}/plugins/inputs/all/all.go

echo "I: Selecting Output plugins"
cp ${PLUGIN_DIR}/outputs/all/all.go ${SRC}/plugins/outputs/all/all.go

echo "I: Build Debian ${BUILD_ARCH} package"
cd ${SRC}
export PATH=/opt/go/bin:$PATH
LDFLAGS=-w make "${BUILD_ARCH}.deb"
