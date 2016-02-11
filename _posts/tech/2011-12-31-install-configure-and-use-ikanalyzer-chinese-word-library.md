---
layout: post
title: IKAnalyzer中文分词库的安装、配置和使用
category: 技术
date: 2011-12-31 10:57:44
tags: IKAnalyzer 中文分词
---


IKAnalyzer是一个开源的，基于java语言开发的轻量级的中文分词工具包。从2006年12月推出1.0版开始，IKAnalyzer已经推出了3个大版本。最初，它是以开源项目Luence为应用主体的，结合词典分词和文法分析算法的中文分词组件。新版本的IKAnalyzer3.0则发展为面向Java的公用分词组件，独立于Lucene项目，同时提供了对Lucene的默认优化实现。    

IKAnalyzer3.0特性: 采用了特有的“正向迭代最细粒度切分算法“，支持细粒度和最大词长两种切分模式;具有83万字/秒(1600KB/S)的高速处理能力。 采用了多子处理器分析模式，支持：英文字母、数字、中文词汇等分词处理，兼容韩文、日文字符 优化的词典存储，更小的内存占用。支持用户词典扩展定义 针对Lucene全文检索优化的查询分析器IKQueryParser(作者吐血推荐);引入简单搜索表达式，采用歧义分析算法优化查询关键字的搜索排列组合，能极大的提高Lucene检索的命中率。  

1、下载地址 

GoogleCode开源项目 ：<http://code.google.com/p/ik-analyzer/> 
GoogleCode SVN下载：<http://ik-analyzer.googlecode.com/svn/trunk/>   

2、安装部署 IK Analyzer安装包包含：   

 1. IKAnalyzer中文分词器V3.2.8使用手册.pdf 
 2. IKAnalyzer3.2.8.jar 
 3. IKAnalyzer.cfg.xml     
 4. ext_stopword.dic 它的安装部署十分简单。 
 
 
   将IKAnalyzer3.2.8.jar部署于项目的lib目录中。 

> cp IKAnalyzer3.2.8.jar /opt/tomcat6/webapps/solr/WEB-INF/lib/

IKAnalyzer.cfg.xml文件放置在代码根目录(对于web项目，通常是WEB-INF/classes目录，同hibernate、log4j等配置文件相同)下即可。 

> cp IKAnalyzer.cfg.xml /opt/tomcat6/webapps/solr/WEB-INF/classes/ cp ext_stopword.dic /opt/tomcat6/webapps/solr/WEB-INF/classes/

  3、IK配置文件IKAnalyzer.cfg.xml的配置 
    
    
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
    <properties>
            <comment>IK Analyzer 扩展配置</comment>
            <!--用户可以在这里配置自己的扩展字典-->
            <entry key="ext_dict">/pinyin.dic; /sougou_words.dic;</entry> 
    
             <!--用户可以在这里配置自己的扩展停止词字典-->
            <entry key="ext_stopwords">/ext_stopword.dic</entry> 
    
    </properties>

下载：[pinyin](//static/uploads/2011/12/pinyin.zip)   [sougou_words](//static/uploads/2011/12/sougou_words.zip)   

4、与solr的整合 修改solr的配置文件 

> vim /opt/solr/conf/schema.xml

查找 

> <fieldType name="text" positionIncrementGap="100" autoGeneratePhraseQueries="true">

区域 ａ、将  `<analyzer type="index"> <tokenizer class="solr.WhitespaceTokenizerFactory"/>`

class的内容替换为：`org.wltea.analyzer.solr.IKTokenizerFactory` 替换后的效果为： 

> <fieldType name="text" class="solr.TextField" positionIncrementGap="100" autoGeneratePhraseQueries="true"> <analyzer type="index"> <tokenizer class="org.wltea.analyzer.solr.IKTokenizerFactory" isMaxWordLength="false"/>

ｂ、将 `<analyzer type="query"> 242 <tokenizer class="solr.WhitespaceTokenizerFactory"/>`

的class 替换为：`org.wltea.analyzer.solr.IKTokenizerFactory` 替换后的效果为： 

> <analyzer type="query"> <tokenizer class="org.wltea.analyzer.solr.IKTokenizerFactory" isMaxWordLength="true"/>  


5、分词效果实例 

原文1：IK-Analyzer是一个开源的，基于java语言开发的轻量级的中文分词工具包。从2006年12月推出1.0版开始， IKAnalyzer已经推出了3个大版本。 效果： 

ik
analyzer
是一个
一个
一
个
开源
基于
java
语言
开发
轻量级
量级
中文
分词
工具包
工具
2006
年
12
月
推出
1.0
版
开始
ikanalyzer
已经
推出了
推出
出了
3
个
大
版本
  
    
附：[IKAnalyzer中文分词器V3.2.8使用手册](//static/uploads/2011/12/IKAnalyzer中文分词器V3.2.8使用手册.pdf)