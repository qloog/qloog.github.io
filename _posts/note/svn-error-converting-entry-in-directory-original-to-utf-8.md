Title: svn: Error converting entry in directory 'original' to UTF-8 的处理方法
Date: 2012-03-07 13:17:03
Tags: SVN, error


svn: Error converting entry in directory 'original' to UTF-8 的处理方法

最近在测试机上用svn up更新本地文件时，提示如下错误：
![svn_update_err](/static/uploads/2012/03/svn_update_err.jpg)
一般出现这样的问题是因为 uploadedImages/foods/original  有非UTF8编码的文件，大部分是因为文件名为含有中文。
1、更改或删除含中文的文件
2、找到含有中文的文件,用vim打开文件后输入  `:set fileencoding=utf-8` ,保存即可。
