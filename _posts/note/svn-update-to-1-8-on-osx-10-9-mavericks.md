Title: SVN Update to 1.8 on OSX 10.9 (Mavericks)
Date: 2014-03-03 22:18:03
Tags: svn, OSX, Mavericks

## SVN Update to 1.8 on OSX 10.9 (Mavericks)

在刚刚装了zsh后，准备用svn提交的时候发现提示版本太低，于是想到了升级svn版本，准备直接升级到1.8.x版本，截止到安装时的最新版本是1.8.8，中间也碰到了不少问题，试了几个都不行，下面的步骤是真实可用的，亲测。

### Requirement:

Xcode command line tool: can be download at Apple's dev center or install command line tool without Xcode. Setup the Tool chain:
    
    
    sudo ln -s /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/ /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.9.xctoolchain 
    

The key is to link the toolchain to reflect new version # of Maverick, which is 10.9. The SVN source: can be download form Apache SVN project. Here's straight way in command:
    
    
    cd ~/Downloads/ 
    curl -o subversion-1.8.3.tar.gz http://archive.apache.org/dist/subversion/subversion-1.8.3.tar.gz tar -xvf subversion-1.8.3.tar.gz
    

### Build and Install SVN

### Build serf

First we will need to build serf, included in the subversion package.
    
    
    cd ~/Downloads/subversion-1.8.3 
    sh get-deps.sh serf 
    cd serf/ 
    ./configure make sudo make install
    

### Build SVN

Go back up to the SVN source root, and build it using serf. Depend on your hardware, it might takes awhile. If you need a coffee, this is good time to do so once you start the make.
    
    
    cd .. 
    ./configure --prefix=/usr/local --with-serf=/usr/local/serf 
    make 
    sudo make install
    

## Wrap it up

Now you've the new SVN 1.8.3 installed at /usr/local/bin. Make sure your path includes it. From there you should able to: svn --version And here you go:

svn, version 1.8.3 (r1516576) compiled Oct 24 2013, 02:38:35 on x86_64-apple-darwin13.0.0

Copyright (C) 2013 The Apache Software Foundation. This software consists of contributions made by many people; see the NOTICE file for more information. Subversion is open source software, see http://subversion.apache.org/

The following repository access (RA) modules are available:

  * ra_svn : Module for accessing a repository using the svn network protocol. 
    * with Cyrus SASL authentication
    * handles 'svn' scheme
  * ra_local : Module for accessing a repository on local disk. 
    * handles 'file' scheme
  * ra_serf : Module for accessing a repository via WebDAV protocol using serf. 
    * using serf 1.2.1
    * handles 'http' scheme
    * handles 'https' scheme
