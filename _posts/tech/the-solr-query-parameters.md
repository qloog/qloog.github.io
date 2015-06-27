Title: solr 查询参数说明
Date: 2011-12-30 18:01:42
Tags: Solr


##　solr 查询参数说明备忘

### 常用

q - 查询字符串，必须的。

fl - 指定返回那些字段内容，用逗号或空格分隔多个。

start - 返回第一条记录在完整找到结果中的偏移位置，0开始，一般分页用。

rows - 指定返回结果最多有多少条记录，配合start来实现分页。

sort - 排序，格式：sort=+[,+]… 。示例：(inStock desc, price asc)表示先 “inStock” 降序, 再 “price” 升序，默认是相关性降序。

wt - (writer type)指定输出格式，可以有 xml, json, php, phps, 后面 solr 1.3增加的，要用通知我们，因为默认没有打开。

fq - (filter query)过虑查询，作用：在q查询符合结果中同时是fq查询符合的，例如：q=mm&fq=date_time:[20081001 TO 20091031]，找关键字mm，并且date_time是20081001到20091031之间的。

官方文档：<http://wiki.apache.org/solr/CommonQueryParameters#head-6522ef80f22d0e50d2f12ec487758577506d6002> **不常用**

q.op - 覆盖schema.xml的defaultOperator(有空格时用"AND"还是用"OR"操作逻辑)，一般默认指定

df - 默认的查询字段，一般默认指定

qt - (query type)指定那个类型来处理查询请求，一般不用指定，默认是standard。


### 其它

indent - 返回的结果是否缩进，默认关闭，用 indent=true|on 开启，一般调试json,php,phps,ruby输出才有必要用这个参数。

version - 查询语法的版本，建议不使用它，由服务器指定默认值。