---
layout: post
title: Docker常用命令
category: 运维
date: 2016-04-16
tags: docker
---

* This will become a table of contents (this text will be scraped).
{:toc}

## docker

	# 查看镜像
	docker images

	# 查看运营的容器
	docker ps

	# 运行 ubuntu
	docker run -i -t daocloud.io/ubuntu:14.04 /bin/bash

	# 运行ubuntu, 退出时自动删除容器
	docker run -i -t --rm daocloud.io/ubuntu:14.04 /bin/bash

	# 切换machine，使用docker-vm
	eval "$(docker-machine env docker-vm)"

	#切换到 dev machine
	eval "$(docker-machine env dev)"

	# 停止所有容器
	docker stop $(docker ps -a -q)

	# 删除指定镜像
	docker rmi $image

	# 删除无标示镜像，即id为<None>的镜像
	docker rmi $(docker images | grep "^<none>" | awk "{print $3}")

	# 删除所有镜像
	docker rmi $(docker images -q)

	# 杀死所有正在运行的容器
	docker kill $(docker ps -a -q)

	# 删除所有已经停止的容器
	docker rm $(docker ps -a -q)

	# 删除所有未打 dangling 标签的镜像
	docker rmi $(docker images -q -f dangling=true)

	# 删除所有镜像
	docker rmi $(docker images -q)

	# 查看内存、CPU的使用情况
	docker stats $(docker ps -q)

	CONTAINER           CPU %               MEM USAGE / LIMIT     MEM %               NET I/O               BLOCK I/O
	452bc3877700        0.03%               480.2 MB / 1.044 GB   45.98%              2.028 kB / 648 B      0 B / 0 B
	c2c1dda7e9bb        0.01%               11.93 MB / 1.044 GB   1.14%               7.096 kB / 3.522 kB   0 B / 0 B
	f35f291d6659        0.00%               9.806 MB / 1.044 GB   0.94%               8.638 kB / 8.422 kB   0 B / 0 B

## docker-machine

	# 查看机器列表
	docker-machine  ls
	NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER    ERRORS
	default   *        virtualbox   Running   tcp://192.168.99.100:2376           v1.10.3

	# 查看机器状态
	docker-machine status default

	# 登录机器default
	docker-machine ssh default

## docker-compose

	# 查看运行中的容器
	docker-compose ps

	Name                     Command             State               Ports
	-----------------------------------------------------------------------------------------
	dockerfiles_mysql_1   docker-entrypoint.sh mysqld   Up      0.0.0.0:3306->3306/tcp
	dockerfiles_nginx_1   nginx -g daemon off;          Up      443/tcp, 0.0.0.0:8080->80/tcp
	dockerfiles_php_1     php-fpm                       Up      0.0.0.0:9000->9000/tcp

	# 运行容器
	docker-compose up



## more about docker

 * [Docker —— 从入门到实践](http://wiki.jikexueyuan.com/list/docker/)
 * [DOCKER 中文版](http://wiki.jikexueyuan.com/project/docker/)
 * [Docker 实践](http://wiki.jikexueyuan.com/project/docker-practice/)
