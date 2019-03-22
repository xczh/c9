#!/bin/bash

set -e

tag=
container_name=c9
container_hostname=${container_name}
path_to_workspace=${HOME}
password=webide
http_port=10080
sshd_port=10022

sudo nvidia-docker run -d --restart=unless-stopped \
                  --name ${container_name} \
                  --hostname ${container_hostname} \
                  --cap-add SYS_PTRACE \
                  -v ${path_to_workspace}:/workspace \
                  -e C9_AUTH=root:${password} \
                  -p ${http_port}:80 \
                  -p ${sshd_port}:22 \
                  xczh/c9:${tag}
