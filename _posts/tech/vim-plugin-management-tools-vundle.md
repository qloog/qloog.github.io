Title: VIM插件管理工具Vundle
Date: 2014-03-09 17:00
Tags: Vim Vundle Plugin

[上一篇](/note/vim-config-and-plugin-share.html)说了下vim配置文件的基本配置及一些插件，这次谈一下关于vim插件的管理，插件很多，其实也通过插件来管理插件，真不愧是vim神器啊。比较常用的两款管理插件是：Pathtogen 和 Vundle, 但是哪一个更好呢？大多数人都想要一个答案，是的，vunder是比较好的。下面介绍下这两款插件。

## Pathtogen

Pathtogen 创造了一种组织插件的新方式，提供了一种管理插件的功能。原生的vim插件系统某种程度上提供了一个集中式的插件系统，但是pathogen使他成为了一种分布式的系统， 原生的方式是：
    
    
    vim/
        syntax/
            html.vim
        indent/
            html.vim
    

pathtoten的方式：
    
    
    vim/bundle/
    html/
        syntax/
            html.vim
        indent/
            html.vim
    

现在，你可以作为一个集合管理html，而不需要拷贝每一个文件到对应的目录里，一切将会被插件管理器很好的维护。

## Vundle

Vundle 是受Pathtogen启发，pathtoten能做的，Vundle也都能做，同时兼容pathtogen,也就是如果一个插件定义支持pathtogen,那它也支持vundle。但是Vundle可以做的更多，它改进了获取和更新vim插件的方式。

关于更多vundle 和 pathtogen的对应可以参考：  
* <http://lepture.com/en/2012/vundle-vs-pathogen>  
* <http://jameslaicreative.com/moving-up-upgrading-from-pathogen-to-vundle/>  
* <http://vim.1045645.n5.nabble.com/Vundle-vs-Pathogen-td5715615.html>

下面说说如何安装和使用Vundle:

1、 说明：安装要求 [Git](http://git-scm.com/), 配置里的每一个repository都会被安装到默认的 ~/.vim/bundle/, 为了可以搜索，curl也需要被安装。  
如果使用Windows,直接到 [Windows setup](https://github.com/gmarik/vundle/wiki/Vundle-for-Windows),中间如果有任何问题，可以到 [FAQ](https://github.com/gmarik/vundle/wiki) 提问。

2、 安装Vundle
    
    
    $ git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    

3、 配置bundle,把以下内容放到.vimrc的顶部，可以移除不需要的bundle,举例说明:
    
    
    set nocompatible              " be iMproved, required
    filetype off                  " required
    
    " set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/vundle/
    call vundle#rc()
    " alternatively, pass a path where Vundle should install bundles
    "let path = '~/some/path/here'
    "call vundle#rc(path)
    
    " let Vundle manage Vundle, required
    Bundle 'gmarik/vundle'
    
    " The following are examples of different formats supported.
    " Keep bundle commands between here and filetype plugin indent on.
    " scripts on GitHub repos
    Bundle 'tpope/vim-fugitive'
    Bundle 'Lokaltog/vim-easymotion'
    Bundle 'tpope/vim-rails.git'
    " The sparkup vim script is in a subdirectory of this repo called vim.
    " Pass the path to set the runtimepath properly.
    Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
    " scripts from http://vim-scripts.org/vim/scripts.html
    Bundle 'L9'
    Bundle 'FuzzyFinder'
    " scripts not on GitHub
    Bundle 'git://git.wincent.com/command-t.git'
    " git repos on your local machine (i.e. when working on your own plugin)
    Bundle 'file:///home/gmarik/path/to/plugin'
    " ...
    
    filetype plugin indent on     " required
    " To ignore plugin indent changes, instead use:
    "filetype plugin on
    "
    " Brief help
    " :BundleList          - list configured bundles
    " :BundleInstall(!)    - install (update) bundles
    " :BundleSearch(!) foo - search (or refresh cache first) for foo
    " :BundleClean(!)      - confirm (or auto-approve) removal of unused bundles
    "
    " see :h vundle for more details or wiki for FAQ
    " NOTE: comments after Bundle commands are not allowed.
    " Put your stuff after this line


4、 安装bundle 打开vim, 运行 `:BundleInstall` 如果在命令行下执行，可以运行：vim +BundleInstall +qall

## 参考

  * Vundle Github地址：<https://github.com/gmarik/Vundle.vim>
  * 更多使用案例：<https://github.com/gmarik/Vundle.vim/wiki/Examples>
  * .vimrc 配置参考1 <https://github.com/AlloVince/vim-of-allovince/blob/master/_vimrc>
  * .vimrc 配置参考2(配演示图): <https://github.com/wklken/k-vim>
  * .vimrc 配置参考3: <https://evsseny.appspot.com/?p=75001>
