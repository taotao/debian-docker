#!/bin/bash

ARCHIVE_LIST=(wheezy)

ARCH=$1
DISTRO=$2
BUILD_DIR=/root/${ARCH}_${DISTRO}

DEB_URL="http://deb.debian.org/debian/"
DEB_SECURITY_URL="http://deb.debian.org/debian-security/"
ARCHIVE_URL="http://archive.debian.org/debian/"
ARCHIVE_SECURITY_URL="http://archive.debian.org/debian-security"

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

URL="${DEB_URL}"
SECURITY_URL="${DEB_SECURITY_URL}"
if [[ ${ARCHIVE_LIST[*]} =~ ${DISTRO} ]]; then
	URL="${ARCHIVE_URL}"
	SECURITY_URL="${ARCHIVE_SECURITY_URL}"
fi

LC_ALL=C LANGUAGE=C LANG=C \
	qemu-debootstrap \
	--variant=minbase \
	--arch "${ARCH}" \
	"${DISTRO}" "${BUILD_DIR}" "${URL}"

echo "deb ${URL} ${DISTRO} main contrib non-free" > "${BUILD_DIR}/etc/apt/sources.list"
echo "deb ${SECURITY_URL} ${DISTRO} main contrib non-free" >> "${BUILD_DIR}/etc/apt/sources.list"

tar -C "${BUILD_DIR}"  -f /root/build/image.tar -c .
