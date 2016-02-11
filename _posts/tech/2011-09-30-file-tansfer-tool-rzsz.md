---
layout: post
title: Linux系统下的RZSZ（文件传输工具）
category: 技术
date: 2011-09-30 22:35:28
tags: RZSZ
---

Linux系统下传输方式很多，比如：通过FTP SFTP … 等等。  

linux服务器大多是通过ssh客户端来进行远程的登陆和管理的，使用ssh登陆linux主机以后，如何能够快速的和本地机器进行文件的交互呢，也就是上传和下载文件到服务器和本地，根据RZSZ特性，
这里我们通过SecureCRT提供ZModem配合RZSZ传输工具进行讲解。

首先先了解与ssh有关的两个命令可以提供很方便的操作：  
    sz：将选定的文件发送（send）到本地机器  
    rz：运行该命令会弹出一个文件选择窗口，从本地选择文件上传到Linux服务器  
    
 rz，sz是Linux/Unix同Windows进行ZModem文件传输的命令行工具
 
 windows端需要支持ZModem的telnet/ssh客户端，例如：SecureCRT
 
 优点：比ftp命令方便，而且服务器不用打开FTP服务。
 
 安装 rzsz软件包

	 [root@localhost soft]# wget http://freeware.sgi.com/source/rzsz/rzsz-3.48.tar.gz 
	–2010-01-07 21:52:51– http://freeware.sgi.com/source/rzsz/rzsz-3.48.tar.gz
	正在解析主机 freeware.sgi.com… 192.48.178.134
	Connecting to freeware.sgi.com|192.48.178.134|:80… 已连接。
	已发出 HTTP 
	请求，正在等待回应… 200 OK
	长度：65566 [application/x-gzip]
	Saving to: `rzsz-3.48.tar.gz’
	100%[======================================>] 65,566     20.2K/s   in 3.2s    
	2010-01-07 21:52:56 (20.2 KB/s) – `rzsz-3.48.tar.gz’ saved [65566/65566]
	
	[root@localhost soft]# ll
	总计 72
	-rw-r–r– 1 root root 65566 2004-05-19 rzsz-3.48.tar.gz
	[root@localhost soft]# tar zxvf rzsz-3.48.tar.gz 
	src/
	src/COPYING
	src/Makefile
	src/README
	src/crc.c
	src/crc.doc
	src/crctab.c
	src/gz
	src/mailer.rz
	src/minirb.c
	src/minirb.doc
	src/rbsb.c
	src/rz.c
	src/rz.doc
	src/sz.c
	src/sz.doc
	src/undos.c
	src/undos.doc
	src/zm.c
	src/zmodem.h
	src/zmr.c
	src/zupl.t  
	[root@localhost soft]# cd src/
	[root@localhost src]# ll
	总计 256
	-rw-rw-r– 1 10127 wheel  891 1998-05-30 COPYING
	-rw-r–r– 1 10127 wheel 8815 1998-05-30 crc.c
	-rw-r–r– 1 10127 wheel 1492 1998-05-30 crc.doc
	-rw-r–r– 1 10127 wheel 8764 1998-05-30 crctab.c
	-rw-r–r– 1 10127 wheel   22 1998-05-30 gz
	-rw-rw-r– 1 10127 wheel 3617 1998-05-30 mailer.rz
	-rw-r–r– 1 10127 wheel 8657 1998-05-30 Makefile
	-rw-r–r– 1 10127 wheel 2868 1998-05-30 minirb.c
	-rw-r–r– 1 10127 wheel 2727 1998-05-30 minirb.doc
	-rw-r–r– 1 10127 wheel 10537 1998-05-30 rbsb.c
	-rw-r–r– 1 10127 wheel 6164 1998-05-30 README
	-rw-r–r– 1 10127 wheel 29902 1998-05-30 rz.c
	-rw-rw-r– 1 10127 wheel 19264 1998-05-30 rz.doc
	-rw-r–r– 1 10127 wheel 37258 1998-05-30 sz.c
	-rw-rw-r– 1 10127 wheel 25679 1998-05-30 sz.doc
	-rw-r–r– 1 10127 wheel 7312 1998-05-30 undos.c
	-rw-rw-r– 1 10127 wheel 4282 1998-05-30 undos.doc
	-rw-r–r– 1 10127 wheel 17736 1998-05-30 zm.c
	-rw-r–r– 1 10127 wheel 6577 1998-05-30 zmodem.h
	-rw-r–r– 1 10127 wheel 4519 1998-05-30 zmr.c
	-rw-r–r– 1 10127 wheel  738 1998-05-30 zupl.t
	
rzsz的软件包比较特别，没有`configure及make install` 文件。执行`make`命令可以看到一些提示

	[root@localhost src]# make
	Please study the #ifdef’s in crctab.c, rbsb.c, rz.c and sz.c,
	make any necessary hacks for oddball or merged SYSV/BSD systems,
	then type ‘make SYSTEM’ where SYSTEM is one of:
	      posix   POSIX compliant systems
	      aix     AIX systems
	      next    NeXtstep v3.x (POSIX)
	      odt     SCO Open Desktop
	      everest SCO Open Desktop (elf, strict)
	      sysvr4  SYSTEM 5.4 Unix
	      sysvr3  SYSTEM 5.3 Unix with mkdir(2), COHERENT 4.2
	      sysv    SYSTEM 3/5 Unix
	      sysiii  SYS III/V  Older Unix or Xenix compilers
	      xenix   
	Xenix
	      x386    386 Xenix
	      bsd     Berkeley 4.x BSD, Ultrix, V7
	      tandy   Tandy 6000 Xenix
	      dnix    DIAB Dnix 5.2
	      dnix5r3 DIAB Dnix 5.3
	      amiga   3000UX running SVR4
	      POSIX   POSIX compliant systems (SCO Open Desktop, strict)
	      undos   Make the undos, todos, etc. program.
	      doc     Format the man pages with nroff
	      
根据自己的需求选择make参数，一般选posix就可以

	[root@localhost src]# make posix
	cc
	 -O -DPOSIX -DMD=2 rz.c -o rz
	size rz
	 text    data     bss     dec     hex filename
	 31339    1088   10640   43067    a83b rz
	rm -f rb rx rc
	ln rz rb
	ln rz rx
	ln rz rc
	cc  -O -DPOSIX sz.c -o sz
	size sz
	 text    
	data    bss     dec     hex filename
	 37316    1224   43344   81884   13fdc sz
	rm -f sb sx zcommand zcommandi
	ln sz sb
	ln sz sx
	ln sz zcommand       ===============》提示安装成功
	ln sz zcommandi
	[root@localhost src]# cp rz sz /usr/bin/ 复制到/usr/bin下方便使用
	[root@localhost src]# rz  上传本地文件到linux系统下
	rz ready. Type “sz file …” to your modem program
	
提示如下图片：

	< ?xml:namespace prefix = v ns = “urn:schemas-microsoft-com:vml” />
	Starting zmodem transfer. Press Ctrl C to cancel.
	Transferring 1.txt…
	Transferring 1.txt…
	?rz 3.48 01-27-98 finished.
	**** UNREGISTERED COPY *****
	Please read the License Agreement in rz.doc
	
提醒：如果Upload files as ASCII打√的话，你上传的文件的MD5值会有问题，那么应用文件也就不能运行.

	[root@localhost ~]# ll
	总计 56
	-rw-r–r– 1 root root    0 01-06 16:07 1.txt
	-rw——- 1 root root  894 12-02 19:22 anaconda-ks.cfg
	-rw-r–r– 1 root root 1585 12-02 19:22 init.sh
	-rw-r–r– 1 root root 20758 12-02 19:22 install.log
	-rw-r–r– 1 root root 3497 12-02 19:22 install.log.syslog
	drwxr-xr-x 3 root root 4096 01-07 21:53 soft
	
上传文件所在的位置是执行rz命令时所在的目录

	[root@localhost ~]# sz soft/rzsz-3.48.tar.gz  下载linux下文件到本地
	rz
	Starting zmodem transfer. Press Ctrl C to cancel.
	Transferring rzsz-3.48.tar.gz…
	 100%
	    64 KB   64 KB/s 00:00:01       0 Errors
	rzsz 3.48 01-27-98 finished.
	
	**** UNREGISTERED COPY *****
	Please read the License Agreement in sz.doc


下载文件所在的位置是在`SecureCRT–Options—session options–X/Y/Zmodem`
项默认路径是：`C:\Users\Administrator\Downloads` 这个自己定义修改

总结：一个小小的插件可以给我们的工作带来不少欢喜，大家要好好利用哦！