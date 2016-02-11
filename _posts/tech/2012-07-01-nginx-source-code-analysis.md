---
layout: post
title: Nginx源代码分析【推荐】
date: 2012-07-01 20:35:55
category: 技术
tags: Nginx 源码分析
---

NginxCodeReview  :

地址：<http://code.google.com/p/nginxsrp/wiki/NginxCodeReview>

  * [概述](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#概述)
  * [研究计划](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#研究计划)
  * [参与人员](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#参与人员)
  * [研究文档](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#研究文档)
    * [学习emiller的文章](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#学习emiller的文章)
    * [熟悉nginx的基本数据结构](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#熟悉nginx的基本数据结构)
      * [nginx 代码的目录结构](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#nginx_代码的目录结构)
      * [nginx简单的数据类型的表示](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#nginx简单的数据类型的表示)
      * [nginx字符串的数据类型的表示](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#nginx字符串的数据类型的表示)
      * [内存分配相关](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#内存分配相关)
        * [系统功能封装](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#系统功能封装)
        * [ngx的内存池](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#ngx的内存池)
      * [ngx的基本容器](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#ngx的基本容器)
        * [ngx_array](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#ngx_array)
        * [ngx_queue](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#ngx_queue)
        * [ngx_hash](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#ngx_hash)
        * [ngx_list](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#ngx_list)
    * [了解nginx的core module 的结构和运行机制](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#了解nginx的core_module_的结构和运行机制)
      * [参考资料](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#参考资料)
      * [Debug信息的输出](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#Debug信息的输出)
      * [ngx_init_cycle](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#ngx_init_cycle)
    * [了解nginx的http module 的结构和运行机制](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#了解nginx的http_module_的结构和运行机制)
      * [ngx_http.[c|h]](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#ngx_http.\[c|h\])
      * [ngx_http_request.[c|h]](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#ngx_http_request.\[c|h\])
      * [ngx_http_core_module.[c|h]](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#ngx_http_core_module.\[c|h\])
      * [关于subrequest](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#关于subrequest)
      * [关于 internal redirect](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#关于_internal_redirect)
      * [关于upstream](http://code.google.com/p/nginxsrp/wiki/NginxCodeReview#关于upstream)
