Title: window下mongodb扩展的安装
Date: 2012-03-05 17:25:02
Tags: MongoDB


MongoDB服务器端安装好之后，需要在PHP端安装其扩展，这样才可以直接调用mongo类。  

1、PHP官方下载地址： <http://www.php.net/manual/en/mongo.installation.php#mongo.installation.windows> 
我的PHP是5.3.5的，选择了：http://downloads.mongodb.org/mongo-latest-php5.3vc6ts.zip   

2、将其压缩包里的php_mongo.dll解压到php的扩展目录里，D:\wamp\bin\php\php5.3.5\ext   

3、在php.ini 加入`extension=php_mongo.dll`

4、重启apache或nginx，如安装成功，则可以看到一下结果。 

![](//static/uploads/2012/03/window_php_mongo.jpg)    

参考：   

<http://www.php.net/manual/en/mongo.installation.php#mongo.installation.windows> 里的用户评论。

	I am using XAMPP 1.7.4 (32 bit) on Windows 7. Though it was mentioned that Apache uses a non-threadsafe version of DLL, when used, it was giving me the below error:
	PHP Warning: PHP Startup: Unable to load dynamic library
	Warning: PHP Startup: Unable to load dynamic library ‘D:\xampp\php\ext\php_mongo.dll’ – The specified module could not be found.
	I had to use the thread-safe version (mongo-1.1.4.zip\mongo-1.1.4-php5.3vc6ts\php_mongo.dll) to get it working.