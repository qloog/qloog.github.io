---
layout: post
title: [Docker] Dockerfile配置文件详解
category: 技术
date: 2016-02-11
tags: Docker Dockerfile
---

* This will become a table of contents (this text will be scraped).
{:toc}

## 基本介绍

`Dockerfile`是 Docker 创建镜像使用的配置文件，通过读取`Dockerfile`文件自动构建用户自定义镜像，`Dockerfile`本质上是一条一条指令的集合。
`docker build`是被`Docker daemon`docker守护进程执行，而不是`docker CLI`，执行后`Dockerfile`的指令被发送到守护进程.

构建镜像[`Dockerfile`在当前目录中

`docker build .`

指定`Dockerfile`文件

`docker build -f /path/to/a/Dockerfile .`

更多的参数可以通过以下命令来查看

`docker build --help`

指令的主要格式为：

```
# Comment
INSTRUCTION arguments
```

指令是大小写不敏感的，然而一般是指令大写，参数小写，这样指令和参数区分也更容易。

## Dockerfile文件指令说明

### FROM 定义基础镜像

```
FROM  <image>
或
FROM <image>:<tag>
或
FROM <image>@<digest>
```

**说明**

设置要制作的镜像基于哪个镜像，FROM指令必须是整个Dockerfile的第一个指令，如果指定的镜像不存在默认会自动从Docker Hub上下载。

**示例**

```
#定义基础镜像
FROM centos:6.7

```

### MAINTAINER 定义维护者信息

`MAINTAINER <name>`

**示例**
```
MAINTAINER docker_user docker_user@email.com
```

### 镜像操作指令

#### RUN

有两种形式：

```
RUN <command>
或
RUN ["executable", "param1", "param2"] (exec form)
```

**说明**

执行镜像的操作指令，RUN 后面的命令就是正常的系统命令

**示例**
```
RUN apt-get update && apt-get install -y nginx
```


#### LABEL

#### EXPOSE



```
EXPOSE <port> [<port>...]
```

**示例**

```
EXPOSE 6379:6379
```

#### ENV

**示例**

```

```
#### ADD


**示例**

```

```

#### COPY

**示例**

```

```

#### ENTRYPOINT

**示例**

```

```

#### VOLUME

**示例**

```

```
#### USER

**示例**

```

```

#### WORKDIR

**示例**

```

```

#### ARG

**示例**

```

```

#### ONBUILD

**示例**

```

```

#### STOPSIGNAL

**示例**

```

```

#### HEALTHCHECK

**示例**

```

```

#### SHELL

**示例**

```

```

### 容器启动时的执行指令

有两种形式

```
CMD ["executable","param1","param2"]
或
CMD ["param1","param2"]
或
CMD command param1 param2
```

**说明**

 一般在最后执行

**示例**

```

```

## 参考

 - [官方文档](https://docs.docker.com/engine/reference/builder/#/dockerfile-reference)
 - [Dockerfile指令详解](http://seanlook.com/2014/11/17/dockerfile-introduction/)
 - [Dockerfile文件详解](https://hujb2000.gitbooks.io/docker-flow-evolution/content/cn/basis/dockerfiledetail.html)
 - [Docker配置文件Dockerfile详解](http://www.10tiao.com/html/496/201506/209218454/1.html)
