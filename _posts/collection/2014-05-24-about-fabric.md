---
layout: post
title: Fabric 部署工具
category: 收藏
date: 2014-05-24 21:14:50
Tags: Fabric
---


![fabric](/static/uploads/2014/05/fabric-introduct.jpeg)

Fabric 是基于 SSH 协议的 Python 工具，相比传统的 ssh/scp 方式，用 Python 的语法写管理命令更易读也更容易扩展，管理单台或者多台机器犹如本地操作一般。

官网地址：<http://fabfile.org> 安装方法这里不在说明，推荐使用：pip 或者 easy_install 来安装。

## 传统维护方法：

    $ ssh x.x.x.x 'uname -a' -- 输出略
    Fabric 示例：

    $ cat fabfile.py
    from fabric.api import run
    def uname():
        run('uname -a')
    $ fab -H x.x.x.x uname -- 输出略

肉眼直观看上去，貌似比 ssh 方式要写不少代码，但是基于 ssh 方式中间可控环节比较少，例如：你想判断某服务是否已经启动，没有启动则执行启动等等操作。ssh 命令式的做法稍显麻烦。（当然龌龊一点可以在被操作机器上写好一个脚本，ssh 调用这个脚本）

## 说几个 Fabric 的优点吧：

 * 角色定义
 * 代码易读
 * 封装了本地、远程操作（还需要自己封装system/popen/ssh操作么？）
 * 参数灵活（动态指定 host/role 等，还有并发执行 基于multiprocessing ）
 * 完整的日志输出

罗列的这些，其实日常工作里基本都有类似的封装了，但是有现成的一个成熟的工具，干啥不用呢？对吧。

## 常用的配置：

    env.host           -- 主机ip，当然也可以-H参数指定
    env.password       -- 密码，打好通道的请无视
    env.roledefs       -- 角色分组，比如：{'web': ['x', 'y'], 'db': ['z']}

    fab -l             -- 显示可用的task（命令）
    fab -H             -- 指定host，支持多host逗号分开
    fab -R             -- 指定role，支持多个
    fab -P             -- 并发数，默认是串行
    fab -w             -- warn_only，默认是碰到异常直接abort退出
    fab -f             -- 指定入口文件，fab默认入口文件是：fabfile/fabfile.py

更多请参考：`fab --help`

## 常用的函数：

    local('pwd')                     -- 执行本地命令
    lcd('/tmp')                      -- 切换本地目录
    cd('/tmp')                       -- 切换远程目录
    run('uname -a')                  -- 执行远程命令
    sudo('/etc/init.d/nginx start')  -- 执行远程sudo，注意pty选项

## 示例1：管理远程 nginx 服务

    $ cat fabfile.py
    from fabric.api import *
    @task
    def nginx_start():
        ''' nginx start '''
    sudo('/etc/init.d/nginx start')

    @task
    def nginx_stop():
        ''' nginx stop '''
        sudo('/etc/init.d/nginx stop')

    $ fab --list      -- 查看可用命令
    Available commands:

    nginx_start  nginx start
    nginx_stop   nginx stop

    $ fab -H x.x.x.x nginx_start  -- 启动 nginx

## 示例2：基于角色

    $ cat fabfile.py
    from fabric.api import *
    env.roledefs = {'nginx': ['x.x.x.x', 'y.y.y.y'], 'mysql': 'z.z.z.z'}
    @task
    def mysql_start()
        ''' mysql start '''
        sudo('/etc/init.d/mysql start')

    $ fab --list      -- 查看可用命令
    Available commands:

    nginx_start  nginx start
    nginx_stop   nginx stop
    mysql_start  mysql start

    $ fab -R nginx nginx_start  -- 启动 nginx
    $ fab -R mysql mysql_start  -- 启动 mysql

## 示例3：混合本地和远程操作

    $ cat fabfile
    def hello():
        ''' test hello '''
        with lcd('/tmp'):  # 切换到 /tmp 目录下
            local('svn co http://xxx xxx') # check 代码到本地
            local('tar czf xxx.tar.gz xxx/') # 压缩本地包
            put('xxx.tar.gz', '/tmp') # 上传压缩包到远程 /tmp 目录下
        with cd('/tmp'):   # 切换到远程 /tmp 目录
            run('tar zxf xxx.tar.gz') # 远程解压

是不是看上去都是像本地一样？对吧。

## 参考链接
 * 原文：<http://chenxiaoyu.org/2012/08/30/deploy-with-fabric.html>
 * [使用Fabric部署网站应用](http://www.liaoxuefeng.com/article/001373892650475818672edc83c4c978a45195eab8dc753000)
 * [官方文档](http://docs.fabfile.org/en/1.8/)
 * [使用Fabric部署](http://docs.jinkan.org/docs/flask/patterns/fabric.html#)
