Title: Mac OS X Shell 简单介绍
Date: 2014-02-27 19:59:15
Tags: Mac, shell

## Mac OS X Shell 简单介绍

### Mac下支持的shell
    
    
    cat /etc/shells  
    

### 首先查看是什么shell:
    
    
    echo $SHELL
    

如果输出的是：csh或者是tcsh，就是C Shell。

如果输出的是：bash，sh，zsh，就是Bourne Shell的一个变种。

Mac OS X 10.2之前默认的是C Shell。

Mac OS X 10.3之后默认的是Bourne Shell。

(1). 如果是Bourne Shell。

直接在主目录下面的.profile或者.bash_profile中修改，如果文件不存在就生成一个。
    
    
    usermatoMacBook-Pro:~ user$ vim .profile
    

(2). 如果是C Shell，和(1)一样 ，只是编辑的文件名为：.cshrc
    
    
    vim .cshrc
