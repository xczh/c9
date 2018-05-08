#!/bin/bash

set -e

# For ubuntu Image

sed '/^ARG BASE_IMAGE=/d; s@\${BASE_IMAGE}@ubuntu:latest@g' Dockerfile > Dockerfile-ubuntu-lts
sed '/^ARG BASE_IMAGE=/d; s@\${BASE_IMAGE}@ubuntu:rolling@g' Dockerfile > Dockerfile-ubuntu-rolling

## For nvidia/cuda Image

sed '/^ARG BASE_IMAGE=/d; s@\${BASE_IMAGE}@nvidia/cuda:9.0-cudnn7-devel@g' Dockerfile > Dockerfile-nvidia-cu90-cudnn7
sed '/^ARG BASE_IMAGE=/d; s@\${BASE_IMAGE}@nvidia/cuda:8.0-cudnn6-devel@g' Dockerfile > Dockerfile-nvidia-cu80-cudnn6

echo "Generated. Successful!"
