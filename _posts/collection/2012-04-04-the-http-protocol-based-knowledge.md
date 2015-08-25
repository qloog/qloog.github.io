---
layout: post
title: HTTP协议基础知识详解
date: 2012-04-04 16:15:33
category: 收藏
tags: HTTP, 协议
---


当今web程序的开发技术真是百家争鸣，ASP.NET, PHP, JSP，Perl, AJAX 等等。 无论Web技术在未来如何发展，理解Web程序之间通信的基本协议相当重要， 因为它让我们理解了Web应用程序的内部工作. 本文将对HTTP协议进行详细的实例讲解，内容较多，希望大家耐心看。也希望对大家的开发工作或者测试工作有所帮助。使用Fiddler工具非常方便地捕获HTTP Request和HTTP Response, 关于Fiddler工具的用法，请查看博客[[Fiddler 教程](http://kb.cnblogs.com/page/130367/)]  **阅读目录**

  1. [什么是HTTP协议](//612#whathttp)
  2. [Web服务器，浏览器，代理服务器](//612#threeconcept)
  3. [URL详解](//612#urlexplain)
  4. [HTTP协议是无状态的](//612#statelesshttp)
  5. [HTTP消息的结构](//612#httpmeessagestructe)
  6. [Get和Post方法的区别](//612#getpost)
  7. [状态码](//612#statecode)
  8. [HTTP Request header](//612#httprequestheader)
  9. [HTTP Response header](//612#httpresponseheader)
  10. [HTTP协议是无状态的和Connection: keep-alive的区别](//612#statelessalive)

## 什么是HTTP协议

协议是指计算机通信网络中两台计算机之间进行通信所必须共同遵守的规定或规则，超文本传输协议(HTTP)是一种通信协议，它允许将超文本标记语言(HTML)文档从Web服务器传送到客户端的浏览器 目前我们使用的是HTTP/1.1 版本

## Web服务器，浏览器，代理服务器

当我们打开浏览器，在地址栏中输入URL，然后我们就看到了网页。
原理是怎样的呢？ 实际上我们输入URL后，我们的浏览器给Web服务器发送了一个Request, Web服务器接到Request后进行处理，生成相应的Response，然后发送给浏览器， 浏览器解析Response中的HTML,这样我们就看到了网页，过程如下图所示 ![http_step](//static/uploads/2012/04/http_step.png)   我们的Request 有可能是经过了代理服务器，最后才到达Web服务器的。
过程如下图所示 ![http_proxy_step](//static/uploads/2012/04/http_proxy_step.png)   代理服务器就是网络信息的中转站，有什么功能呢？
1\. 提高访问速度， 大多数的代理服务器都有缓存功能。
2\. 突破限制， 也就是翻墙了
3\. 隐藏身份。

## URL详解

URL(Uniform Resource Locator) 地址用于描述一个网络上的资源， 基本格式如下

> schema://host[:port#]/path/.../[;url-params][?query-string][#anchor]

scheme 指定低层使用的协议(例如：http, https, ftp) host HTTP服务器的IP地址或者域名 port# HTTP服务器的默认端口是80，这种情况下端口号可以省略。如果使用了别的端口，必须指明，例如 http://www.cnblogs.com:8080/ path 访问资源的路径 url-params query-string 发送给http服务器的数据 anchor- 锚 URL 的一个例子

> http://www.mywebsite.com/sj/test;id=8079?name=sviergn&x=true#stuffSchema: http host: www.mywebsite.com path: /sj/test URL params: id=8079 Query String: name=sviergn&x=true Anchor: stuff

## HTTP协议是无状态的

http协议是无状态的，同一个客户端的这次请求和上次请求是没有对应关系，对http服务器来说，它并不知道这两个请求来自同一个客户端。 为了解决这个问题， Web程序引入了Cookie机制来维护状态.

## HTTP消息的结构

先看Request 消息的结构， Request 消息分为3部分，第一部分叫请求行， 第二部分叫http header, 第三部分是body. header和body之间有个空行， 结构如下图 ![http_msg_struction](/static/uploads/2012/04/http_msg_struction.png)   第一行中的Method表示请求方法，比如"POST"，"GET"， Path-to-resoure表示请求的资源， Http/version-number 表示HTTP协议的版本号 当使用的是"GET" 方法的时候， body是为空的 比如我们打开博客园首页的request 如下

> GET http://www.cnblogs.com/ HTTP/1.1Host: www.cnblogs.com

我们用Fiddler 捕捉一个博客园登录的Request 然后分析下它的结构， 在Inspectors tab下以Raw的方式可以看到完整的Request的消息， 如下图 ![http_request](/static/uploads/2012/04/http_request.png)   我们再看Response消息的结构， 和Request消息的结构基本一样。
同样也分为三部分，第一部分叫request line, 第二部分叫request header，第三部分是body. header和body之间也有个空行， 结构如下图 ![http_request_header](/static/uploads/2012/04/http_request_header.png)   HTTP/version-number表示HTTP协议的版本号， status-code 和message 请看下节[[状态代码](http://kb.cnblogs.com/page/130970/#statecode)]的详细解释. 我们用Fiddler 捕捉一个博客园首页的Response然后分析下它的结构， 在Inspectors tab下以Raw的方式可以看到完整的Response的消息， 如下图 ![http_reponse](//static/uploads/2012/04/http_reponse.png)  

## Get和Post方法的区别

Http协议定义了很多与服务器交互的方法，最基本的有4种，分别是GET,POST,PUT,DELETE. 一个URL地址用于描述一个网络上的资源，而HTTP中的GET, POST, PUT, DELETE就对应着对这个资源的查，改，增，删4个操作。 我们最常见的就是GET和POST了。GET一般用于获取/查询资源信息，而POST一般用于更新资源信息. 我们看看GET和POST的区别 1\. GET提交的数据会放在URL之后，以?分割URL和传输数据，参数之间以&相连，如EditPosts.aspx?name=test1&id=123456. POST方法是把提交的数据放在HTTP包的Body中. 2\. GET提交的数据大小有限制（因为浏览器对URL的长度有限制），而POST方法提交的数据没有限制. 3\. GET方式需要使用Request.QueryString来取得变量的值，而POST方式通过Request.Form来获取变量的值。 4\. GET方式提交数据，会带来安全问题，比如一个登录页面，通过GET方式提交数据时，用户名和密码将出现在URL上，如果页面可以被缓存或者其他人可以访问这台机器，就可以从历史记录获得该用户的账号和密码.

## 状态码

Response 消息中的第一行叫做状态行，由HTTP协议版本号， 状态码， 状态消息 三部分组成。 状态码用来告诉HTTP客户端，HTTP服务器是否产生了预期的Response. HTTP/1.1中定义了5类状态码， 状态码由三位数字组成，第一个数字定义了响应的类别 1XX 提示信息 - 表示请求已被成功接收，继续处理
