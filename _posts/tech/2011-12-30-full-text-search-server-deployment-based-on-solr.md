---
layout: post
title: 基于Solr的全文搜索服务器的安装部署
category: 技术
date: 2011-12-30 15:26:36
tags: Solr
---


![solr-logo](/static/uploads/2011/12/solr-logo.png)

Apache Solr 是一个开源的搜索服务器。Solr 使用 Java 语言开发，主要基于 HTTP 和 Apache Lucene 实现。Apache Solr 中存储的资源是以 Document 为对象进行存储的。每个文档由一系列的 Field 构成，每个 Field 表示资源的一个属性。Solr 中的每个 Document 需要有能唯一标识其自身的属性，默认情况下这个属性的名字是 id，在 Schema 配置文件中使用：id进行描述。 Solr是一个高性能，采用Java5开发，基于Lucene的全文搜索服务器。文档通过Http利用XML加到一个搜索集合中。查询该集合也是通过 http收到一个XML/JSON响应来实现。它的主要特性包括：高效、灵活的缓存功能，垂直搜索功能，高亮显示搜索结果，通过索引复制来提高可用性，提 供一套强大Data Schema来定义字段，类型和设置文本分析，提供基于Web的管理界面等。    在安装Tomcat之前需要安装其运行环境JDK

## 一、JDK的下载与安装

### 1、下载

官网下载地址：<http://www.oracle.com/technetwork/java/javase/downloads/jdk-6u30-download-1377139.html>
下载自解压包：jdk-6u30-linux-i586.bin

### 2、安装

修改 jdk-6u30-linux-i586.bin 文件的权限为可执行：

	chmod +x  jdk-6u30-linux-i586.bin

解压：

	./jdk-6u30-linux-i586.bin

将解压后的目录 jdk1.6.0_30 移至 /usr/local下

	mv  jdk1.6.0_30  /usr/local/

### 3、添加JAVA环境变量

在/etc/profile里加入如下代码：

	vim /etc/profile

	export JAVA_HOME=/usr/local/jdk1.6.0_30 export JAVA_BIN=/usr/local/jdk1.6.0_30/bin export PATH=$PATH:$JAVA_HOME/bin export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar export JAVA_HOME JAVA_BIN PATH CLASSPATH

###  4、使环境变量生效

	source /etc/profile

### 5、查看安装版本

	java  -version

如得到如下结果，说明安装成功

	java version "1.6.0_30" Java(TM) SE Runtime Environment (build 1.6.0_30-b03) Java HotSpot(TM) Client VM (build 20.1-b02, mixed mode, sharing)

到此，JDK安装成功。接下来安装Tomcat容器。  

## 二、Tomcat的下载与安装

官网地址：<http://tomcat.apache.org/>

### 1、下载

	wget http://mirror.bjtu.edu.cn/apache/tomcat/tomcat-6/v6.0.35/bin/apache-tomcat-6.0.35.tar.gz

### 2、安装

	tar zxvf  apache-tomcat-6.0.35.tar.gz mv apache-tomcat-6.0.35  /opt/ cd /opt/ mv apache-tomcat-6.0.35  tomcat6

### 3、tomcat环境变量配置(可选)

	vim /etc/profile

加入以下代码：

	export TOMCAT_HOME=/opt/tomcat6

使配置生效

	source /etc/profile

### 4、启动Tomcat

	/usr/local/tomcat/bin/startup.sh

启动提示：

	Using CATALINA_BASE: /opt/tomcat6 Using CATALINA_HOME: /opt/tomcat6 Using CATALINA_TMPDIR: /opt/tomcat6/temp Using JRE_HOME: /usr/local/jdk1.6.0_30 Using CLASSPATH: /opt/tomcat6/bin/bootstrap.jar

### 5、打开浏览器输入：http://locaohost:8080 能打开，说明可以访问

到此，Tomcat安装完毕。 Solr的准备工作已经完成，接下来开始功能强大的Solr的部署。  

## 三、Solr的部署

Solr 官网地址：<http://lucene.apache.org/solr/>

### 1、下载

下载地址：<http://www.apache.org/dyn/closer.cgi/lucene/solr/> 提供了很多下载镜像
国内下载地址：<http://labs.renren.com/apache-mirror//lucene/solr/>  这个更新速度也是很快的 目前的最新版本为3.5.0，这里我安装3.2.0版

	wget http://labs.renren.com/apache-mirror/lucene/solr/3.2.0/apache-solr-3.2.0.zip

### 2、安装

解压：

	unzip apache-solr-3.2.0.zip

移动到/opt目录下

	mkdir -p /opt/solr cp  apache-solr-3.2.0/example/solr /opt/solr/

###  3、配置

	cp apache-solr-3.2.0/example/webapps/solr.war  /opt/tomcat6/webapps/ vim /opt/tomcat/conf/server.xml

找到如下代码

	<Connector executor="tomcatThreadPool"  port="8080" protocol="HTTP/1.1"  connectionTimeout="20000"  redirectPort="8443" />

替换为：

	<Connector port="8983" maxHttpHeaderSize="8192" maxThreads="150" minSpareThreads="25" maxSpareThreads="75" enableLookups="false" redirectPort="8443" acceptCount="100" connectionTimeout="20000" disableUploadTimeout="true" URIEncoding="UTF-8" />

	vim /opt/tomcat/conf/Catalina/localhost/solr.xml

加入以下代码，如果没有则新建立

	<?xml version="1.0" encoding="UTF-8"?> <Context docBase="/opt/tomcat6/webapps/solr.war" debug="0" crossContext="true" > <Environment name="solr/home" type="java.lang.String" value="/opt/solr/solr" override="true" /> </Context>

### 4、启动Solr

	/opt/tomcat6/bin/startup.sh

浏览地址：http://localhost:8983/solr/admin
如图： ![solr_install_success-300x150](/static/uploads/2011/12/solr_install_success-300x150.jpg)
OK，Solr全文搜索服务器安装成功。
现在是不是想使用solr来实现具体的搜索呢，不急，下篇文章会介绍如何用solr 来实现搜索服务。
