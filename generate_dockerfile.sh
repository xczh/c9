#!/bin/bash

set -e

# For ubuntu Image

sed '/^ARG BASE_IMAGE=/d; s@\${BASE_IMAGE}@ubuntu:18.10@g' Dockerfile > Dockerfile-ubuntu-1810
sed '/^ARG BASE_IMAGE=/d; s@\${BASE_IMAGE}@ubuntu:18.04@g' Dockerfile > Dockerfile-ubuntu-1804
sed '/^ARG BASE_IMAGE=/d; s@\${BASE_IMAGE}@ubuntu:16.04@g' Dockerfile > Dockerfile-ubuntu-1604

## For nvidia/cuda Image

sed '/^ARG BASE_IMAGE=/d; s@\${BASE_IMAGE}@nvidia/cuda:10.1-cudnn7-devel@g' Dockerfile > Dockerfile-nvidia-cu101-cudnn7
sed '/^ARG BASE_IMAGE=/d; s@\${BASE_IMAGE}@nvidia/cuda:10.0-cudnn7-devel@g' Dockerfile > Dockerfile-nvidia-cu100-cudnn7
sed '/^ARG BASE_IMAGE=/d; s@\${BASE_IMAGE}@nvidia/cuda:9.0-cudnn7-devel@g' Dockerfile > Dockerfile-nvidia-cu90-cudnn7

echo "Generated. Successful!"
