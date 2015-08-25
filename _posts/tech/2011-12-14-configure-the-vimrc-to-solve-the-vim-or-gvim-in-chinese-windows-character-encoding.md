---
layout: post
title: 配置 .vimrc 解决 Vim / gVim 在中文 Windows 下的字符编码问题
date: 2011-12-14 13:32:27
category: 技术
tags: vim, gvim
---



配置 .vimrc 解决 Vim / gVim 在中文 Windows 下的字符编码问题
Vim / gVim 在中文 Windows 下的字符编码有两个问题：
默认没有编码检测功能
如果一个文件本身采用的字符集比 GBK 大(如 UTF-8、UTF-16、GB18030)，那么其中无法在 GBK 中对应的字符都会出现乱码，保存时会丢失。即使编辑文件时正确检测出文件格式也无济于事。
第一个问题的解决办法是在 ~/.vimrc 中加入以下配置：

	set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
	
第二个问题的解决办法是强制要求 Vim 的内部编码采用某种 UTF 编码。比如 UTF-8：

	set encoding=utf-8
	
但是，把 Vim 的内部编码设为 UTF-8 会带来以下新问题
使用非 GUI 界面的 vim 时会乱码
提示信息(比如E492: 不是编辑器的命令: foo)会乱码
要解决非 GUI 界面的 vim 的乱码问题，需要设置终端编码为系统默认编码：

	set termencoding=cp936
	
而要让提示信息不乱码则要需要使用 UTF-8 版本的提示信息：

	language messages zh_CN.UTF-8
	
综上所述，在中文 Windows 下正确配置字符编码，需要把以下内容加入你的 ~/.vimrc 中

	set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
	set encoding=utf-8
	set termencoding=cp936
	language messages zh_CN.UTF-8
	
特别提醒，以上代码应该放在 .vimrc 的最顶端，因为 vim 运行过程中 `set encoding=xxx` 是很危险的，会导致各种乱码(参见这里)。
 
参考链接：<http://blog.csdn.net/happyjiahan/article/details/6325716>