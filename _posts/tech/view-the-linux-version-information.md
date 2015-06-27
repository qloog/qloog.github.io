Title: 查看Linux版本信息的几种方法
Date: 2012-01-03 21:24:21
Tags: Linux


下面分别是如何查看内核版本、内核具体信息、Linux版本信息。 cat /proc/version lsb_release -a uname -a cat /etc/issue cat /etc/redhat-release  1、cat /proc/version 

> Linux version 2.6.18-194.el5 (mockbuild@builder16.centos.org) (gcc version 4.1.2 20080704 (Red Hat 4.1.2-48)) #1 SMP Fri Apr 2 14:58:35 EDT 2010

  2、lsb_release -a 

> LSB Version: :core-3.1-ia32:core-3.1-noarch:graphics-3.1-ia32:graphics-3.1-noarch Distributor ID: CentOS Description: CentOS release 5.5 (Final) Release: 5.5 Codename: Final

  3、uname -a 

> Linux centos 2.6.18-194.el5 #1 SMP Fri Apr 2 14:58:35 EDT 2010 i686 i686 i386 GNU/Linux

  4、cat /etc/issue 

> CentOS release 5.5 (Final) Kernel \r on an \m

  5、cat /etc/redhat-release 

> CentOS release 5.5 (Final)

  以上是五中常用的查看内核版本信息的命令，可根据自己需要选择适当的命令。