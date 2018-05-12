#!/bin/bash

set -e

container_name=c9
container_hostname=${container_name}
path_to_workspace=${HOME}
password=webide
http_port=10080
sshd_port=10022

sudo docker run -d --restart=always \
                  --name ${container_name} \
                  --hostname ${container_hostname} \
                  --cap-add SYS_PTRACE \
                  -v ${path_to_workspace}:/workspace \
                  -e C9_AUTH=root:${password} \
                  -p ${http_port}:80 \
                  -p ${sshd_port}:22 \
                  xczh/c9:cpu
