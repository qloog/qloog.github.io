---
layout: post
title: 关于反向Ajax
category: 资源
date: 2015-08-06
tags: 反向ajax
---


### 目的：是让服务器将信息推送到客户端

### 相关介绍：

#### [第 1 部分: Comet 简介](http://www.ibm.com/developerworks/cn/web/wa-reverseajax1/index.html)  
介绍了实现 Reverse Ajax 通信的不同方式：轮询、搭载 (piggyback) 和 Comet，还介绍了如何使用长轮询 (long-polling) 和流


#### [第 2 部分: WebSockets](http://www.ibm.com/developerworks/cn/web/wa-reverseajax2/index.html)  
介绍了如何使用 WebSocket 实现 Reverse Ajax，并探讨了如何使用 Comet 和 WebSockets 限制 Web 服务器

#### [第 3 部分: Web 服务器和 Socket.IO](http://www.ibm.com/developerworks/cn/web/wa-reverseajax3/index.html)  
探讨了当您需要支持多个服务器或提供一个用户可以自己的服务器上部署的独立 Web 应用程序时，您实现自己的 Comet 或 WebSocket 通信系统的过程中会遇到的一些困难， 还引入了 Socket.IO

#### [第 4 部分: Atmosphere 和 CometD](http://www.ibm.com/developerworks/cn/web/wa-reverseajax4/index.html)  
介绍了 Atmosphere 和 CometD

#### [第 5 部分: 事件驱动的 Web 开发](http://www.ibm.com/developerworks/cn/web/wa-reverseajax5/index.html)  
应用到事件驱动开发原则，并构建一个事件驱动的 Web 应用程序示例

