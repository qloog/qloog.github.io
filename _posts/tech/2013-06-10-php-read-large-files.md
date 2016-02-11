---
layout: post
title: PHP 读取大文件
date: 2013-06-10 19:48:00
category: 技术
tags: PHP 大文件
---

一般读取文件我们用fopen 或者 file_get_contents ,前者可以循环读取，后者可以一次性读取，但都是将文件内容一次性加载来操作。如果加载的文件特别大时，如几百M，上G时，这时性能就降下来了，那么PHP里有没有对大文件的处理函数或者类呢？ 答案是：有的。

## PHP 之SPL

PHP真的越来越“面向对象”了，一些原有的基础的SPL方法都开始陆续地实现出class了。

从 PHP 5.1.0 开始，SPL 库增加了 SplFileObject 与 SplFileInfo 两个标准的文件操作类。SplFileInfo 是从 PHP 5.1.2 开始实现的。

从字面意思理解看，可以看出 SplFileObject 要比 SplFileInfo 更为强大。

不错，SplFileInfo 仅用于获取文件的一些属性信息，如文件大小、文件访问时间、文件修改时间、后缀名等值，而 SplFileObject 是继承 SplFileInfo 这些功能的。
    
    
     /** 返回文件从X行到Y行的内容(支持php5、php4)  
     * @param string $filename 文件名
     * @param int $startLine 开始的行数
     * @param int $endLine 结束的行数
     * @return string
     */
    function getFileLines($filename, $startLine = 1, $endLine=50, $method='rb') {
        $content = array();
        $count = $endLine - $startLine;  
        // 判断php版本（因为要用到SplFileObject，PHP>=5.1.0）
        if(version_compare(PHP_VERSION, '5.1.0', '>=')){
            $fp = new SplFileObject($filename, $method);
            $fp->seek($startLine-1);// 转到第N行, seek方法参数从0开始计数
            for($i = 0; $i <= $count; ++$i) {
                $content[]=$fp->current();// current()获取当前行内容
                $fp->next();// 下一行
            }
        }else{//PHP<5.1
            $fp = fopen($filename, $method);
            if(!$fp) return 'error:can not read file';
            for ($i=1;$i<$startLine;++$i) {// 跳过前$startLine行
                fgets($fp);
            }
            for($i;$i<=$endLine;++$i){
                $content[]=fgets($fp);// 读取文件行内容
            }
            fclose($fp);
        }
        return array_filter($content); // array_filter过滤：false,null,''
    }    
    

Ps: 上面都没加"读取到末尾的判断"：!$fp->eof() 或者 !feof($fp)，加上这个判断影响效率，自己加上测试很多很多很多行的运行时间就晓得了，而且这里加上也完全没必要。

从上面的函数就可以看出来使用SplFileObject比下面的fgets要快多了，特别是文件行数非常多、并且要取后面的内容的时候。fgets要两个循环才可以，并且要循环$endLine次。

此方法花了不少功夫，测试了很多中写法，就是想得出效率最高的方法。哪位觉得有值得改进的欢迎赐教。

使用，返回35270行-35280行的内容:
    
    
    echo '<pre>';
    var_dump(getFileLines('test.php',35270,35280));
    echo '</pre>';  
    

参考:  
<http://www.fantxi.com/blog/archives/php-read-large-file/>  
<http://blog.wangbuying.cn/archives/87>  
<http://www.ruanyifeng.com/blog/2008/07/php_spl_notes.html>
