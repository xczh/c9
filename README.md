# C9 WebIDE

***提示***：由于上游[c9/core](https://github.com/c9/core)被Amazon收购，开源项目停止维护，因此本项目也不再维护。上游项目使用的npm包大多已经过时，可能存在安全隐患；代码提示插件使用的Python2也将于2020年1月停止官方支持。若您仍然使用本项目构建的IDE镜像，建议仅部署在内网等安全可信区域。

建议使用Microsoft VSCode的网页版[code-server](https://github.com/xczh/code-server)作为替代。

可在浏览器中写代码的IDE，`cloud9` WebIDE的Docker容器包装，享受云端coding的乐趣~

**自动构建**：[DockerHub](https://hub.docker.com/r/xczh/c9/tags/)

支持TAG:

 - `ubuntu-1810`：支持CPU的版本，基于Ubuntu 18.10
 - `ubuntu-1804`：支持CPU的版本，基于Ubuntu 18.04(LTS)
 - `ubuntu-1604`：支持CPU的版本，基于Ubuntu 16.04(Old-LTS)
 - `nvidia-cu101-cudnn7`：支持GPU的版本，基于Ubuntu 18.04(LTS)+CUDA10.1+CuDNN7
 - `nvidia-cu100-cudnn7`：支持GPU的版本，基于Ubuntu 18.04(LTS)+CUDA10.0+CuDNN7
 - `nvidia-cu90-cudnn7`：支持GPU的版本，基于Ubuntu 18.04(LTS)+CUDA9.0+CuDNN7

```sh
# 使用CPU版本
$ sudo docker pull xczh/c9:ubuntu-1804

# 使用GPU版本
$ sudo docker pull xczh/c9:nvidia-cu90-cudnn7
```

Tips:

 - CUDA 10.0以上需要`nvidia-docker 2`，不再支持`nvidia-docker 1.x`
 - 使用不同的GPU版本对驱动程序的版本要求不同，参见[这里](https://github.com/NVIDIA/nvidia-docker/wiki/CUDA#requirements)

与官方版本相比的新增特性：

 - 基于Ubuntu，内置基本构建工具链支持
 - 默认已设置好时区（Asia/Shanghai）
 - 解决官方版本命令行不能支持中文的Bug
 - 内置`C`/`C++`/`python2`/`python3`/`nodejs`/`php`/`golang`编程语言支持
 - 内置一系列helper工具，极大方便云端开发与集成
 - 全面兼容`nvidia-docker`，使用`GPU`构建深度学习开发环境

## Maintainers

 - xczh [xczh.me@foxmail.com]

## 使用说明

1. 工作目录 `/workspace`

该目录为数据卷Volume，请在此目录下开发。此目录之外的其他目录将**不会被持久化**，数据将会在容器删除后丢失。

2. 用户自定义初始化脚本 `/workspace/.c9/user.init`

若此文件存在并且可执行(chmod a+x)，则将在开启新容器时自动执行，你可以在这里指定你的工作环境初始化工作~

3. 快捷指令

 - ide-* 系列工具 （使用`tab`键获得提示） 
 - `open`命令。用于在终端中打开/workspace和/root目录下的文件，参数`--pipe`试一试有惊喜哦~

## 运行指南

建议你使用`deploy/cpu-template.sh`和`deploy/gpu-template.sh`修改后运行容器。

```sh
# CPU版本运行示例
#
# EXTERNAL_PORT: （可选）用于映射容器端口，使得外部网络可访问
# SYS_PTRACE权限用于容器内GDB调试，如果不需要使用GDB无需添加此项权限
# 80为IDE内部HTTP(S)服务监听端口
# 22为IDE内部SSHD服务监听端口
# 如需启用HTTPS，添加-v /path/to/cert-key-bundle.pem:/etc/ssl/private/certkey.pem:ro
$ sudo docker run -d --restart=unless-stopped \
                  --name ${container_name} \
                  --hostname ${container_hostname} \
                  --cap-add SYS_PTRACE \
                  -v ${path_to_workspace}:/workspace \
                  -e C9_AUTH=root:${password} \
                  -p 10080:80 \
                  -p 10022:22 \
                  xczh/c9:ubuntu-1804


# GPU版本运行示例
#
$ sudo nvidia-docker run -d --restart=unless-stopped \
                         --name ${container_name} \
                         --hostname ${container_hostname} \
                         --cap-add SYS_PTRACE \
                         -v ${path_to_workspace}:/workspace \
                         -e C9_AUTH=root:${password} \
                         -p 10080:80 \
                         -p 10022:22 \
                         xczh/c9:nvidia-cu90-cudnn7

```

现在，访问`http(s)://<host-ip>:10080`试试~

Tips: GPU版本IDE内可执行nvidia-smi命令查看GPU状态
