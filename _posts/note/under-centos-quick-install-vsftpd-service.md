Title: CentOS下快速安装vsftpd服务
Date: 2012-05-02 14:46:25
Tags: CentOS, vsftpd


有时需要快速搭建一个FTP服务端，让其他人来上传文件，可以将安装ftp的命令放到一个脚本里，以vsftpd为例。    

1、将以下代码输入到： install_vsftpd.sh 里。 
    
    
    echo "============================install vsftpd=================================="
    yum -y remove vsftpd
    yum -y install vsftpd
    
    rm -f /etc/vsftpd/vsftpd.conf
    cat >>/etc/vsftpd/vsftpd.conf<<EOF
    # Example config file /etc/vsftpd/vsftpd.conf
    #anonymous_enable=YES
    local_enable=YES
    write_enable=YES
    local_umask=022
    #anon_upload_enable=YES
    #anon_mkdir_write_enable=YES
    dirmessage_enable=YES
    xferlog_enable=YES
    connect_from_port_20=YES
    #chown_uploads=YES
    #chown_username=whoever
    #xferlog_file=/var/log/xferlog
    xferlog_std_format=YES
    #idle_session_timeout=600
    #data_connection_timeout=120
    #nopriv_user=ftpsecure
    #async_abor_enable=YES
    #ascii_upload_enable=YES
    #ascii_download_enable=YES
    ftpd_banner=Welcome to FTP service.
    #deny_email_enable=YES
    #banned_email_file=/etc/vsftpd/banned_emails
    #chroot_list_enable=YES
    #chroot_list_file=/etc/vsftpd/chroot_list
    #ls_recurse_enable=YES
    listen=YES
    #listen_ipv6=YES
    pam_service_name=vsftpd
    userlist_enable=YES
    tcp_wrappers=YES
    use_localtime=YES
    chroot_local_user=YES
    EOF
    
    #权限设置
    setsebool -P ftpd_disable_trans 1
    
    #初次启动无需重启服务，后面会重启服务器
    cat >>/etc/rc.local<<EOF
    service vsftpd restart
    EOF
    
    #创建ftp账号
    echo "============================ ftp username and password ========================="
    mkdir -p /web/http
    useradd -d /web/http bibinet
    setfacl -R -m u:bibinet:rwx /web/http/
    passwd bibinet
    #查看账号
    #finger bibinet

  2、修改权限 `chmod 777 install_vsftpd.sh`    
  3、执行 `sh install_vsftpd.sh`   ok,搭建完成。
