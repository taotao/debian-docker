PROJ_NAME=debian-docker

ARCH=armhf
DISTRO=wheezy

LOCAL_IMAGE_NAME=${PROJ_NAME}:${ARCH}-${DISTRO}
REMOTE_IMAGE_NAME=${DOCKER_USER}/${LOCAL_IMAGE_NAME}

.PHONY: all build clean

all: build

build:
	docker pull debian:${DISTRO}
	docker run \
		--rm \
		-v $(shell pwd):/root/build \
		--privileged \
		debian:${DISTRO} /root/build/run.sh ${ARCH} ${DISTRO}
	cat image.tar | docker import - ${LOCAL_IMAGE_NAME}

upload:
	docker tag \
		${LOCAL_IMAGE_NAME} \
		${REMOTE_IMAGE_NAME}
	@docker login \
		--username=${DOCKER_USER} \
		--email=${DOCKER_EMAIL} \
		--password=${DOCKER_PASSWORD}
	docker push ${REMOTE_IMAGE_NAME}

clean:
	rm -rf image.tar
