---
layout: post
title: MySQL for Python安装详解
date: 2012-11-22 20:32:53
category: 技术
tags: MySQL Python
---

在Python环境下，如果想操作MySQL数据库，难免会调用相应的包，比如常用的：MySQLdb

通过导入：import MySQLdb  后，可直接调用里面的方法。  
默认情况下，MySQLdb包是没有安装的，不信？ 看到类似下面的代码你就信了。 
    
    
    -bash-3.2# /usr/local/python2.7.3/bin/python get_cnblogs_news.py 
    Traceback (most recent call last):
      File "get_cnblogs_news.py", line 9, in <module>
        import MySQLdb
    ImportError: No module named MySQLdb

  

这时我们就不得不安装MySQLdb包了。安装其实也挺简单，具体步骤如下：

### 下载 MySQL for Python 

   地址：<http://sourceforge.net/projects/mysql-python/files/mysql-python/>  


  我这里安装的是1.2.3版本 
    
    wget http://sourceforge.net/projects/mysql-python/files/mysql-python/1.2.3/MySQL-python-1.2.3.tar.gz

### 解压 
    
    tar zxvf MySQL-python-1.2.3.tar.gz

### 安装    
    
    $ cd MySQL-python-1.2.3
    $ python setup.py build
    $ python setup.py install

注： 

如果在执行：python setup.py build 遇到以下错误：

EnvironmentError: mysql_config not found  

首先查找mysql_config的位置，使用

find / -name mysql_config ，比如我的在/usr/local/mysql/bin/mysql_config  
  
修改setup_posix.py文件，在26行：  
mysql_config.path = "mysql_config" 修改为：  
mysql_config.path = "/usr/local/mysql/bin/mysql_config"  


保存后，然后再次执行：
    
    python setup.py build
    python setup.py install

OK，到此大功告成，如果还有问题，可以留言来讨论。
