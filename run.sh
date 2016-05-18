#!/bin/bash

ARCH=$1
DISTRO=$2
BUILD_DIR=/root/${ARCH}_${DISTRO}

DEB_URL="http://httpredir.debian.org/debian/"

apt-get update
apt-get upgrade -y
apt-get install -y \
	binfmt-support \
	qemu-user-static \
	debootstrap

service binfmt-support restart

mkdir -p ${BUILD_DIR}

DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
	LC_ALL=C LANGUAGE=C LANG=C \
	debootstrap \
	--variant=minbase \
	--include=inetutils-ping,iproute \
	--foreign \
	--arch ${ARCH} \
	${DISTRO} ${BUILD_DIR} ${DEB_URL}

cp /usr/bin/qemu-*-static ${BUILD_DIR}/usr/bin

DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
	LC_ALL=C LANGUAGE=C LANG=C \
	chroot ${BUILD_DIR} /debootstrap/debootstrap --second-stage

DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
	LC_ALL=C LANGUAGE=C LANG=C \
	chroot ${BUILD_DIR} dpkg --configure -a

echo "${DEB_URL} ${DISTRO} main contrib non-free" > ${BUILD_DIR}/etc/apt/sources.list

tar -C ${BUILD_DIR} -c . | docker import - debian-${ARCH}-${DISTRO}-docker
