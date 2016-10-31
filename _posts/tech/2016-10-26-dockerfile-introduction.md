---
layout: post
title: Dockerfile配置文件详解
category: 技术
date: 2016-10-28
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

执行镜像的操作指令，RUN 后面的命令就是正常的系统命令

**示例**
```
RUN apt-get update && apt-get install -y nginx
```

#### CMD 容器启动时的执行指令

 一般在最后执行, 有三种形式

```
CMD ["executable","param1","param2"]  (exec形式，首选)
或
CMD ["param1","param2"] （ENTRYPOINT的默认参数）
或
CMD command param1 param2 （shell形式）
```

一般一个`Dockerfile`文件里可能只有一个`CMD`指令，如果有多个`CMD`，则只有最后一个`CMD`会生效。
一个`CMD`主要的目的也就是为正在运行的容器提供默认处理。


#### LABEL

```
LABEL <key>=<value> <key>=<value> <key>=<value> ...
```

#### EXPOSE

```
EXPOSE <port> [<port>...]
```

告诉Docker守护进程需要监听的端口，而不是宿主暴露的端口，如果需要对宿主暴露端口，需要加`-p` 或`-P`参数来指定。

**Demo**

```
EXPOSE 6379
```

#### ENV

```
ENV <key> <value>
或
ENV <key>=<value> ...
```
`ENV <key> <value>`： 一行只能设定一个 key/value, key空格之后的所有字符都会被当做value处理，包含空格和引用
`ENV <key>=<value> ...`： 一次可以设定多个 key=value

**Demo**

```
#定义nginx版本
ENV NGINX_VERSION 1.9.14
或
ENV NGINX_VERSION=1.9.14
```

#### ADD

```
ADD <src>... <dest>
或
ADD ["<src>",... "<dest>"]
```

##### `<src>`

`ADD`指令会从`<src>`copy 文件、目录或者远程URL文件到指定容器的`<desc>`里。
可以指定多个`<src>`, 但必须是相对路径（针对当前目录）
每个 `<src>`里可以使用通配符
```
ADD hom* /mydir/        # adds all files starting with "hom"
ADD hom?.txt /mydir/    # ? is replaced with any single character, e.g., "home.txt"
```

##### `<desc>`

`<desc>` 必须是绝对路径， 或者是相对于`WORKDIR`的相对路径.
如果`<desc>`不存在会自动创建目录。

```
ADD test relativeDir/          # adds "test" to `WORKDIR`/relativeDir/
ADD test /absoluteDir/         # adds "test" to /absoluteDir/
```

#### COPY

```
COPY <src>... <dest>
或
COPY ["<src>",... "<dest>"]
```

和`ADD`指令类似，也是将`<src>`中的文件或目录copy到指定容器的系统目录`<desc>`里， 但与`ADD`不同的是，不支持远程URL的处理。
也支持多`<src>`和通配符。

```
COPY hom* /mydir/        # adds all files starting with "hom"
COPY hom?.txt /mydir/    # ? is replaced with any single character, e.g., "home.txt"
```

`<dest>`也必须是相对路径或者相对于`WORKDIR`的绝对路径

```
COPY test relativeDir/   # adds "test" to `WORKDIR`/relativeDir/
COPY test /absoluteDir/  # adds "test" to /absoluteDir/
```

#### ENTRYPOINT

```
ENTRYPOINT ["executable", "param1", "param2"](exec form, preferred)
或
ENTRYPOINT command param1 param2 (shell form)
```

#### VOLUME

用来创建一个挂载点，可以挂在宿主或者其他容器的volumes。
值可以是一个JSON数组，也可以是衣蛾多参数的字符串，如：

```
VOLUME ["/var/log/"]

VOLUME /var/log

VOLUME /var/log /var/db
```

#### USER

指定`RUN`,`CMD`, `ENTRYPOINT`指令运行时的用户名或UID

```
USER daemon
```

#### WORKDIR

`WORKDIR`指令为`RUN`,`CMD`,`ENTRYPOINT`,`COPY`,`ADD`指令设定工作目录， 如果此目录不存在，则会创建之。

在一个`Dockerfile`文件中，`WORKDIR`可以被使用多次，如果设定了相对目录，那么会基于之前的`WORKDIR`来设定:

```
WORKDIR /a
WORKDIR b
WORKDIR c
RUN pwd
```
输出 `/a/b/c`

`WORKDIR`指令也可以解析之前`ENV`设定的环境变量:

```
ENV DIRPATH /path
WORKDIR $DIRPATH/$DIRNAME
RUN pwd
```
输出 `/path/$DIRNAME`


## 参考

 - [官方文档](https://docs.docker.com/engine/reference/builder/#/dockerfile-reference)
 - [Dockerfile指令详解](http://seanlook.com/2014/11/17/dockerfile-introduction/)
 - [Dockerfile文件详解](https://hujb2000.gitbooks.io/docker-flow-evolution/content/cn/basis/dockerfiledetail.html)
 - [Docker配置文件Dockerfile详解](http://www.10tiao.com/html/496/201506/209218454/1.html)
 - [Nginx与Docker容器系列 - 1.进行编译安装](http://amao12580.github.io/post/2016/04/Nginx-with-docker-part-one/)
