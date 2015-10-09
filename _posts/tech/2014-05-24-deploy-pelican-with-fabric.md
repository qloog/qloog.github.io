---
layout: post
title: Fabric部署pelican
category: 技术
date: 2014-05-24 22:05:10
tags: pelican fabric
---

关于pelican的部署，[前面](/note/deploy-pelican-with-make.html)通过make的方式部署过，
这里我们介绍下通过[fabric](/collection/about-fabric.html) 来部署.

## 配置 fabfile.py

主要是根据这个配置文件来执行对应的命令

    #!/usr/bin/env python
    # -*- coding: utf-8 -*-

    from datetime import datetime
    from fabric.api import *

    # 登录用户和主机名：
    env.user = 'root'
    env.hosts = ['ay'] # 如果有多个主机，fabric会自动依次部署

    def pack():
        ' 定义一个pack任务 '
        # 打一个tar包：
        tar_files = ['output/*']
        local('rm -f lnmp100.tar.gz')
        local('tar -czvf lnmp100.tar.gz --exclude=\'*.gz\' --exclude=\'fabfile.py\' %s' % ' '.join(tar_files))

    def deploy():
        ' 定义一个部署任务 '
        # 远程服务器的临时文件：
        remote_tmp_tar = '/tmp/lnmp100.tar.gz'
        tag = datetime.now().strftime('%y.%m.%d_%H.%M.%S')

        # 上传tar文件至远程服务器：
        put('lnmp100.tar.gz', remote_tmp_tar)
        # 解压：
        remote_dist_dir = '/home/wwwroot/lnmp100.com'
        run('chmod -R u+xr %s' % remote_tmp_tar)
        run('tar -xzvf %s' % remote_tmp_tar)
        run('mv output/* %s' % remote_dist_dir)
        run('rm -f output')
        # 设定新目录的www权限:
        run('chown -R www:www %s' % remote_dist_dir)
        run('rm -f %s' % remote_tmp_tar)

## 打包

打包压缩当然是为了减少传输时间

    fab pack

## 发布

    fab deploy

PS: fabfile.py 的文件名一般默认为fabfile.py，当然也可以命名为其他名字，
当不是默认名时，需要加参数-f, 当配置文件是test.py时，执行:

    fab -f test pack/deploy

