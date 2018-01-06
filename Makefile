CURRENT_PATH = $(shell pwd)

# build
IMAGE_NAME := docker.io/xczh/c9
TAG ?= ubuntu-rolling
DOCKERFILE :=
GOLANG_VER ?=

# run
CONTAINER_NAME ?= c9
HOSTNAME ?= c9
STORAGE_ROOT ?= ${HOME}/c9
EXTERNAL_PORT ?=
EXTERNAL_HTTP_PORT ?=
EXTERNAL_SSHD_PORT ?=
USER ?= webide
PASS ?= webide

# for 'run'
# docker options
DOCKER_RUN_OPT := -d --restart=always --name ${CONTAINER_NAME} --hostname ${HOSTNAME} --cap-add SYS_PTRACE -v ${STORAGE_ROOT}:/workspace

ifdef PASS
    DOCKER_RUN_OPT += -e C9_AUTH=${USER}:${PASS}
else
    DOCKER_RUN_OPT += -e C9_AUTH=:
endif

ifdef EXTERNAL_PORT
    DOCKER_RUN_OPT += -e EXTERNAL_PORT=${EXTERNAL_PORT} -p ${EXTERNAL_PORT}:${EXTERNAL_PORT}
endif

ifdef EXTERNAL_HTTP_PORT
    DOCKER_RUN_OPT += -p ${EXTERNAL_HTTP_PORT}:80
endif

ifdef EXTERNAL_SSHD_PORT
    DOCKER_RUN_OPT += -p ${EXTERNAL_SSHD_PORT}:22
endif

# for 'build'
ifeq ($(TAG), latest)
    DOCKERFILE := Dockerfile
endif

ifeq ($(TAG), ubuntu-lts)
    DOCKERFILE := Dockerfile-ubuntu-lts
endif

ifeq ($(TAG), ubuntu-rolling)
    DOCKERFILE := Dockerfile-ubuntu-rolling
endif

ifndef DOCKERFILE
    $(error unknown docker TAG)
endif

DOCKER_BUILD_OPT :=

ifdef GOLANG_VER
    DOCKER_BUILD_OPT += --build-arg GOLANG_VER=${GOLANG_VER}
endif

# target
build:
	sudo docker build -t ${IMAGE_NAME}:${TAG} -f ${DOCKERFILE} ${DOCKER_BUILD_OPT} .
run:
	sudo docker run ${DOCKER_RUN_OPT} ${IMAGE_NAME}:${TAG}

log: logs

logs:
	sudo docker logs ${CONTAINER_NAME}

stop:
	sudo docker stop ${CONTAINER_NAME}

start:
	sudo docker start ${CONTAINER_NAME}

rm: stop
	sudo docker rm ${CONTAINER_NAME}

rmi:
	sudo docker rmi ${IMAGE_NAME}:${TAG}

clean: rm rmi

pull:
	sudo docker pull ${IMAGE_NAME}:${TAG}

save:
	mkdir -p images
	sudo docker save ${IMAGE_NAME}:${TAG} | xz -v -z -T 0 - > images/$(subst /,_,${IMAGE_NAME}):${TAG}.tar.xz

load:
	xz -v -d -T 0 -c images/$(subst /,_,${IMAGE_NAME}):${TAG}.tar.xz | sudo docker load

.PHONY: build run stop start rm log logs
