#!/bin/bash

ARCH=$1
DISTRO=$2
BUILD_DIR=/root/${ARCH}_${DISTRO}

DEB_URL="http://deb.debian.org/debian/"

export DEBIAN_FRONTEND="noninteractive"
export DEBCONF_NONINTERACTIVE_SEEN="true"

apt-get update
apt-get upgrade -y
apt-get install -y \
	binfmt-support \
	qemu-user-static \
	debootstrap

service binfmt-support restart

mkdir -p "${BUILD_DIR}"

LC_ALL=C LANGUAGE=C LANG=C \
	qemu-debootstrap \
	--variant=minbase \
	--arch "${ARCH}" \
	"${DISTRO}" "${BUILD_DIR}" "${DEB_URL}"

echo "deb ${DEB_URL} ${DISTRO} main contrib non-free" > "${BUILD_DIR}/etc/apt/sources.list"

tar -C "${BUILD_DIR}"  -f /root/build/image.tar -c .
