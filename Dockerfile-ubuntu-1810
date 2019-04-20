# ==================================================================
# Based on Ubuntu
# ------------------------------------------------------------------
#  C / C++ / Python2 / Python3 / PHP / Golang / NodeJS
# ==================================================================


FROM ubuntu:18.10

LABEL maintainer.name="xczh" \
      maintainer.email="xczh.me@foxmail.com" \
      description="Cloud9 WebIDE"

USER root

WORKDIR /root

SHELL ["/bin/bash", "-c"]

ENV LANG="C.UTF-8"

# ==================================================================
# add files
# ------------------------------------------------------------------

COPY build/ /tmp/build/

# ==================================================================
# prepare
# ------------------------------------------------------------------

RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP2_INSTALL="pip2 --no-cache-dir install --upgrade" && \
    PIP3_INSTALL="pip3 --no-cache-dir install --upgrade" && \
    GIT_CLONE="git clone --single-branch --depth 1" && \

    rm -rf /var/lib/apt/lists/* \
           /etc/apt/sources.list.d/cuda.list \
           /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get update && \
    echo 'PATH=$PATH:/cloud9/bin:/usr/local/ide-bin' >> /root/.bashrc && \
    echo "alias open='c9 open'" >> /root/.bashrc && \

# ==================================================================
# tools
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        apt-transport-https \
        apt-utils \
        ca-certificates \
        curl \
        file \
        git \
        gnupg \
        htop \
        inetutils-ping \
        nano \
        net-tools \
        openssl \
        tzdata \
        unzip \
        vim \
        wget \
        xauth \
        zip \
        && \
    echo "Asia/Shanghai" > /etc/timezone && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \

# ==================================================================
# copy/move files [before]
# ------------------------------------------------------------------

    mv -f /tmp/build/ide-run /usr/sbin/ && \
    mv -f /tmp/build/ide-bin/ /usr/local/ && \
    chmod -R a+x /usr/sbin/ide-run /usr/local/ide-bin/* && \

# ==================================================================
# c AND c++
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        build-essential \
        cmake \
        g++ \
        gcc \
        gdb \
        make \
        && \

# ==================================================================
# python2 AND python3
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        python \
        python-dev \
        python3 \
        python3-dev \
        && \
    curl -L  https://bootstrap.pypa.io/get-pip.py | python2 && \
    curl -L  https://bootstrap.pypa.io/get-pip.py | python3 && \
    $PIP2_INSTALL \
        setuptools \
        virtualenv \
        && \
    $PIP3_INSTALL \
        setuptools \
        virtualenv \
        && \

# ==================================================================
# php
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        php-bz2 \
        php-cli \
        php-curl \
        php-gd \
        php-json \
        php-mbstring \
        php-mysql \
        php-net-smtp \
        php-net-socket \
        php-soap \
        php-sqlite3 \
        php-xdebug \
        php-xml \
        php-zip \
        && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \

# ==================================================================
# golang
# ------------------------------------------------------------------

    GOLANG_VER=`git ls-remote -t https://github.com/golang/go | awk -F/ '$3 ~ /^go1(\.[0-9]+)+$/ {print $3}' | sort -Vr | head -n 1` && \
    curl -o /tmp/${GOLANG_VER}.linux-amd64.tar.gz \
        https://dl.google.com/go/${GOLANG_VER}.linux-amd64.tar.gz && \
    tar -zxf /tmp/${GOLANG_VER}.linux-amd64.tar.gz -C /usr/local/ && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt && \
    ln -s /usr/local/go/bin/godoc /usr/local/bin/godoc && \
    rm -f /tmp/${GOLANG_VER}.linux-amd64.tar.gz && \
    /usr/local/bin/go version && \

# ==================================================================
# node.js
# ------------------------------------------------------------------

    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        nodejs \
        && \
    ln -s /usr/bin/nodejs /usr/local/bin/node && \
    npm config set registry https://registry.npm.taobao.org && \
    npm install -g http-server && \

# ==================================================================
# cloud9
# note: tmux-1.9 required
# ------------------------------------------------------------------

    $GIT_CLONE https://github.com/c9/core.git /cloud9 && \
    /cloud9/scripts/install-sdk.sh && \

# ==================================================================
# c9-codeintel
# see: https://github.com/c9/c9.ide.language.codeintel
# ------------------------------------------------------------------

    virtualenv --python=python2 /root/.c9/python2 && \
    . /root/.c9/python2/bin/activate && \
    mkdir /tmp/codeintel && \
    pip download -d /tmp/codeintel codeintel==0.9.3 && \
    cd /tmp/codeintel && \
    tar xf CodeIntel-0.9.3.tar.gz && \
    mv CodeIntel-0.9.3/SilverCity CodeIntel-0.9.3/silvercity && \
    tar -zcf CodeIntel-0.9.3.tar.gz CodeIntel-0.9.3 && \
    pip install -U --no-index --find-links=/tmp/codeintel codeintel && \
    deactivate && \
    cd /root && \

# ==================================================================
# openssh
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        openssh-server \
        && \
    mkdir /var/run/sshd && \
    sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/.*X11Forwarding.*/X11Forwarding yes/' /etc/ssh/sshd_config && \

# ==================================================================
# supervisor
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        supervisor \
        && \
    sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' \
        /etc/supervisor/supervisord.conf && \

# ==================================================================
# copy/move files [after]
# ------------------------------------------------------------------

    mkdir -p /root/.c9/ /etc/supervisor/ && \
    mv -f /tmp/build/config/user.settings /root/.c9/user.settings && \
    mv -f /tmp/build/config/supervisord.conf /etc/supervisor/supervisord.conf && \

# ==================================================================
# cleanup
# ------------------------------------------------------------------

    sed -i 's/http:\/\/archive.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/http:\/\/security.ubuntu.com/https:\/\/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    apt-get clean -y && \
    apt-get autoremove -y && \
    npm cache clean --force && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache /root/.c9/tmux-* /root/.c9/libevent-* /root/.c9/ncurses-*

# ==================================================================
# meta
# ------------------------------------------------------------------

VOLUME /workspace

EXPOSE 80
EXPOSE 22

ENV C9_AUTH=root:webide
ENV EXTERNAL_PORT=

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
