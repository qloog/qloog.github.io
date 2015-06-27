Title: Linux下svn批量提交的命令
Date: 2011-11-21 14:15:45
Tags: svn

非常简单的一条命令：

> svn add * --force && svn ci -m '替换为自己提交时的注释'
