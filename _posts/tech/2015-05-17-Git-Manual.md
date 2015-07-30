---
layout: post
title: Git常用配置
category: 技术
date: 2015-07-17
tags: Git
---

>  最近在经常使用Git, 难免会碰到各种各样的问题，问题虽小，但也会阻碍前进的道路，所以为了解决到这些问题，同时方便以后的查询，故把它们都整理下来，并找到相应的解决方案。


## .gitignore 配置

 `.gitignore` 配置文件用于配置不需要加入版本管理的文件，配置好该文件可以为我们的版本管理带来很大的便利。
 
 有些时候，你必须把某些文件放到Git工作目录中，但又不能提交它们，比如保存了数据库密码的配置文件啦、微信的安全key了等等，每次`git status`都会显示`Untracked files ...`，有强迫症的童鞋心里肯定不爽。

好在Git考虑到了大家的感受，这个问题解决起来也很简单，在Git工作区的根目录下创建一个特殊的`.gitignore`文件，然后把要忽略的文件名填进去，Git就会自动忽略这些文件。

不需要从头写`.gitignore`文件，GitHub已经为我们准备了各种配置文件，只需要组合一下就可以使用了。所有配置文件可以直接在线浏览：[https://github.com/github/gitignore](https://github.com/github/gitignore)

#### 1. 忽略文件的原则是：

 * 忽略操作系统自动生成的文件，比如缩略图等；
 * 忽略编译生成的中间文件、可执行文件等，也就是如果一个文件是通过另一个文件自动生成的，那自动生成的文件就没必要放进版本库，比如Java编译产生的.class文件；
 * 忽略你自己的带有敏感信息的配置文件，比如存放口令的配置文件。
 
##### 举个例子：

假设你用PHPStorm下进行PHP开发，PHPStrom会自动创建`.idea`目录， 如果我们想去忽略掉这个目录，需要在.gitignore里加入

	# PHPStrom:
	.idea/
	
然后，如果实在Mac OS X 下面开发，最好也加上：
	
	# MAC:
	.DS_Store
	# Thumbnails
	._*
	
当然，如果你是基于Lravel开发的话，可以加入：

	/bootstrap/compiled.php
	.env.*.php
	.env.php
	.env	
	
加上你自己定义的文件，最终得到一个完整的.gitignore文件，内容如下：

	
	# MAC:
	.DS_Store
	
	# PHPStrom:
	.idea/
	
	#laravel
	/bootstrap/compiled.php
	.env.*.php
	.env.php
	.env	
	
最后一步就是把.gitignore也提交到Git，就完成了！
 
#### 2. 配置语法
 
* 以斜杠“/”开头表示目录；
* 以星号“*”通配多个字符；
* 以问号“?”通配单个字符
* 以方括号“[]”包含单个字符的匹配列表；
* 以叹号“!”表示不忽略(跟踪)匹配到的文件或目录；

> 此外，git 对于 .ignore 配置文件是按行从上到下进行规则匹配的，意味着如果前面的规则匹配的范围更大，则后面的规则将不会生效；
	
	
#### 3. 规则：

* 规则：`fd1/*`  

	> 说明：忽略目录 fd1 下的全部内容；注意，不管是根目录下的 /fd1/ 目录，还是某个子目录 /child/fd1/ 目录，都会被忽略；

* 规则：`/fd1/*`  

	> 说明：忽略根目录下的 /fd1/ 目录的全部内容；

* 规则：

		/*  
		!.gitignore  
		!/fw/bin/  
		!/fw/sf/

	> 说明：忽略全部内容，但是不忽略 .gitignore 文件、根目录下的 /fw/bin/ 和 /fw/sf/ 目录；
	
		
#### 4.  小结

 * 忽略某些文件时，需要编写.gitignore；
 * `.gitignore`文件本身要放到版本库里，并且可以对.gitignore做版本管理！
 * 关于不知.gitignore里应该加什么的，可以查阅：[https://github.com/github/gitignore](https://github.com/github/gitignore) 


## .gitconfig 全局配置

有没有经常敲错命令？比如`git status？` `status`这个单词真心不好记。

如果敲git st就表示git status,那就简单多了，当然这种偷懒的办法我们是极力赞成的。

我们只需要敲一行命令，告诉Git，以后st就表示status：

	$ git config --global alias.st status
	
好了，现在敲`git st`看看效果。

当然还有别的命令可以简写，很多人都用co表示checkout，ci表示commit，br表示branch：

	$ git config --global alias.co checkout
	$ git config --global alias.ci commit
	$ git config --global alias.br branch
	
以后提交就可以简写成：

	$ git ci -m "bala bala bala..."
	
`--global`参数是全局参数，也就是这些命令在这台电脑的所有Git仓库下都有用。

	
配置一个`git last`，让其显示最后一次提交信息：

	$ git config --global alias.last 'log -1'
	
这样，用git last就能显示最近一次的提交：

	$ git last
	commit adca45d317e6d8a4b23f9811c3d7b7f0f180bfe2
	Merge: bd6ae48 291bea8
	Author: qloog <qloog@gmail.com>
	Date:   Thu Aug 22 22:49:22 2013 +0800
	
	    merge & fix hello.py
	    
甚至还有人丧心病狂地把lg配置成了：

	git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
	
来看看`git lg`的效果：

	git -lg

为什么不早点告诉我？别激动，咱不是为了多记几个英文单词嘛！

配置文件

配置Git的时候，加上`--global`是针对当前用户起作用的，如果不加，那只针对当前的仓库起作用。

配置文件放哪了？每个仓库的Git配置文件都放在`.git/config`文件中：

	$ cat .git/config 
	[core]
	    repositoryformatversion = 0
	    filemode = true
	    bare = false
	    logallrefupdates = true
	    ignorecase = true
	    precomposeunicode = true
	[remote "origin"]
	    url = git@github.com:qloog/laravel5-wechat.git
	    fetch = +refs/heads/*:refs/remotes/origin/*
	[branch "master"]
	    remote = origin
	    merge = refs/heads/master
	[alias]
	    last = log -1
别名就在[alias]后面，要删除别名，直接把对应的行删掉即可。

而当前用户的Git配置文件放在用户主目录下的一个隐藏文件`.gitconfig`中：

	$ cat ~/.gitconfig
	[alias]
	    co = checkout
	    ci = commit
	    br = branch
	    st = status
	[user]
	    name = Your Name
	    email = your@email.com
	    
配置别名也可以直接修改这个文件，如果改错了，可以删掉文件重新通过命令配置。

小结

给Git配置好别名，就可以输入命令时偷个懒。我们鼓励偷懒。

