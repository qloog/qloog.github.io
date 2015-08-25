---
layout: post
title: Linux VPS/服务器 网站及数据库自动本地备份并FTP上传备份脚本
date: 2011-10-22 02:09:34
category: 收藏
tags: VPS 备份
---


从建站之初就一直在重申一定要备份好自己的数据，因为太多的不确定性可能会造成数据库丢失，而且大部分VPS服务商也不可能提供每天备份数据。 

现分享一个自己的备份脚本。 

准备工作： 需要提前在VPS安装好lftp，lftp功能上比较强大，

CentOS直接执行：**yum install lftp**，

Debian执行：**apt-get install lftp** 。 

需要在VPS上创建/home/backup/ 目录，在FTP上创建backup目录。 如果VPS上数据库不多的话使用[Godaddy](http://www.godaddy.com)的免费空间就可以(10GB空间，300GB流量)，只要注册个域名就免费送。  下面将备份脚本进行部分注释：  
    
    
    #!/bin/bash
    #Funciont: Backup website and mysql database
    #Author: licess
    #Website: http://www.lnmp100.com
    #IMPORTANT!!!Please Setting the following Values!
    
    ######~Set Directory you want to backup~######将下面的目录修改成自己要备份的目录，一般按我的都是在/home/wwwroot/下面所有直接写了需要备份的目录。可以继续再加：Backup_Dir5=你的目录 ，Backup_Dir后面的数字依次递增。如果不足4个，直接删除不需要的就可以，同时修改下面tar zcf 部分。
    
    Backup_Dir1=vpser.net
    Backup_Dir2=lnmp.org
    Backup_Dir3=licess.org
    Backup_Dir4=jungehost.com
    
    ######~Set MySQL UserName and password~######设置MySQL的用户名和密码，最好是root，其他用户可能因为权限问题无法导出部分数据库。
    MYSQL_UserName=root
    MYSQL_PassWord=yourmysqlrootpassword
    
    ######~Set MySQL Database you want to backup~######设置要部分的数据库，可以继续再加：Backup_Database_Name5=数据库名，Backup_Database_Name后面的数字依次递增。
    Backup_Database_Name1=vpser
    Backup_Database_Name2=licess
    Backup_Database_Name3=junge
    Backup_Database_Name4=vpserorg
    
    ######~Set FTP Information~######设置用来存放备份数据的FTP信息
    FTP_HostName=184.168.192.43   //FTP服务器的IP或者域名
    FTP_UserName=vpsernet                //FTP服务器用户名
    FTP_PassWord=yourftppassword   //FTP服务器用户对应的密码
    FTP_BackupDir=backup                    //备份到FTP上的目录，需要提前创建好。
    
    #Values Setting END!
    
    TodayWWWBackup=www-*-$(date +"%Y%m%d").tar.gz
    TodayDBBackup=db-*-$(date +"%Y%m%d").sql
    OldWWWBackup=www-*-$(date -d -3day +"%Y%m%d").tar.gz
    OldDBBackup=db-*-$(date -d -3day +"%Y%m%d").sql
    
    tar zcfP /home/backup/www-$Backup_Dir1-$(date +"%Y%m%d").tar.gz /home/wwwroot/$Backup_Dir1 --exclude=soft
    tar zcfP /home/backup/www-$Backup_Dir2-$(date +"%Y%m%d").tar.gz /home/wwwroot/$Backup_Dir2
    tar zcfP /home/backup/www-$Backup_Dir3-$(date +"%Y%m%d").tar.gz /home/wwwroot/$Backup_Dir3 --exclude=test
    tar zcfP /home/backup/www-$Backup_Dir4-$(date +"%Y%m%d").tar.gz /home/wwwroot/$Backup_Dir4
    
    ###上面为备份网站文件数据，因为我的网站比较零散，而且网站目录下面有些目录属于临时目录并不需要备份，所以可以在上面加上--exclude=不备份的目录。如果在前面加了Backup_Dir5=yourdir，则再加tar zcf /home/backup/www-$Backup_Dir5-$(date +"%Y%m%d").tar.gz
    /home/wwwroot/ $Backup_Dir5 。如果多余则删除多余行。
    
    /usr/local/mysql/bin/mysqldump -u$MYSQL_UserName -p$MYSQL_PassWord $Backup_Database_Name1 > /home/backup/db-$Backup_Database_Name1-$(date +"%Y%m%d").sql
    /usr/local/mysql/bin/mysqldump -u$MYSQL_UserName -p$MYSQL_PassWord $Backup_Database_Name2 > /home/backup/db-$Backup_Database_Name2-$(date +"%Y%m%d").sql
    /usr/local/mysql/bin/mysqldump -u$MYSQL_UserName -p$MYSQL_PassWord $Backup_Database_Name3 > /home/backup/db-$Backup_Database_Name3-$(date +"%Y%m%d").sql
    /usr/local/mysql/bin/mysqldump -u$MYSQL_UserName -p$MYSQL_PassWord $Backup_Database_Name4 > /home/backup/db-$Backup_Database_Name4-$(date +"%Y%m%d").sql
    
    ###上面为备份MySQL数据库，如果在前面加了Backup_Database_Name5=yourdatabasename，则再加/usr/local/mysql/bin/mysqldump -u$MYSQL_UserName -p$MYSQL_PassWord $Backup_Database_Name5 > /home/backup/db-$Backup_Database_Name5-$(date +"%Y%m%d").sql 。如果多余则删除多余行。
    
    rm $OldWWWBackup
    rm $OldDBBackup
    ###删除3天前的备份###
    
    cd /home/backup/
    
    ###下面为自动上传部分，不得不说lftp很强大，抛弃ftp吧####
    lftp $FTP_HostName -u $FTP_UserName,$FTP_PassWord << EOF
    cd $FTP_BackupDir
    mrm $OldWWWBackup
    mrm $OldDBBackup
    mput $TodayWWWBackup
    mput $TodayDBBackup
    bye
    EOF

脚本下载地址：http://soft.vpser.net/lnmp/backup.sh [下载脚本](http://soft.vpser.net/lnmp/backup.sh)，将脚本放到/root/ 下面，  
按上面的注释修改脚本中的参数，并保存，如果不熟悉vi或者nano编辑器，可以用winscp，  
执行：`chmod +x /root/backup.sh` 为脚本添加执行权限，  
执行：`crontab -e` 添加定时执行 在crontab中加入：`0 3 * * * sh /root/backup.sh`   
凌晨3点自动执行/root/bakcup.sh 脚本，备份vps上的数据并上传到FTP上。 

**原文链接地址：<http://www.vpser.net/security/linux-autobackup-ftp.html>**