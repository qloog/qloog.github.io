Title: 让你的bash环境美起来吧 
Date: 2014-03-04 23:07:00
Tags: bash, shell

大概原理是这样的：通过执行一个脚本，将附件里的配置 软链接到用户主目录下，从而使用户可以加载这些配置文件，如bash_profile、bash_aliases、bash_environment ，先看下效果：

![bash_config1](//static/uploads/2014/03/bash_config1.jpeg)

![bash_config2](//static/uploads/2014/03/bash_config2.jpeg)

从图里可以发现 [] 里的颜色会发生变化，是的，每次登陆后都会有所不同，另外ls 查看目录内容也会根据不同文件显示不同的颜色。让你从此不再面对单调的颜色。

很简单，四步搞定：
    
    
    1、cd ~
    2、tar -zxvf bash_config.tar.gz
    3、cd .bash_config
    4、sh link.sh
    

还等什么呢，赶紧下载用起来吧。

附下载包：[bash_config.tar.gz](http://www.lnmp100.com/static/uploads/2014/03/bash_config.tar.gz)
