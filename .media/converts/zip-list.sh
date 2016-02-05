#!/bin/sh
# author: amoblin <amoblin@gmail.com>
# file name: zip-list.sh
# create date: 2013-03-01 11:27:53
# This file is created by Marboo<http://marboo.io> template file $MARBOO_HOME/.media/starts/default.sh
# 本文件由 Marboo<http://marboo.io> 模板文件 $MARBOO_HOME/.media/starts/default.sh 创建

name=`basename "$1"`
echo "# ${name}"
unzip -l "$1"|sed 's/^/    /'
