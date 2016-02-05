#!/bin/sh
# author: amoblin <amoblin@gmail.com>
# file name: audio2html.sh
# create date: 2014-06-26 14:42:23
# This file is created by Marboo<http://marboo.io> template file $MARBOO_HOME/.media/starts/default.sh
# 本文件由 Marboo<http://marboo.io> 模板文件 $MARBOO_HOME/.media/starts/default.sh 创建

name=`basename "$1"`
#tmp_file=/tmp/$name
echo "<h1>$name</h1>\
<div class=\"player\" style=\"margin-top:100px; text-align:center\">\n\
  <audio controls=\"\" name=\"media\">\n \
    <source src=\"$name\" type=\"audio/mpeg\">\n \
  </audio>\n \
</div>"
