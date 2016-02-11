---
layout: post
title: Nginx配置域名301重定向
date: 2012-06-17 23:35:08
category: 技术
tags: nginx 301
---

比如说我们有域名example.com，然后配置我们的Nginx服务器，希望绑定两个域名不带www的example.com以及www.example.com。绑定域名可以在你的Nginx配置文件的server {}节做下述配置。 
    
    
    server {
        listen 80;
        server_name example.com www.example.com;
      }

这样配置后example.com和www.example.com都指向我们的服务器了，虽然这样没有什么，但是这对于搜索引擎是不友好的，不利于网站的SEO，所以我们需要利用301重定向一个域名到另一个域名上。 在Nginx的server节中引入$host变量，这个指代当前访客访问主机时使用的主机名（域名）。接下来我们可以利用if条件语句配合rewrite permanent方式做301定向了。 
    
    
     # 示例1: 将example.com定向到www.example.com
      server {
        listen 80;
        server_name example.com www.example.com;
        if ($host != 'www.example.com') {
          rewrite ^/(.*)$ http://www.example.com/$1 permanent;
        }
      }
    
      # 示例2: 将www.example.com定向到example.com
      server {
        listen 80;
        server_name example.com www.example.com;
        if ($host != 'example.com') {
          rewrite ^/(.*)$ http://example.com/$1 permanent;
        }
      }

上面举了两个例子分别判断当前的请求主机域是否符合我们的要求，不符合则截取请求路径/后面的内容并附加到我们期望的url后面，同时作301永久定向（permanent）。当然这里我们使用的是不等于!=来进行判断的，如果使用等于的话就直接使用等于号（=）进行判断并将条件更改为我们不期望的主机域就可以了。 这里有几个问题需要注意一下： 1\. 上述配置文件的if语句与括号必须以一个空格隔开，否则Nginx会报nginx: [emerg] unknown directive “if($host” in…错误。 2\. Nginx的条件判断不等于是!=，等于是=，注意这里的等于只有一个等于号，如果写成==，则Nginx会报nginx: [emerg] unexpected “==” in condition in…错误。 3\. 301永久转向配置成功后，浏览器可能会有记忆效应，比如说IE。所以一旦配置并利用浏览器访问过页面，那么你更改了301转向配置后，这个页面可能依旧是上次的转向，建议清除浏览器缓存，或者尝试访问其他页面，也可以在url的?问号后面加上一些随机的参数，避免浏览器的缓存记忆效应。 配置完成后，可以使用**nginx -s reload**命令进行平滑的更新配置（不重启Nginx）。
