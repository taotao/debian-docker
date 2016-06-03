PROJ_NAME=debian-image-docker

ARCH=armhf
DISTRO=wheezy

.PHONY: all build clean

all: build

build:
	docker pull debian:${DISTRO}
	docker run \
		--rm \
		-v $(shell pwd):/root/build \
		--privileged \
		debian:${DISTRO} /root/build/run.sh ${ARCH} ${DISTRO}
	cat image.tar | docker import - debian-${ARCH}-${DISTRO}-docker

clean:
	rm -rf image.tar
