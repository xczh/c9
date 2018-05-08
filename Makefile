CURRENT_PATH = $(shell pwd)

# common
IMAGE_NAME := xczh/c9
TAG ?= ubuntu-rolling
DOCKER ?= docker

# build
DOCKERFILE := Dockerfile

# run
CONTAINER_NAME ?= c9
CONTAINER_IP ?=
CONTAINER_NET ?=
HOSTNAME ?= c9
STORAGE_ROOT ?= ${HOME}/c9
EXTERNAL_PORT ?=
EXTERNAL_HTTP_PORT ?=
EXTERNAL_SSHD_PORT ?=
USER := root
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

ifdef CONTAINER_NET
    ifdef CONTAINER_IP
        DOCKER_RUN_OPT += --net ${CONTAINER_NET} --ip ${CONTAINER_IP}
    endif
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
	sudo ${DOCKER} save ${IMAGE_NAME}:${TAG} -o images/$(subst /,_,${IMAGE_NAME}):${TAG}.tar && xz -v -z -T 0 images/$(subst /,_,${IMAGE_NAME}):${TAG}.tar

load:
	sudo ${DOCKER} load < images/$(subst /,_,${IMAGE_NAME}):${TAG}.tar.xz

.PHONY: build run stop start rm log logs