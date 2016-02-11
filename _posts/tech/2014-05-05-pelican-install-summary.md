---
layout: post
title: 用Pelican 搭建静态博客
date: 2014-05-05 18:30
category: 技术
tags: Pelican
---

前面有文章介绍本站采用了Python编写的Pelican静态生成博客系统, 之所以没有使用当前很火的Jekyll, 是因为它是Ruby编写, 而我又对Ruby没有啥兴趣, 所以还是选择了使用了我熟悉的Python编写的这套系统, 我用了一段时间,打算将使用经验分享出来

## 介绍
Pelican是一套开源的使用Python编写的博客静态生成, 可以添加文章和和创建页面, 可以使用MarkDown reStructuredText 和 AsiiDoc 的格式来抒写, 同时使用 Disqus评论系统, 支持 RSS和Atom输出, 插件, 主题, 代码高亮等功能, 采用Jajin2模板引擎, 可以很容易的更改模板

## 安装virtualenv

可以从github克隆最新的代码安装, 并且建议在virtualenv下使用:

    pip install virtualenv
    #Mac 下如果没安装pip, 可以执行：sudo easy_install pip

## 建立 virtualenv

    virtualenv pelican      # 创建
    cd pelican
    sh bin/activate            # 激活虚拟环境

上面建立了一个Python的虚拟环境(这个命令不是内置可以使用 easy_install virtualenv 安装)

## 从github克隆最新代码安装Pelican

    git clone git://github.com/getpelican/pelican.git            # 代码
    cd pelican
    python setup.py install

上面步骤完成后就安装了Pelican

## 开始一个博客

    mkdir /path/to/your/blog
    cd /path/to/your/blog
    pelican-quickstart

## 定制配置

    (pelican)➜  blog git:(master) >pelican-quickstart
    Welcome to pelican-quickstart v3.3.1.dev.

    This script will help you create a new Pelican-based website.

    Please answer the following questions so this script can generate the files
    needed by Pelican.

    > Where do you want to create your new web site? [.]
    > What will be the title of this web site? LNMP100实验室
    > Who will be the author of this web site? lnmp100
    > What will be the default language of this web site? [en] cn
    > Do you want to specify a URL prefix? e.g., http://example.com   (Y/n) http://www.lnmp100.com
    You must answer 'yes' or 'no'
    > Do you want to specify a URL prefix? e.g., http://example.com   (Y/n) Y
    > What is your URL prefix? (see above example; no trailing slash) http://www.lnmp100.com
    > Do you want to enable article pagination? (Y/n) Y
    > How many articles per page do you want? [10]
    > Do you want to generate a Fabfile/Makefile to automate generation and publishing? (Y/n) Y
    > Do you want an auto-reload & simpleHTTP script to assist with theme and site development? (Y/n) Y
    > Do you want to upload your website using FTP? (y/N) y
    > What is the hostname of your FTP server? [localhost]
    > What is your username on that server? [anonymous]
    > Where do you want to put your web site on that server? [/]
    > Do you want to upload your website using SSH? (y/N) y
    > What is the hostname of your SSH server? [localhost]
    > What is the port of your SSH server? [22]
    > What is your username on that server? [root]
    > Where do you want to put your web site on that server? [/var/www]
    > Do you want to upload your website using Dropbox? (y/N) y
    > Where is your Dropbox directory? [~/Dropbox/Public/]
    > Do you want to upload your website using S3? (y/N) N
    > Do you want to upload your website using Rackspace Cloud Files? (y/N) N
    > Do you want to upload your website using GitHub Pages? (y/N) y
    > Is this your personal page (username.github.io)? (y/N) y
    Done. Your new project is available at /Users/wanglong/Sites/mine/pelican/pelican/blog

在回答一系列问题过后你的博客就建成的, 主要生成下列文件:

    .
    |-- content                # 所有文章放于此目录
    |-- develop_server.sh      # 用于开启测试服务器
    |-- Makefile               # 方便管理博客的Makefile
    |-- output                 # 静态生成文件
    |-- pelicanconf.py         # 配置文件
    |-- publishconf.py         # 配置文件

## 写一篇文章

在 content 目录新建一个 test.md文件, 填入一下内容:

    Title: 文章标题
    Date: 2013-04-18
    Category: 文章类别
    Tag: 标签1, 标签2

    这里是内容

然后执行:

    make html

用以生成html

然后执行

    ./develop_server.sh start

开启一个测试服务器, 这会在本地 8000 端口建立一个测试web服务器, 可以使用浏览器打开:http://localhost:8000来访问这个测试服务器, 然后就可以欣赏到你的博客了

## 创建一个页面
这里以创建 About页面为例

在content目录创建pages目录

    mkdir content/pages

然后创建About.md并填入下面内容

    Title: About Me
    Date: 2013-04-18

    About me content

执行 `make html` 生成html, 然后打开 http://localhost:8000查看效果

## 让Pelican支持评论
Pelican 使用Disqus评论, 可以申请在Disqus上申请一个站点, 然后在pelicanconf.py里添加或修改DISQUS_SITENAME项:

    DISQUS_SITENAME = u"lnmp100"

执行

    make html

浏览器打开 http://localhost:8000查看效果

## 更换主题

Pelican本身也提供了一些主题可供选择, 可以从github克隆下来

    git clone git://github.com/getpelican/pelican-themes.git     # 主题

安装niu-x2-sidebar 主题

    git submodule add -f https://github.com/mawenbao/niu-x2-sidebar pelican-themes/niu-x2-sidebar

主题安装成功, 安装时会自动生成文件.gitmodules:

    [submodule "pelican-themes/niu-x2-sidebar"]
        path = pelican-themes/niu-x2-sidebar
        url = http://github.com/mawenbao/niu-x2-sidebar

然后在 pelicanconf.py 配置文件里添加或修改 THEME项为 niu-x2-sidebar

    THEME = "niu-x2-sidebar"

重新执行

    make html

然后打开 http://localhost:8000 查看效果

## 使用插件

Pelican 一开始是将插件内置的, 但是新版本 Pelican将插件隔离了出来, 所以我们要到github上 克隆一份新的插件, 在博客目录执行

    git clone git://github.com/getpelican/pelican-plugins.git    # 插件

现在我们博客目录就新添了一个 pelican-plugins目录, 我们已配置sitemap插件为例, sitemap插件可以生成 sitemap.xml 供搜索引擎使用

在pelicanconf.py配置文件里加上如下项:

    PLUGIN_PATH = u"pelican-plugins"
    PLUGINS = ["sitemap"]

## 配置sitemap 插件

    SITEMAP = {
        "format": "xml",
        "priorities": {
            "articles": 0.7,
            "indexes": 0.5,
            "pages": 0.3,
        },
        "changefreqs": {
            "articles": "monthly",
            "indexes": "daily",
            "pages": "monthly",
        }
    }

然后再执行

    make html

打开浏览器请求 http://localhost:8000/sitemap.xml即可看到生成的 Sitemap 了

这里有个问题，如果插件多了怎么办？ 一个一个的手动执行git clone吗？ 不是的，git还是很方便的，这里引入加载子模块的概念

### 添加子模块

    git submodule add https://github.com/wilbur-ma/extract_headings plugins/extract_headings

### 查看子模块

     git submodule  —-查看当前项目用到的子模块

### 初始化子模块

     git submodule init —-只在首次检出仓库时运行一次就行
     //初始化本质是：将.gitmodules的子模块信息注册到.git/config里。

### 更新子模块

     git submodule update —-每次更新或切换分支后都需要运行一下

### 删除子模块

     git rm --cached [path]
     //编辑.gitmodules文件，将子模块的相关配置节点删除掉
     //编辑.git/config文件，将子模块的相关配置节点删除掉
     //手动删除子模块残留的目录


## 拷贝静态文件

如果我们定义静态的文件, 该如何将它在每次生成的时候拷贝到 output 目录呢, 我们以robots.txt 为例, 在我们的 content/extra 下面我们放了一个定义好的 robots.txt文件, 在pelicanconf.py更改或添加 FILES_TO_COPY项:

    FILES_TO_COPY = (
        ("extra/robots.txt", "robots.txt"),
    )

这样在每次生成html的时候都会把 content/extra下的 robots.txt 拷贝到 output目录下

拷贝静态目录
如果是一个静目录怎么办? 我们可以在pelicanconf.py里添加或修改 STATIC_PATHS项, 比如我们有个img目录用来放文章所使用的图片, 我们可以在pelicanconf.py添加

    STATIC_PATHS = [u"img"]

然后执行

    make html

然后 Pelican 就会将 img目录拷贝到 output/static/ 下

## 将博客发布到github上
博客最终是要放到互联网上供人看的，此处就是将博客上传上去，在上传之前，要确保github上有一个仓库命令规是username.github.io,其中username为你的github帐号

    cd output
    git init
    git add .
    git commit -m "first commit"
    git remote add origin git@github.com:username/username.github.io.git
    git push -u origin master

## 备份博客配置到github
注意这个和前面的区别：上面主要是发布静态文件上去，这里只是为了用github备份配置等相关文件
Create a new repository on the command line

    cd blog
    git init
    git add .
    git commit -m "first commit"
    git remote add origin git@github.com:qloog/lnmp100.github.io.git
    git push -u origin master

Push an existing repository from the command line

    git remote add origin git@github.com:qloog/lnmp100.github.io.git
    git push -u origin master

执行完上面命令后即将博客上传至github服务器上，打开浏览器输入http://lnmp100.github.io即可访问，如果你觉的上面的命令过于复杂，你也直接可以将其添加到Makefile中

## 独立域名与DNS解析
在Godaddy上用支付宝花购买为期一年的顶级域名，并去修改Nameservers为这两个地址：f1g1ns1.dnspod.net、f1g1ns2.dnspod.net。
在Dnspod上添加新域名，并申请一条A记录指向Github Pages的ip:207.97.227.245；
在Pelican主目录新建CNAME文件，添上刚刚申请的域名，如我的www.lnmp100.com

## 参考阅读

 * [Pelican官方文档](http://docs.getpelican.com/en/latest)
 * [pelican中文文档](http://pelican-docs-zh-cn.readthedocs.org/en/latest/)
 * <http://www.linuxzen.com/shi-yong-pelicanda-zao-jing-tai-bo-ke.html>
 * <http://blog.atime.me/note/pelican-setup-summary.html>
 * <http://www.xycoding.com/articles/2013/11/21/blog-create/>
 * <http://7in0.me/2014/01/my-first-time-with-pelican/>
 * <http://jsliang.com/blog/2013/02/moving-to-pelican-hosting-on-github-pages.html>
 * <http://life-sucks.net/blog/blog-with-pelican.html>
 * <http://www.lizherui.com/pages/2013/08/17/build_blog.html>
 * [子模块操作](http://yyper.com/post/2014/01/26/gitmodules)
 * [git子模块](http://yuguo.us/weblog/git-submodule/)
