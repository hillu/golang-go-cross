# Golang cross-compiler support for Debian

This is a Debian source package that builds CGO-enabled runtime
libraries for architectures other than the host architecture and
installs those into GOROOT. Golang sources are not included -- the
source code shipped as part of the _golang-src_ package is used
instead.

This allows for cross-building binaries for Linux and Windows
platforms, including CGO support, as requested in
[#776401](https://bugs.debian.org/#776401). The results have been
successfully tested Windwos and Linux, i386 and amd64. Testing is
still needed for linux-armhf, linux-aarch64, linux-ppc64el.

This package has been successfully tested with Golang 1.6, 1.7, 1.8
packages from _jessie-backports_ and _stretch_.

 -- Hilko Bengen <bengen@debian.org>
