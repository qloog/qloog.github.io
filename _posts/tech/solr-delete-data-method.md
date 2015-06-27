Title: Solr 删除数据的几种方式
Date: 2011-12-31 16:13:21
Tags: Solr


有时候需要删除 Solr 中的数据(特别是不重做索引的系统中，在重做索引期间)。删除一些 Solr 无效数据(或不合格数据)。 

删除 solr 中的数据有几种方式： 

## 1、先来看 curl 方式
    
    
    curl http://localhost:8080/solr/update --data-binary "<delete><query>title:abc</query></delete>" -H 'Content-type:text/xml; charset=utf-8'  
    
    #删除完后，要提交  
    
    curl http://localhost:8080/solr/update --data-binary "<commit/>" -H 'Content-type:text/xml; charset=utf-8'

 

## 2、用自带的 post.jar
在 apache-solr-XXX\example\exampledocs 目录下：
    
    
    java -Ddata=args  -jar post.jar "<delete><id>42</id></delete>"  
    
    #怎么使用 post.jar 查看帮助  
    
    java -jar post.jar -help

 java -jar post.jar -help 查看的结果为：

	[root@localhost solr]# java -jar post.jar -help
	SimplePostTool: version 1.3
	This is a simple command line tool for POSTing raw data to a Solr
	port. Data can be read from files specified as commandline args,
	as raw commandline arg strings, or via STDIN.
	Examples:
	java -Ddata=files -jar post.jar *.xml
	java -Ddata=args -jar post.jar ‘<delete><id>42</id></delete>’
	java -Ddata=stdin -jar post.jar < hd.xml
	Other options controlled by System Properties include the Solr
	URL to POST to, the Content-Type of the data, whether a commit
	should be executed, and whether the response should be written
	to STDOUT. These are the defaults for all System Properties…
	-Ddata=files
	-Dtype=application/xml
	-Durl=http://localhost:8983/solr/update
	-Dcommit=yes
	-Dout=no

## 3、直接用 url
使用 stream 相关参数：

比如： http://localhost:8080/solr/update/?stream.body=123&stream.contentType=text/xml;charset=utf-8&commit=true 
stream 相关参数还有：
stream.file=(服务器本地文件)，  
stream.url 分别指到你的删除文本，这里是直接字符串内容用   
stream.body 参数。commit 参数是指提交，提交了才能看到删除效果。   

小结：其实，方式1、2原理一样，直接 POST xml 数据过去。方式3就是直接可以告诉服务器从那些地方取删除的 xml 内容。   
删除指令有两种，
一是：用包装;  
二是：包装。  
指令都很明显，一个是 id 值(是在 schema.xml 的 uniqueKey 所指字段的值，而不是索引内部的 docId);query 值是查询串，如：title:"solr lucene"。   

## 参考阅读
  * <http://blog.chenlb.com/2010/03/solr-delete-data.html>