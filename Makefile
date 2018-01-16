CURRENT_PATH = $(shell pwd)

# common
IMAGE_NAME := docker.io/xczh/c9
TAG ?= ubuntu-rolling
DOCKER ?= docker

# build
DOCKERFILE := Dockerfile

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
DOCKER_BUILD_OPT :=

ifdef BASE_IMAGE
    DOCKER_BUILD_OPT += --build-arg BASE_IMAGE=${BASE_IMAGE}
endif

# target
build:
	sudo ${DOCKER} build -t ${IMAGE_NAME}:${TAG} -f ${DOCKERFILE} ${DOCKER_BUILD_OPT} .
run:
	sudo ${DOCKER} run ${DOCKER_RUN_OPT} ${IMAGE_NAME}:${TAG}

log: logs

logs:
	sudo ${DOCKER} logs ${CONTAINER_NAME}

stop:
	sudo ${DOCKER} stop ${CONTAINER_NAME}

start:
	sudo ${DOCKER} start ${CONTAINER_NAME}

rm: stop
	sudo ${DOCKER} rm ${CONTAINER_NAME}

rmi:
	sudo ${DOCKER} rmi ${IMAGE_NAME}:${TAG}

clean: rm rmi

pull:
	sudo ${DOCKER} pull ${IMAGE_NAME}:${TAG}

save:
	mkdir -p images
	sudo ${DOCKER} save ${IMAGE_NAME}:${TAG} | xz -v -z -T 0 - > images/$(subst /,_,${IMAGE_NAME}):${TAG}.tar.xz

load:
	xz -v -d -T 0 -c images/$(subst /,_,${IMAGE_NAME}):${TAG}.tar.xz | sudo ${DOCKER} load

.PHONY: build run stop start rm log logs
