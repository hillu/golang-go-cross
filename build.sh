#!/bin/bash

set -e

builddir=$1
export GOOS=$2
export GOARCH=$3
GOROOT=$4

export CGO_ENABLED=1
GOROOT_BOOTSTRAP=$($GOROOT/bin/go env GOROOT); export GOROOT_BOOTSTRAP
GOROOT_FINAL=$($GOROOT/bin/go env GOROOT); export GOROOT_FINAL

GOHOSTARCH=$($GOROOT/bin/go env GOHOSTARCH)

export GO386=387 # see golang/debian/helpers/goenv.sh
export GOARM=6

if [ ! -e $builddir/src/runtime/cgo/gcc_${GOOS}_${GOARCH}.c ]; then
    echo "gcc_${GOOS}_${GOARCH}.c not found" >&2
    exit 1
fi

case "$GOOS-$GOARCH" in
    linux-amd64)
        case "$GOHOSTARCH" in
            # Work around missing /usr/include/asm in gcc-5-multilib (#822189)
            386|amd64) export CGO_CFLAGS=-I/usr/include/i386-linux-gnu ;;
            *)         prefix=amd64-linux-gnu- ;;
        esac
        ;;
    linux-386)
        case "$GOHOSTARCH" in
            # See above.
            386|amd64) export CGO_CFLAGS=-I/usr/include/x86_64-linux-gnu ;;
            *)         prefix=i386-linux-gnu- ;;
        esac
        ;;
    linux-arm64)    prefix=aarch64-linux-gnu- ;;
    linux-ppc64le)  prefix=powerpc64le-linux-gnu- ;;
    linux-mips64le) prefix=mips64el-linux-gnuabi64- ;;
    linux-arm)      prefix=arm-linux-gnueabihf- ;; # Build for armhf rather than armel

    windows-386)   prefix=i686-w64-mingw32- ;;
    windows-amd64) prefix=x86_64-w64-mingw32- ;;

    *)
        echo "unknown architecture $GOOS-$GOARCH" >&2
        exit 1
        ;;
esac

export CC_FOR_TARGET="${prefix}gcc $cflags"
export CXX_FOR_TARGET="${prefix}g++ $cflags"

( cd $builddir/src; ./make.bash )
