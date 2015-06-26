Title: shell下递归读取目录及其子目录的文件
Date: 2012-06-30 16:07:36
Tags: shell, 递归

之前写过一个PHP下的读取目录的函数，最近碰到了如何利用shell读取目录的文件。其实实现原理一样无非就是把PHP的语法换为shell的语法。具体实现如下： 
    
    
    #! /bin/bash
    function read_dir(){
        for file in `ls $1`
        do
            if [ -d $1"/"$file ]  //注意此处之间一定要加上空格，否则会报错
            then
                read_dir $1"/"$file
            else
                echo $1"/"$file
            fi
        done
    }
    
    #测试目录 test
    read_dir test

这样给test.sh加上执行权限即可执行 chmod +x test.sh sh test.sh 到此即可通过传递参数来读取目录文件了。
