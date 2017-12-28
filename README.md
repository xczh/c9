# C9 WebIDE

可在浏览器中写代码的IDE，`cloud9` WebIDE的Docker容器包装，享受云端coding的乐趣~

**自动构建**：[DockerHub](https://hub.docker.com/r/xczh/c9/tags/)

与官方版本相比的新增特性：

 - 主流发行版的构建工具链支持
 - 默认已设置好时区（Asia/Shanghai）
 - 解决官方版本命令行不能支持中文的Bug
 - 内置`C`/`C++`/`python2`/`python3`/`nodejs`/`php`/`golang`编程语言支持
 - 内置一系列helper工具，极大方便云端开发与集成
   * ide-yarn: 安装`nodejs`包管理工具`yarn`
   * open: 在终端中打开文件

## Maintainers

 - xczh [xczh.me@foxmail.com]

## 使用说明

1. 工作目录 `/workspace`

请在此目录下开发。此目录之外的其他目录将不会被持久化，数据将会在容器删除后丢失。

2. 用户自定义初始化脚本 `/workspace/.c9/user.init`

若此文件存在并且可执行(chmod a+x)，则将在开启新容器时自动执行，你可以在这里指定你的工作环境初始化工作~

3. 快捷指令

 - ide-* 系列工具 （使用`tab`键获得提示） 
 - `open`命令。用于在终端中打开/workspace和/root目录下的文件，参数`--pipe`试一试有惊喜哦~

## 编译指南

1. 从`DockerHub`获取预编译版本（推荐）

```sh
$ make pull
```

2. 自行从Dockerfile编译

可选编译参数：

 - TAG: 可选，`ubuntu-lts`/`ubuntu-rolling`，默认值`ubuntu-rolling`
 - GOLANG_VER: 可选，默认值请查看Dockerfile中ARG指令默认值

```sh
$ TAG=ubuntu-lts make
```

编译时间较长，构建过程需要FanQiang环境，否则将编译失败。

编译完成后，可以在本地镜像列表中看到。

```sh
$ sudo docker images
```

## 运行指南

可选运行参数：

 - TAG: 可选，`ubuntu-lts`/`ubuntu-rolling`，默认值`ubuntu-rolling`
 - STORAGE_ROOT: `/workspace`存储位置，可选，默认值`$HOME/c9`
 - EXTERNAL_PORT: 外部访问端口，可选，可指定单端口或端口范围。本参数通过-p映射到容器内部
 - EXTERNAL_HTTP_PORT: 外部Web访问端口，可选，如需在宿主机之外的环境访问则需指定，如8080
 - EXTERNAL_SSHD_PORT: 外部ssh访问端口，可选，如需传输文件和利用ssh隧道加密通信，可指定
 - USER: WebIDE登陆用户名，可选，默认值为当前运行容器的用户
 - PASS: WebIDE登陆密码，可选，默认值`webide`，可设置为空从而禁用登陆验证

```sh
# eg. 无需HTTP Basic Auth认证
$ PASS= make run

# eg. 自定义用户名及端口映射
$ USER=myide PASS=mypasswd EXTERNAL_PORT=5000-5004 make run
```

容器运行起来之后，可以在宿主机上通过`http://<container-ip>`访问到。

如需外部访问：

```sh
$ EXTERNAL_HTTP_PORT=8080 EXTERNAL_PORT=51000 EXTERNAL_SSHD_PORT=52000 make run
```

访问`http://<host-ip>:8080`试试~
