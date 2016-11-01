---
layout: post
title: Docker-compose配置文件详解
category: 技术
date: 2016-11-01
tags: Docker docker-compose
---

* This will become a table of contents (this text will be scraped).
{:toc}

## 基本介绍

Compose 文件是一个 [YAML](http://yaml.org/), 主要定义了 `services`, `networks `和`volumes`，
其默认路径是`./docker-compose.yml`。

`service`定义包含了应用与每个容器的配置，很像给`docker run`传参，同样，`network`和`volume`对于
`docker network create`和`docker volume create`也类似。

像在`Dockerfile` (eg: `CMD`, `EXPOSE`, `VOLUME`, `ENV`)可以使用的选项也可以在`docker run`参数中使用，
这样在`docker-compose.yml`里就不需要再次指定了。

`docker-compose.yml`里可以使用环境变量，类似 `Bash`格式` ${VARIABLE}`


## Service配置

composer 文件格式有两种版本：

 - version 1: 已经废弃， 不支持volumes 和 networks，默认`version` key 是省略的。
 - version 2: 推荐的格式，目前是最新的，需要通过`version '2'`指定。  [更多](https://docs.docker.com/compose/compose-file/#versioning)

### build

有两种用法：
 - 直接使用路径
 - 传入对象， 包含[context](https://docs.docker.com/compose/compose-file/#context), [dockerfile](https://docs.docker.com/compose/compose-file/#dockerfile), [args](https://docs.docker.com/compose/compose-file/#args)， `dockerfile`和`args`默认可不传。

```shell
build: ./dir

build:
  context: ./dir
  dockerfile: Dockerfile-alternate
  args:
    buildno: 1
```

如果指定`image`, 那么`Compose`会基于`webapp`和可选的`tag`来构建镜像。

```
build: ./dir
image: webapp:tag
```

上面的指令会生成一个基于`./dir`名称为`webapp`，tag为`tag`的镜像。

> 在 version 1 格式的文件里，两种方式是不同的
> 1. 仅支持字符串形式： `build: .`， 不支持对象形式。
> 2. 不能同时使用`build`和`image`, 如果尝试这么做的话会导致错误。

#### context

> 只支持version2, version1 只能使用`build`

值可以是一个目录路径，也可以是一个git repository url。  
当所提供的值是相对路径的时候，它被解释为compose文件位置的相对路径。目录里的信息会被当做构建内容
发送到Docker daemon。

#### dockerfile

备用的dockerfile.

Compose 将会使用备用的文件去构建，但必须指定路径。如：

```
build:
  context: .
  dockerfile: Dockerfile-alternate
```

#### args

> 仅支持 Version2

添加构建环境变量参数，但是仅构建过程期间可以使用。如：

```
ARG buildno
ARG password

RUN echo "Build number: $buildno"
RUN script-requiring-password.sh "$password"
```

`args`可以使用 mapping 或 list:

```
build:
  context: .
  args:
    buildno: 1
    password: secret

build:
  context: .
  args:
    - buildno=1
    - password=secret
```

### depends_on

表示服务之间的依赖关系， 有两个影响：

 - `docker-compose up` 将会根据依赖关系的顺序开启所有服务，下面的例子中, `db`和`redis`会早于`web`服务先启动。
 - `docker-compose up SERVICE` 会自动包含`SERVICE`的依赖，下面的例子中，`docker-compose up web`将会创建，同时也会启动`db`和`redis`服务。

```
version: '2'
services:
  web:
    build: .
    depends_on:
      - db
      - redis
  redis:
    image: redis
  db:
    image: postgres
```

> web 服务启动前并不会等待db和redis到ready状态才启动。如果需要等待其他服务到ready状态，可以参考[Controlling startup order](https://docs.docker.com/compose/startup-order/)

### environment

添加环境变量。可以是数组或者字典格式。任何的boolean值(eg:`true`,`false`,`yes`,`no`)都需要被引号引用，避免被`YAML`解析器解析为`True`或`False`.

```
environment:
  RACK_ENV: development
  SHOW: 'true'
  SESSION_SECRET:

environment:
  - RACK_ENV=development
  - SHOW=true
  - SESSION_SECRET
```

### expose

对外暴露端口，但不是暴露给host机器的，而是对已经 linked 的service可访问。

```
expose:
 - "3000"
 - "8000"
```

### image

指定要启动容器的镜像，可以是`repository/tag`或`image ID`

```
image: redis
image: ubuntu:14.04
image: tutum/influxdb
image: example-registry.com:4000/postgresql
image: a4bc65fd
```

镜像文件不存在，Compose会尝试去远端拉取。

### labels

添加`metadata`到容器中。可以使用数组或字典

```
labels:
  com.example.description: "Accounting webapp"
  com.example.department: "Finance"
  com.example.label-with-empty-value: ""

labels:
  - "com.example.description=Accounting webapp"
  - "com.example.department=Finance"
  - "com.example.label-with-empty-value"
```

### links

link到其他服务容器，可以使用服务名+alias(`SERVICE:ALIAS`), 也可以只使用服务名。

```
web:
  links:
   - db
   - db:database
   - redis
```

### pid

将 当前的`PID`设置为主机的`PID`.这会打开容器和host操作系统之间的`PID`地址共享。
带有`PID`启动的容器可以访问和操纵其他真实机器空间容器。 反之亦然。

`pid: "host"`


### ports

暴露端口。既可以是`HOST:CONTAINER`，也可以只用容器端口(host端口会随机选取)。

> 当以`HOST:CONTAINER`的形式映射端口的时候，当容器的端口低于60的时候可能会遇到错误，因为YAML会解析`xx:yy`数字为60。
> 基于这个原因，我们推荐明确指定端口映射用字符串的形式。

```
ports:
 - "3000"
 - "3000-3005"
 - "8000:8000"
 - "9090-9091:8080-8081"
 - "49100:22"
 - "127.0.0.1:8001:8001"
 - "127.0.0.1:5000-5010:5000-5010"
```

### volumes

挂载指定的路径或者named volumes, 可以在主机上指定一个路径`HOST:CONTAINER`, 或者一个可访问的`HOST:CONTAINER:ro`。

```
volumes:
  # Just specify a path and let the Engine create a volume
  - /var/lib/mysql

  # Specify an absolute path mapping
  - /opt/data:/var/lib/mysql

  # Path on the host, relative to the Compose file
  - ./cache:/tmp/cache

  # User-relative path
  - ~/configs:/etc/configs/:ro

  # Named volume
  - datavolume:/var/lib/mysql
```

## Volume配置

## Network配置

## 参考

 - [Compose file reference](https://docs.docker.com/compose/compose-file)
