---
layout: post
title: 通过pelican自带make部署到线上
category: 技术
date: 2014-05-24 18:42:30
tags: make pelican
---

[这里](/note/pelican-install-summary.html)写了如何通过pelican生成静态博客，
那么生成静态博客后如何将其部署到线上环境呢？pelican本身提供了比较多的部署方式。

主要包括以下几种方式：

 1. ssh     主要是通过scp将指定的目录上传到目标服务器(全部)
 2. rsync   通过rsync方式同步数据到服务器
 3. dropbox cp outout目录到dropbox目录，然后通过dronbox目录同步
 4. ftp     这个好理解，就是ftp方式上传文件
 5. s3      通过s3认证同步文件到s3服务器
 6. github  push文件到github

我们这里选择最简单的方式：ssh

首页必须设置好配置文件 publishconf.py，以下是我的配置：

    #!/usr/bin/env python
    # -*- coding: utf-8 -*- #
    from __future__ import unicode_literals

    # This file is only used if you use `make publish` or
    # explicitly specify it as your config file.

    import os
    import sys
    sys.path.append(os.curdir)
    from pelicanconf import *

    SITEURL = 'http://www.lnmp100.com' # 这里要配置为线上的域名
    RELATIVE_URLS = False

    FEED_ALL_ATOM = 'feeds/all.atom.xml'
    CATEGORY_FEED_ATOM = 'feeds/%s.atom.xml'

    DELETE_OUTPUT_DIRECTORY = True

    # Following items are often useful when publishing

    #DISQUS_SITENAME = ""
    #GOOGLE_ANALYTICS = ""

通过执行命令即可将output目录下生成好的文件上传到服务器

    (pelican)➜  blog git:(master) ✗ >make ssh_upload

这个命令主要执行了两个动作:
1、通过make publish 生成静态文件
2、scp静态文件到服务器

当然也可以通过其他方式来实现，选择个自己喜欢的方式就好了。^\_^

注：我这里的ssh认证方式是通过公钥key来认证的，省去每次输入密码的麻烦。
