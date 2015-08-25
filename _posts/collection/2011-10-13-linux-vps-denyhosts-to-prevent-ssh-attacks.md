---
layout: post
title: Linux VPS上DenyHosts阻止SSH暴力攻击
date: 2011-10-13 17:29:17
category: 收藏
tags: VPS DenyHosts SSH暴力攻击
---


现在的互联网非常不安全，很多人没事就拿一些扫描机扫描ssh端口，然后试图连接ssh端口进行暴力破解（穷举扫描），所以建议vps主机的空间,尽量设置复杂的ssh登录密码，虽然在前段时间曾经介绍过Linux VPS禁止某个IP访问使用hosts.deny禁止某些IP访问，但是功能方面欠缺，如：不能自动屏蔽，那么有什么更好的办法吗，就可以使用denyhosts这款软件了，它会分析/var/log/secure（redhat，Fedora Core）等日志文件，当发现同一IP在进行多次SSH密码尝试时就会记录IP到/etc/hosts.deny文件，从而达到自动屏蔽该IP的目的。 DenyHosts官方网站为：<http://denyhosts.sourceforge.net/>   

## 下载DenyHosts 并解压 

> wget <http://soft.vpser.net/security/denyhosts/DenyHosts-2.6.tar.gz>   
> tar zxvf DenyHosts-2.6.tar.gz cd DenyHosts-2.6

## 安装、配置和启动 

> python setup.py install

默认是安装到/usr/share/denyhosts/目录的,进入相应的目录修改配置文件 

> cd /usr/share/denyhosts/ cp denyhosts.cfg-dist denyhosts.cfg cp daemon-control-dist daemon-control

默认的设置已经可以适合centos系统环境，你们可以使用vi命令查看一下denyhosts.cfg和daemon-control，里面有详细的解释 接着使用下面命令启动denyhosts程序 

> chown root daemon-control chmod 700 daemon-control ./daemon-control start

如果要使DenyHosts每次重起后自动启动还需做如下设置： 

> cd /etc/init.d ln -s /usr/share/denyhosts/daemon-control denyhosts chkconfig --add denyhosts chkconfig --level 2345 denyhosts on

或者执行下面的命令，将会修改/etc/rc.local文件： 

> echo "/usr/share/denyhosts/daemon-control start" >> /etc/rc.local

DenyHosts配置文件denyhosts.cfg说明： 

> SECURE_LOG = /var/log/secure

sshd日志文件，它是根据这个文件来判断的，不同的操作系统，文件名稍有不同。 

> HOSTS_DENY = /etc/hosts.deny

控制用户登陆的文件 

> PURGE_DENY = 5m

过多久后清除已经禁止的 

> BLOCK_SERVICE  = sshd

禁止的服务名 

> DENY_THRESHOLD_INVALID = 1

允许无效用户失败的次数 

> DENY_THRESHOLD_VALID = 10

允许普通用户登陆失败的次数 

> DENY_THRESHOLD_ROOT = 5

允许root登陆失败的次数 

> HOSTNAME_LOOKUP=NO

是否做域名反解 

> DAEMON_LOG = /var/log/denyhosts

更多的说明请查看自带的README文本文件，好了以后维护VPS就会省一些心了，但是各位VPSer们注意了安全都是相对的哦，没有绝对安全，请定期或不定期的检查你的VPS主机，而且要定时备份你的数据哦。   

转载于：[VPS侦探](http://www.vpser.net/) 

原文链接地址：<http://www.vpser.net/security/denyhosts.html>