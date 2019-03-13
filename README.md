# C9 WebIDE

可在浏览器中写代码的IDE，`cloud9` WebIDE的Docker容器包装，享受云端coding的乐趣~

**自动构建**：[DockerHub](https://hub.docker.com/r/xczh/c9/tags/)

支持TAG:

 - `cpu`: 支持CPU的最新版
 - `gpu`: 支持GPU的最新版
 - `ubuntu-<ver>`：支持CPU的旧版本
 - `nvidia-cu<ver>-cudnn<ver>`：支持GPU的旧版本

```sh
# 使用CPU版本
$ sudo docker pull xczh/c9:cpu

# 使用GPU版本
$ sudo docker pull xczh/c9:gpu
```

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
# 80为IDE内部HTTP服务监听端口
# 22为IDE内部SSHD服务监听端口
$ sudo docker run -d --restart=always \
                  --name ${container_name} \
                  --hostname ${container_hostname} \
                  --cap-add SYS_PTRACE \
                  -v ${path_to_workspace}:/workspace \
                  -e C9_AUTH=root:${password} \
                  -p 10080:80 \
                  -p 10022:22 \
                  xczh/c9:cpu


# GPU版本运行示例
#
$ sudo nvidia-docker run -d --restart=always \
                         --name ${container_name} \
                         --hostname ${container_hostname} \
                         --cap-add SYS_PTRACE \
                         -v ${path_to_workspace}:/workspace \
                         -e C9_AUTH=root:${password} \
                         -p 10080:80 \
                         -p 10022:22 \
                         xczh/c9:gpu

```

现在，访问`http://<host-ip>:10080`试试~

Tips: GPU版本IDE内可执行nvidia-smi命令查看GPU状态
