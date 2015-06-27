---
layout: post
title: Mac OSX下brew安装python 报错
date:  2014-05-16 14:13
category: 技术
tags: brew, Mac OSX, python
---


准备在Mac OSX 下通过brew安装pip, 以方便本地python开发。安装过程中遇到了一些问题，整理如下：

安装pip
➜  mine  >brew install pip
Error: No available formula for pip
pip is installed by `brew install python`

根据提示执行

    ➜  mine  >sudo brew install python
    Password:
    Error: Cowardly refusing to `sudo brew install'
    You can use brew with sudo, but only if the brew executable is owned by root.
    However, this is both not recommended and completely unsupported so do so at
    your own risk.`

通过owned by root 发现需要root权限，经过查看发现目前不是root权限

    ➜  mine  >ll /usr/local/bin/brew
    -rwxr-xr-x  1 wanglong  wheel  703  5  5  2013 /usr/local/bin/brew

赋予root权限

    ➜  mine  >sudo chown root:wheel /usr/local/bin/brew

查看效果

    ➜  mine  >ll /usr/local/bin/brew
    -rwxr-xr-x  1 root  wheel  703  5  5  2013 /usr/local/bin/brew

再次执行安装，解决

    ➜  mine  >brew install python






