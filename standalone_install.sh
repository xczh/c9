#!/bin/bash

# ==================================================================
# Cloud9 Standalone Installer
# ------------------------------------------------------------------
# Dependency: python python-dev git gcc build-essential make
#
# Before install, run as root:
#     apt-get update
#     apt-get install -y --no-install-recommends \
#         python python-dev git gcc build-essential make
#     curl -L  https://bootstrap.pypa.io/get-pip.py | python2
#     pip2 --no-cache-dir install --upgrade setuptools virtualenv
# ==================================================================

set -e

C9_HOME=~/cloud9
GIT_CLONE="git clone --single-branch --depth 10"

# set env
echo "export C9_HOME=$C9_HOME" >> ~/.bashrc
echo 'export PATH=$PATH:$C9_HOME/bin' >> ~/.bashrc
echo "alias open='c9 open'" >> ~/.bashrc

. ~/.bashrc

# install cloud9
$GIT_CLONE https://github.com/c9/core.git $C9_HOME && \
    $C9_HOME/scripts/install-sdk.sh && \
    sed -i -e 's_127.0.0.1_0.0.0.0_g' $C9_HOME/configs/standalone.js

# install c9-codeintel
virtualenv --python=python2 ~/.c9/python2 && \
. ~/.c9/python2/bin/activate && \
mkdir /tmp/codeintel && \
pip download -d /tmp/codeintel codeintel==0.9.3 && \
cd /tmp/codeintel && \
tar xf CodeIntel-0.9.3.tar.gz && \
mv CodeIntel-0.9.3/SilverCity CodeIntel-0.9.3/silvercity && \
tar -zcf CodeIntel-0.9.3.tar.gz CodeIntel-0.9.3 && \
pip2 install -U --no-index --find-links=/tmp/codeintel codeintel && \
deactivate
