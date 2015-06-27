---
layout: post
title: 在CentOS上安装Git
date: 2013-12-27 16:14:16
category: 技术
tags: CentOS Git
---

## 在CentOS上安装Git

CentOS的yum源中没有git，只能自己编译安装，现在记录下编译安装的内容，留给自己备忘。

## 安装依赖包
    
    
    yum install curl
    yum install curl-devel
    yum install zlib-devel
    yum install openssl-devel
    yum install perl
    yum install cpio
    yum install expat-devel
    yum install gettext-devel
    

## 下载最新的git包
    
    
    wget http://www.codemonkey.org.uk/projects/git-snapshots/git/git-latest.tar.gz
    tar xzvf git-latest.tar.gz
    cd git-2013-12-27 ＃你的目录可能不是这个
    autoconf
    ./configure
    make
    sudo make install
    

## 检查下安装的版本，大功告成
    
    
    git --version
    

下载地址：<http://codemonkey.org.uk/projects/git-snapshots/git/>
