Title: wordpress在Nginx下固定链接中伪静态规则
Date: 2011-11-12 11:26:44
Tags: wordpress, Nginx




最近一直想把自己的博客链接弄成静态形式的，主要目的是为了： 

1、好记   
2、看起来美观   
3、对搜索引擎友好    

链接形式如： 

> http://www.lnmp100.com//189 http://www.lnmp100.com//page/2 http://www.lnmp100.com//date/2011/11 http://www.lnmp100.com//tag/linux http://www.lnmp100.com//category/linux%E6%8A%80%E6%9C%AF

  要实现以上的静态链接其实只需要2个步骤即可。  
  
1、后台->设置->固定链接里，选择“自定义结构”，填入自己需要达到的链接形式 比如我的是：http://www.lnmp100.com//189 那么这里就直接填写：%post_id% 还有其他一些参数可以填写： 
    
    
    %year%		文章发表的年份，四位数，如 2004
    %monthnum%	份，如 05
    %day%		天，如 28
    %hour%		小时，如 15
    %minute%	分钟，如 43
    %second%	秒，如 33
    %postname%	文章标题的别名(编辑文章/页面时的别名栏)。
    %post_id%	文章的唯一ID，如 423
    %category%	分类的别名 (新建/编辑分类时的别名栏)。 有层级关系的类型在链接地址里就像有层级的目录。
    %tag%		标签的别名(新建/编辑标签时的别名栏)。 出于性能原因，强烈不建议使用%tag%作为链接地址的开头。
    %author%	作者的别名。

2、在Nginx的配置文件server段里加入如下伪静态规则： 

> location / { try_files $uri $uri/ /index.php?q=$uri&$args; }

最后重启nginx 服务即可： 

> /usr/local/nginx/sbin/nginx -s reload

  以上就是配置wordpress固定链接伪静态的方法，如有疑问可以留言。