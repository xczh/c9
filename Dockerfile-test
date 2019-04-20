# ==================================================================
# Based on Ubuntu
# ------------------------------------------------------------------
#  C / C++ / Python2 / Python3 / PHP / Golang / NodeJS
# ==================================================================

FROM ubuntu:rolling

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
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache /root/.c9/tmux-* /root/.c9/libevent-* /root/.c9/ncurses-*

# ==================================================================
# meta
# ------------------------------------------------------------------

ENV C9_AUTH=root:webide
ENV EXTERNAL_PORT=

CMD ["/bin/bash"]
