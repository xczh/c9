# ==================================================================
# Based on xczh/c9
# ------------------------------------------------------------------
#  MATLAB
# ==================================================================

ARG BASE_IMAGE=
ARG MATLAB_VER=

FROM ${BASE_IMAGE}

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
