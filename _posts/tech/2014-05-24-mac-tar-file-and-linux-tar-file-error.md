---
layout: post
title: mac下tar压缩文件上传到centos解压时出错
date: 2014-05-24 23:32:57
update: 2014-05-25 17:00
category: 技术
tags: tar gnu-tar
---

在用fabric的程序自动发布脚本时，本地打包的文件在服务器端解压时报了下面的错

    tar: Ignoring unknown extended header keyword 'SCHILY.dev'
    tar: Ignoring unknown extended header keyword 'SCHILY.ino'
    tar: Ignoring unknown extended header keyword 'SCHILY.nlink'

本机查看一下`tar --help`发现tar是bsdtar, 服务器(Centos)上是gnutar，
原来tar还分版本，好吧，是我外行了。

查了下发现苹果是在 Maverick (Mac OSX 10.9) 版本才开始移除的gnutar, 原因暂不清楚，
有清楚的可以告诉我。
PS: 我的刚好是Mac OSX 10.9

报错的原因也是因为Apple的bsdtar 和linux下的gnutar 不兼容导致。

那就开始安装apple的tar吧：

    sudo brew install gnu-tar
    which gnutar  #显示 /opt/local/bin/gnutar

为了不影响原来的tar，我这里暂不会替换原来的/usr/bin/tar, 而是用gnutar来打包，错误解决。

安装过程中出现的问题

    ➜  ~  >sudo brew install gnu-tar
    Password:
    ==> Downloading http://ftpmirror.gnu.org/tar/tar-1.26.tar.gz
    Already downloaded: /Library/Caches/Homebrew/gnu-tar-1.26.tar.gz
    ==> ./configure --prefix=/usr/local/Cellar/gnu-tar/1.26 --mandir=/usr/local/Cellar/gnu-tar/1.26/share/man --program-prefix=g
    checking for mkdtemp... yes
    checking whether mkfifo rejects trailing slashes... no
    checking whether mknod can create fifo without root privileges... configure: error: in `/private/tmp/gnu-tar-M7MI/tar-1.26':
    configure: error: you should not run configure as root (set FORCE_UNSAFE_CONFIGURE=1 in environment to bypass this check)
    See `config.log' for more details.
    Error: Homebrew doesn't know what compiler versions ship with your version
    of Xcode (5.0.2). Please `brew update` and if that doesn't help, file
    an issue with the output of `brew --config`:
      https://github.com/mxcl/homebrew/issues

    Thanks!

    READ THIS: https://github.com/mxcl/homebrew/wiki/troubleshooting

根据提示执行 `brew update` 问题依旧，折腾了半天，还木有解决，知道的请告诉我吧，谢谢了~
所以暂时只能先scp上去了，文件多时比较慢。。。


## 参考链接

[mac下tar压缩文件上传到ubuntu解压时出错](http://jser.me/2012/11/18/mac%E4%B8%8Btar%E5%8E%8B%E7%BC%A9%E6%96%87%E4%BB%B6%E4%B8%8A%E4%BC%A0%E5%88%B0ubuntu%E8%A7%A3%E5%8E%8B%E6%97%B6%E5%87%BA%E9%94%99.html)
