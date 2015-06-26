Title: CI框架在Nginx服务器上rewrite去掉index.php
Date: 2011-12-07 10:39:43
Tags: CI

CI框架在nginx服务器上配置rewrite去掉index.php的方法：

> vim /usr/local/webserver/nginx/conf/nginx.conf

实例配置代码：


      server
      {
        listen       80;
        server_name  www.lamp100.com;
        index index.html index.htm index.php;
        root  /data0/htdocs/lamp100;

        #nginx去掉index.php
        location / {
           rewrite ^/$ /index.php last;
           #一下是防止某些文件夹被直接访问
           rewrite ^/(?!index\.php|robots\.txt|uploadedImages|resource|images|js|css|styles|static)(.*)$ /index.php/$1 last;
        }

        #nginx模拟pathinfo,否则CI框架的控制器无法访问

        location ~ ^(.+\.php)(.*)$
        {
          #fastcgi_pass  unix:/tmp/php-cgi.sock;
          fastcgi_pass  127.0.0.1:9000;
          fastcgi_index index.php;
          fastcgi_split_path_info ^(.+\.php)(.*)$;
          fastcgi_param        SCRIPT_FILENAME        $document_root$fastcgi_script_name;
          fastcgi_param        PATH_INFO                $fastcgi_path_info;
          fastcgi_param        PATH_TRANSLATED        $document_root$fastcgi_path_info;
          include        fastcgi_params;
          #include fcgi.conf;
        }

        log_format  lamp100logs  '$remote_addr - $remote_user [$time_local] "$request" '
                   '$status $body_bytes_sent "$http_referer" '
                   '"$http_user_agent" $http_x_forwarded_for';
        access_log  /data1/logs/lamp100logs.log  lamp100logs;

      }

  以上都是自己实际中在使用的。
