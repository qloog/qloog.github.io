Title: 利用solr实现搜索服务的案例介绍
Date: 2011-12-30 17:59:02
Tags: Solr


本文接着介绍如果使用solr来实现具体应用的搜索服务。 

之前介绍了solr全文搜索服务的部署。  以搜索论坛帖子的应用为例（也可理解为是文章系统的案例）  索引结果如下： 

字段 说明

id
帖子 id

user
发表用户名或UserId

title
标题

content
内容

timestamp
发表时间

text
把标题和内容放到这里，可以用同时搜索这些内容。
1、配置schema.xml,加入需要被搜索的字段 

> vim /opt/solr/solr/conf/schema.xml

查找“<fields>”在其节点内加入如下代码： 
    
    
    <?xml version="1.0" encoding="UTF-8" ?>  
    
    <schema name="example" version="1.3">   
    
     <fields>
       <field name="id" type="sint" indexed="true" stored="true" required="true" />
       <field name="user" type="string" indexed="true" stored="true"/>
       <field name="title" type="text" indexed="true" stored="true"/>
       <field name="content" type="text" indexed="true" stored="true" />
       <field name="timestamp" type="date" indexed="true" stored="true" default="NOW"/>  
    
       <!-- catchall field, containing all other searchable text fields (implemented
            via copyField further on in this schema  -->
       <field name="text" type="text" indexed="true" stored="false" multiValued="true"/>
     </fields>  
    
     <!-- Field to use to determine and enforce document uniqueness.
          Unless this field is marked with required="false", it will be a required field
       -->
     <uniqueKey>id</uniqueKey>  
    
     <!-- field for the QueryParser to use when an explicit fieldname is absent -->
     <defaultSearchField>text</defaultSearchField>  
    
     <!-- SolrQueryParser configuration: defaultOperator="AND|OR" -->
     <solrQueryParser defaultOperator="AND"/>  
    
      <!-- copyField commands copy one field to another at the time a document
            is added to the index.  It's used either to index the same field differently,
            or to add multiple fields to the same field for easier/faster searching.  -->
    <!-- -->
       <copyField source="title" dest="text"/>
       <copyField source="content" dest="text"/>  
    
    </schema>

保存后，重启tomcat 2、提交索引到索引库中 首先需要将要搜索的数据转成xml文件格式的，例如实际应用中，需将数据库的数据导出为xml格式。 这里就一个两个现有的xml文件为例，demo-doc1.xml和demo-doc2.xml demo-doc1.xml: 
    
    
    <?xml version="1.0" encoding="UTF-8" ?>
    <add>
        <doc>
            <field name="id">1</field>
            <field name="user">chenlb</field>
            <field name="title">solr 应用演讲</field>
            <field name="content">这一小节是讲提交数据给服务器做索引，这里有一些数据，如：服务器，可以试查找它。</field>
        </doc>
    </add>

demo-doc2.xml: 
    
    
    <?xml version="1.0" encoding="UTF-8" ?>
    <add>
        <doc>
            <field name="id">2</field>
            <field name="user">bory.chan</field>
            <field name="title">搜索引擎</field>
            <field name="content">搜索服务器那边有很多数据。</field>
            <field name="timestamp">2009-02-18T00:00:00Z</field>
        </doc>
        <doc>
            <field name="id">3</field>
            <field name="user">other</field>
            <field name="title">这是什么</field>
            <field name="content">你喜欢什么运动？篮球？</field>
            <field name="timestamp">2009-02-18T12:33:05.123Z</field>
        </doc>
    </add>

3、提交数据作为索引 

> java -Dauth=username:password  -jar  /opt/solr/post.jar demo-doc1.xml java -Dauth=username:password  -jar  /opt/solr/post.jar demo-doc2.xml

或者： 

> java -Dauth=username:password  -jar  /opt/solr/post.jar demo-doc*.xml

或者： 

> java -Durl=http://localhost:8983/solr/update -Dcommit=yes -jar post.jar demo-doc*.xml

SimplePostTool: version 1.3 SimplePostTool: WARNING: Make sure your XML documents are encoded in UTF-8, other encodings are not currently supported SimplePostTool: POSTing files to http://localhost:8983/solr/update.. SimplePostTool: POSTing file demo-doc1.xml SimplePostTool: POSTing file demo-doc2.xml SimplePostTool: COMMITting Solr index changes.. 注：post.jar 包所在的位置，/解压后的目录/example/exampledocs/post.jar   4、查看搜索结果 http://localhost:8983/solr/select/?q=*%3A*&version=2.2&start=0&rows=10&indent=on 
    
    
    <?xml version="1.0" encoding="UTF-8"?>
    <response>  
    
    <lst name="responseHeader">
     <int name="status">0</int>
     <int name="QTime">0</int>
     <lst name="params">
      <str name="indent">on</str>
      <str name="start">0</str>
      <str name="q">*:*</str>
      <str name="rows">10</str>
      <str name="version">2.2</str>
     </lst>
    </lst>
    <result name="response" numFound="3" start="0">
     <doc>
      <str name="content">这一小节是讲提交数据给服务器做索引，这里有一些数据，如：服务器，可以试查找它。</str>
      <int name="id">1</int>
      <date name="timestamp">2009-05-27T04:07:54.89Z</date>
      <str name="title">solr 应用演讲</str>
      <str name="user">chenlb</str>
     </doc>
     <doc>
      <str name="content">搜索服务器那边有很多数据。</str>
      <int name="id">2</int>
      <date name="timestamp">2009-02-18T00:00:00Z</date>
      <str name="title">搜索引擎</str>
      <str name="user">bory.chan</str>
     </doc>
     <doc>
      <str name="content">你喜欢什么运动？篮球？</str>
      <int name="id">3</int>
      <date name="timestamp">2009-02-18T12:33:05.123Z</date>
      <str name="title">这是什么</str>
      <str name="user">other</str>
     </doc>
    </result>
    </response>

注：索引文件（默认）会在 CWD/solr/solr/data/index 目录下，其修改的配置文件为：/opt/solr/solr/conf/solrconfig.xml 关于更多的solr查询参数可参见：[solr查询参数说明](//380) 本文没有介绍到中文分词，以后会继续介绍中文分词库的安装和使用以及solr服务器的管理