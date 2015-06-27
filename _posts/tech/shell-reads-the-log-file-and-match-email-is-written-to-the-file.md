title: shell读取日志文件并将匹配的Email写入到文件中
Date: 2012-06-30 17:50:53
Tags: shell


有时我们会处理日志文件，或其他文本文件，并将里面含有的Email读取出来，可以利用shell处理文件的方法来读取。  代码如下： 
    
    
    #! /bin/bash
    function read_file(){
        for line in `cat $1`
        do
            if [ `echo $line |grep "^[a-zA-Z0-9_-]*@[A-Za-z_-]*\.[a-zA-Z_-]*$"` ];then
                echo $line >> result.txt
            else
                echo "---" >> result.txt
            fi
        done
    }
    
    #eg
    read_file a.txt
