Title: Zend Framework:使用Command命令行建立ZF项目
Date: 2012-07-13 14:37:19
Tags: PHP, Zend Framework

zend framework 的项目结构比较复杂，但是有既定的结构。zf提供了使用Command生成项目结构的工具，使用非常方便，初学者可以不用为了复杂的结构而担忧。  我的环境是：win7+wamp+zf1.11.12 wamp我已经搭建好(很方便，基本下一步下一步就OK 了)，下面详细讲述zf创建项目的过程 第一步： 下载zf源码，(zf下载地猛击[这里](http://http://framework.zend.com/download/current/)，推荐使用mini包)。，将解压后的library和bin文件夹拷贝到服务器根目录，我的服务器跟目录为D:\wamp\www 第二步： 设置环境变量，修改系统变量中的Path值。添加上bin文件夹路径和php.exe所在目录，我添加的是D:\wamp\bin\php\php5.2.6;D:\wamp\www\bin（两个路径分号间隔）。 修改环境变量是为了，使用cmd时，在任意文件目录都可以使用zf命令。如果没有环境变量的话，只能在bin目录下才能使用zf命令，而且php.exe目录如果不在环境变量中，就没法被执行(当然会有提示：“’php.exe’不是内部或外部命令…)。 第三步: 下面就创建项目吧： 进入到你想创建项目的目录，一般是服务器根目录D:\wamp\www。输入 
    
    
    zf create project yourProjectName

但是我输入上面的命令却没有反应，同样**zf.bat create project yourProjectName** 也是没有响应，网上查了些资料也没有找到原因。最后尝试了下以下命令： 
    
    
    php bin/zf.php create project yourProjectName

例如创建一个quickstart的项目： 
    
    
    D:\wamp\www\bin>php bin/zf.php create project D:\wamp\www\quickstart
    Creating project at D:/wamp/www/quickstart
    Note: This command created a web project, for more information setting up your V
    HOST, please see docs/README
    Testing Note: PHPUnit was not found in your include_path, therefore no testing a
    ctions will be created.

第四步： 将D:\wamp\www\library目录下的Zend整个目录拷贝到D:\wamp\www\quickstart\library (或者 在php.ini里加入蓝色的部分， ; Windows: "\path1;\path2" include_path = ".;c:\php\includes;d:\wamp\www\library;" ) ok，打开cmd，进入D:\wamp\www后，输入php bin/zf.php show version，如果输出你的zf版本。那么恭喜你，你设置成功了。 浏览器中输入：<http://localhost/quickstart/public/> 即可访问你创建的项目了。 ![](http://lnmp100.b0.upaiyun.com/2012/07/zf_quickstart_success.jpg) 可能出现的错误： 1.如果输出“’zf’不是内部或外部命令….”，检查你的环境变量是否设置正确。 2.如果输出ZF ERROR…..，那么检查你的bin/zf.php文件中lirary的目录是否正确。 遇到的一个疑问：用zf.bat create project quickstart 命令创建项目始终没有响应，也没任何提示，不知是什么原因，如有知道的，欢迎留言指导，非常感谢！
