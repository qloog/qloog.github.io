---
layout: post
title: Linux下批量删除.svn目录的命令
date:  2011-11-21 14:04:37
category: 技术
tags: svn
---


在Linux系统下, 可以用一个命令很容易批量删除.svn的文件夹。 通过

	ll -a

可以查看到隐藏文件 .svn

	find . -name .svn -type d -exec rm -fr {} \;

通过执行以上命令后，.svn的所有文件都被删除。 这样将v1分支下的目录拷贝到v2分支下以后，提交v2下的文件就不会有问题存在了。
