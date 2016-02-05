#!/bin/sh
# author: amoblin <amoblin@gmail.com>
# file name: video2html.sh
# create date: 2014-07-06 06:37:27
# This file is created by Marboo<http://marboo.io> template file $MARBOO_HOME/.media/starts/default.sh
# 本文件由 Marboo<http://marboo.io> 模板文件 $MARBOO_HOME/.media/starts/default.sh 创建

name=`basename "$1"`
name_without_extension=`echo ${name%.*}`
#tmp_file=/tmp/$name
echo "<div style=\"text-align:center\">\n \
<h1>$name_without_extension</h1>\n \
<div class=\"player\" style=\"margin-top:100px\">\n\
  <video controls=\"\" name=\"media\" width=\"80%\">\n \
    <source src=\"$name\" type=\"video/mp4\">\n \
  </video>\n \
</div>"
