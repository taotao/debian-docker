PROJ_NAME=debian-docker

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
	cat image.tar | docker import - debian-docker:${ARCH}-${DISTRO}

clean:
	rm -rf image.tar
