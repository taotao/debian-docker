#!/bin/bash
set -e

ARCH=armhf
DISTRO=wheezy

docker pull debian:${DISTRO}

docker run \
	--rm \
	-v $(pwd):/root/build \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v $(which docker):/bin/docker \
	-v /usr/lib/libapparmor.so.1:/usr/lib/libapparmor.so.1:ro \
	-v /lib/x86_64-linux-gnu/libdevmapper.so.1.02.1:/lib/x86_64-linux-gnu/libdevmapper.so.1.02.1:ro \
	-v /lib/x86_64-linux-gnu/libudev.so.0://lib/x86_64-linux-gnu/libudev.so.0:ro \
	--privileged \
	debian:${DISTRO} /root/build/run.sh ${ARCH} ${DISTRO}
