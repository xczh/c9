# ==================================================================
# Based on xczh/c9
# Usage: docker build -t xczh/c9:nvidia-cu90-cudnn7-R2018a --build-arg BASE_IMAGE=xczh/c9:nvidia-cu90-cudnn7 --build-arg MATLAB_VER=R2018a .
# ------------------------------------------------------------------
#  MATLAB
# ==================================================================

ARG BASE_IMAGE=
FROM ${BASE_IMAGE}

ARG MATLAB_VER=
ENV MATLAB_VER=${MATLAB_VER}

# ==================================================================
# add files
# ------------------------------------------------------------------

COPY MATLAB/${MATLAB_VER}/ /usr/local/MATLAB/${MATLAB_VER}/

# ==================================================================
# prepare
# ------------------------------------------------------------------

RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    apt-get update && \

# ==================================================================
# MATLAB Install
# ------------------------------------------------------------------

    DEBIAN_FRONTEND=noninteractive $APT_INSTALL \
        libjogl2-jni \
        libxt6 \
        libxtst6 \
        libxi6 \
        libxrender1 && \
    ln -s /usr/local/MATLAB/${MATLAB_VER}/bin/matlab /usr/local/bin/matlab && \
    ln -s /usr/local/MATLAB/${MATLAB_VER}/bin/mcc /usr/local/bin/mcc && \
    ln -s /usr/local/MATLAB/${MATLAB_VER}/bin/mex /usr/local/bin/mex && \
    ln -s /usr/local/MATLAB/${MATLAB_VER}/bin/mbuild /usr/local/bin/mbuild && \

# ==================================================================
# cleanup
# ------------------------------------------------------------------

    apt-get clean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache
