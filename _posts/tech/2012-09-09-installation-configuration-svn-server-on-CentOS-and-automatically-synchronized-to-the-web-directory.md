---
layout: post
title: CentOS下安装配置SVN服务器并自动同步到web目录
date: 2012-09-09 16:22:02
category: 技术
tags: CentOS SVN
---

## 安装
    
    yum install subversion

测试是否安装成功 
    
    
    /usr/bin/svnserve --version

如提示以下内容，说明已安装成功 
    
    
    svnserve，版本 1.6.11 (r934486)
    编译于 May 14 2012，05:36:26
    
    版权所有 (C) 2000-2009 CollabNet。
    Subversion 是开放源代码软件，请参阅 http://subversion.tigris.org/ 站点。
    此产品包含由 CollabNet(http://www.Collab.Net/) 开发的软件。
    
    下列版本库后端(FS) 模块可用:
    
    * fs_base : 模块只能操作BDB版本库。
    * fs_fs : 模块与文本文件(FSFS)版本库一起工作。
    
    Cyrus SASL 认证可用。

## 配置 
	
1. 新建一个目录：repos,可用于存储SVN所有文件 
    
    
    mkdir -p /opt/svn/repos

2. 新建一个版本仓库 
    
    
    svnadmin create /opt/svn/repos

3. 初始化版本仓库中的目录 
    
    
    mkdir project project/server project/client project/test(临时目录)
    svn import project/ file:///opt/svn/repos/project -m '初始化svn目录'
    rm -rf project (可选 如果project没用，可以删除)

4. 修改svn版本库的配置文件 vim /opt/svn/repos/conf/svnserve.conf 修改为如下内容： 
    
    
    [general]
    anon-access = none
    auth-access = write
    password-db = /opt/svn/project/conf/passwd
    authz-db = /opt/svn/project/conf/authz
    realm = LAMP100 repos

注重：对用户配置文件的修改立即生效，不必重启svn。 

5. 添加用户 要添加SVN用户非常简单，只需在/opt/svn/project/conf/passwd文件添加一个形如“username=password"的条目就可以了.为了测试，我添加了如下内容: 
    
    
    [users]
    # harry = harryssecret
    # sally = sallyssecret
    pm = pm_pw
    server_group = server_pw
    client_group = client_pw
    test_group = test_pw

6. 修改用户访问策略 /opt/svn/project/conf/authz记录用户的访问策略，以下是参考: 
    
    
    [groups]
    project_p = pm
    project_s = server_group
    project_c = client_group
    project_t = test_group
    
    [project:/]
    @project_p = rw
    * =
    
    [project:/server]
    @project_p = rw
    @project_s = rw
    * =
    
    [project:/client]
    @project_p = rw
    @project_c = rw
    * =
    
    [project:/doc]
    @project_p = rw
    @project_s = rw
    @project_c = rw
    @project_t = rw
    * =

以上信息表示，只有pm有根目录的读写权，server_group能访问server目录，client_group能访问client目录，所有人都可以访问doc目录. 

7. 启动svn服务 
    
    
    svnserve -d --listen-port 9999 -r /opt/svn (以root用户在运行)

8. 测试svn服务器 
    
    
    cd /web/
    svn co svn://192.168.10.10/repos/project
    Authentication LAMP100 repos: <svn://192.168.10.10:9999> 92731041-2dae-4c23-97fd-9e1ed7f0d18d
    Password for 'root':
    Authentication LAMP100 repos: <svn://192.168.10.10:9999> 92731041-2dae-4c23-97fd-9e1ed7f0d18d
    Username: server_group
    Password for 'server_group':
    svn: Authorization failed ( server_group没用根目录的访问权 )
    
    # svn co svn://192.168.10.10/repos/project
    Authentication LAMP100 repos: <svn://192.168.10.10:9999> 92731041-2dae-4c23-97fd-9e1ed7f0d18d
    Password for 'root':
    Authentication LAMP100 repos: <svn://192.168.10.10:9999> 92731041-2dae-4c23-97fd-9e1ed7f0d18d
    Username: pm
    Password for 'pm':
    A project/test
    A project/server
    A project/client
    Checked out revision 1. ( 测试提取成功 )
    
    # cd project/server
    # vim index.php
    # svn add index.php
    # svn commit index.php -m "测试一下我的PHP程序"
    Adding index.php
    Transmitting file data .
    Committed revision 2. ( 测试提交成功 )

## 配置post-commit，实现自动同步svn版本库文件到web目录** 为了可以在修改完代码提交到SVN服务器后,WEB服务器直接同步.需要配置SVN的钩子,打开hooks目录, 可以看到有一个post-commit.tmpl文件,这是一个模板文件, 复制一份放在此目录下,命名为post-commit，并将其用户组设为www,并设置为可执行： 
    
    
    chown www:www post-commit
    chmod +x post-commit

这样就有了访问www目录的权限。 里面原有的代码全部注释掉.这里可以执行shell命令,每次commit完成后都会调用此文件. 我的文件内容为: 
    
    
    #!/bin/sh
    #设定环境变量，如果没有设定可能会出现update报错
    export LANG=zh_CN.UTF-8
    REPOS="$1"
    REV="$2"
    SVN_PATH=/usr/bin/svn
    WEB_PATH=/web/project
    LOG_PATH=/tmp/svn_update.log
    #/usr/bin/svn update --username user --password password $WEB_PATH --no-auth-cache
    echo "\n\n\n##########开始提交 " `date "+%Y-%m-%d %H:%M:%S"` '##################' >> $LOG_PATH
    echo `whoami`,$REPOS,$REV >> $LOG_PATH
    $SVN_PATH update --username user --password password $WEB_PATH --no-auth-cache >> $LOG_PATH
    chown -R www:www $WEB_PATH

说明: 
1. #!/bin/sh 说明是执行shell命令 
2. export LANG=zh_CN.UTF-8 是为了解决svn post commit 中文乱码。 如果你是GBK编码可能会提示：Error output could not be translated from the native locale to UTF-8 这是客户端和服务器编码的问题，默认是utf-8,可尝试设置export LANG=zh_CN.GBK或者export LANG=en_US.UTF-8 #执行更新操作 
3. svn update --username 你版本库的用户名 --password 用户名的密码 svn://你的IP地址:端口/repos/project /web/project 
4. chown -R www:www $WEB_PATH 更改文件夹属主为适合Web Server的 里面原有的代码全部注释掉.这里可以执行shell命令,每次commit完成后都会调用此文件。 

## 参考资料： 
<http://lxy.me/centos-install-and-configure-the-subversion-server-and-auto-the-release.html> 
<http://www.cnblogs.com/wrmfw/archive/2011/09/08/2170465.html>
<http://www.ccvita.com/383.html>
