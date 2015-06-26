Title: CentOS下LAMP的编译安装
Date: 2012-01-04 21:33:08
Tags: CentOS, LAMP


LAMP的安装是做开发人员比较常做的工作，RPM的安装相对比较容易一些，安装的rpm包以及依赖的包都可以在安装光盘里找到，当然也可以在线下载安装，比如mirrors.sohu.com mirrors.163.com里都有。centos下本生支持yum,所以也可以通过yum的方式来安装，安装起来都比较方便，会自动安装安装倚赖包，这里主要介绍下编译安装的方法。  

## 获取相关开源程序
【适用CentOS操作系统】利用CentOS Linux系统自带的yum命令安装、升级所需的程序库（RedHat等其他Linux发行版可从安装光盘中找到这些程序库的RPM包，进行安装）： 
    
    
    sudo -s
    LANG=C
    yum -y install gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers

## apache的下载和安装
  1、检查是否已经安装httpd 

> rpm -qa |grep httpd httpd-2.2.3-31.el5.centos.4 httpd-manual-2.2.3-31.el5.centos.4

如果可以检查到已经安装，需要卸载旧的安装包,命令如下： 
    
    
    rpm -e httpd-2.2.3-43.el5.centos --nodeps

注：如果输入rpm -e httpd-2.2.3-31.el5.centos.4命令，系统会提示你有依赖关系，不能卸载。所以要加上--nodeps不检查依赖强制删除，这个结果就是只删除了httpd，跟他有依赖关系的其它软件是不会删除的，但是这些软件因为系统里没有了httpd也会不能运行，这是所谓的没有删除干净。 而yum -y remove httpd这种方式是把与httpd有依赖关系的所有软件一并删除。比如php，mod_ssl等等。这就干净了。呵呵。 

2、相关软件包的安装 需要下载的包： apr: http://apr.apache.org/download.cgi apr-util: http://apr.apache.org/download.cgi pcre: http://pcre.org/、 http://sourceforge.net/projects/pcre/ \------- 如果不安装会提示如下内容： 
    
    
     ./configure --prefix=/usr/local/apache2 --with-ssl --enable-ssl --enable-so --enable-rewrite
    checking for chosen layout... Apache
    checking for working mkdir -p... yes
    checking build system type... i686-pc-linux-gnu
    checking host system type... i686-pc-linux-gnu
    checking target system type... i686-pc-linux-gnu
    
    Configuring Apache Portable Runtime library ...
    
    checking for APR... no
    configure: error: APR not found. Please read the documentation.

提示缺少apr,那么就需要下载apr,编译安装完成apr后，继续编译apache 安装apr: 
    
    
    tar zxvf apr-1.4.2.tar.gz
    cd apr-1.4.2
    ./configure --prefix=/usr/local/apr
    make
    make install

一般安装apr也需要安装apr-util和pcre 
    
    
    tar zxvf apr-util-1.3.10.tar.gz
    cd apr-util-1.3.10
    ./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr
    make
    make install
    
    tar zxvf pcre-8.11.tar.gz
    cd pcre-8.11
    ./configure --prefix=/usr/local/pcre
    make
    make install

3、httpd软件包的下载 官网地址：<http://www.apache.org/dyn/closer.cgi> 国内下载地址：<http://labs.renren.com/apache-mirror//httpd/>

> wget  http://labs.renren.com/apache-mirror//httpd/httpd-2.3.16-beta.tar.gz(目前最新版) 

4、安装 
    
    
    tar zxvf httpd-2.3.16.tar.gz
    cd httpd-2.3.16
    ./configure --prefix=/usr/local/apache2 --with-ssl --enable-ssl --enable-so --enable-dav --enable-dav-fs --enable-dav-lock
    --enable-rewrite --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-pcre=/usr/local/pcre
    make
    make install

注：   
1、如需启用所有模块可用：`\--enable-mods-shared=all`   
2、一定要加`\--enable-so`是核心能够装载DSO   
3、`\--enable-dav`是安装mod_dav_svn.so跟mod_authz_svn.so这两个模块     
4、将apache设置为开机自启动(两种方法)   
①、 在/etc/rc.d/rc.local 文件中加入一行 

> /url/local/apache2/bin/apachectl start

②、 将apache安装为系统服务 

> cp /usr/local/apache2/bin/apachectl /etc/rc.d/init.d/httpd

> vi /etc/rc.d/init.d/httpd

添加(#！/bin/sh 下面) 

> chkconfig: 2345 10 90

description:Activates/Deactivates Apache Web Server 最后，运行 chkconfig 把apache 添加到系统的启动服务组里面： 
    
    
    chkconfig --add httpd
    chkconfig httpd on

## mysql的下载和安装

1、下载 地址：<http://mirrors.sohu.com/mysql>

> wget http://mirrors.sohu.com/mysql/MySQL-5.1/mysql-5.1.60.tar.gz

2、安装 
    
    
    tar zxvf mysql-5.1.60.tar.gz
    
    cd mysql-5.1.60
    
    ./configure --prefix=/usr/local/mysql --with-comment=Source --with-server-suffix=-enterprise-gpl
    --with-mysqld-user=mysql --with-debug --with-big-tables --with-charset=utf8
    --with-collation=utf8_general_ci --with-extra-charsets=all
    --with-pthread --enable-static --enable-thread-safe-client --with-client-ldflags=-all-static
    --with-mysqld-ldflags=-all-static --enable-assembler --without-ndb-debug
    --enable-local-infile --with-readline
    
    
    groupadd mysql
    useradd -g mysql mysql
    cd /usr/local/mysql
    chown -R msyql . (.代表root)
    chgrp -R mysql .
    bin/mysql_install_db --user=mysql
    chown -R root .
    chown -R mysql var
    cp share/mysql/my-medium.cnf /etc/my.cnf
    cp share/mysql/mysql.server /etc/rc.d/init.d/mysqld
    chmod 755 /etc/rc.d/init.d/mysqld
    chkconfig --add mysqld
    chkconfig --level 3 mysqld on
    /etc/rc.d/init.d/mysqld start(因为mysql服务已经加到了系统服务，所以也可用service mysqld start)

初始化root用户密码： 

> bin/mysqladmin -uroot password 123456

OK，到此mysql 安装成功.   

## PHP5的下载安装

1、下载： 
    
    
    wget http://mirrors.sohu.com/php/php-5.3.3.tar.gz

2、安装，由于之前已经安装过可能需要的安装包，所以这里比较简单些 
    
    
    tar zxvf php-5.3.3.tar.gz
    cd php-5.3.3
    ./configure --prefix=/usr/local/php --with-apxs2=/usr/local/apache2/bin/apxs --with-zlib --with-bz2  --with-gd --enable-gd-native-ttf --enable-gd-jis-conv  --enable-mbstring --with-mysql=/usr/local/mysql --with-iconv --with-curl --enable-static --enable-zend-multibyte --enable-inline-optimization --enable-zend-multibyte --enable-sockets --enable-soap --with-openssl --with-gettext --enable-ftp
    
    make
    make install
    cp /usr/local/src/php-5.3.3/php.ini-recommended /usr/local/php/lib/php.ini

3、整合apache 和 php 查找：AddType application 在其下面加入如下内容： AddType application/x-httpd-php .php AddType application/x-httpd-php-source .phps 
4、重启apache /usr/local/apache2/bin/apachetcl restart 如果报错： 
    
    
     httpd: Syntax error on line 162 of /usr/local/apache2/conf/httpd.conf: Cannot load /usr/local/apache2/modules/libphp5.so into server: /usr/local/apache2/modules/libphp5.so: cannot restore segment prot after reloc: Permission denied

解决方法： 

google了一下基本问题就是SELinux保护模式引起的，找到一个哥们的blog 是这样写的：

①关闭SELINUX的方法: vi /etc/selinux/config 将SELINUX=enforcing 改成SELINUX=disabled 需要重启

②不关闭SELINUX的方法:
    
    
    shell>setenforce 0