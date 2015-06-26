Title: SSH会话连接超时的解决方法
Date: 2013-06-19 20:55:21
Tags: ssh, 会话超时

## SSH会话连接超时的解决方法

用SSH客户端连接linux服务器时，经常会出现与服务器会话连接中断现象，照成这个问题的原因便是SSH服务有自己独特的会话连接机制。连自己的VPS经常会断开，时间久了感觉挺讨厌，以下是两种解决方法。

### 方法一：

1、设置服务器向SSH客户端连接会话发送频率和时间
    
    
    #vi /etc/ssh/sshd_config，添加如下两行
    ClientAliveInterval 60
    ClientAliveCountMax 86400
    

注：  
ClientAliveInterval选项定义了每隔多少秒给SSH客户端发送一次信号；  
ClientAliveCountMax选项定义了超过多少秒后断开与ssh客户端连接

2、重新启动系统SSH服务
    
    
    #service sshd restart  
    

### 方法二：

使用命令直接用户修改配置文件，设置“TMOUT=180”，即超时时间为3分钟
    
    
    #vim /etc/profile 添加下面两行
    #设置为3分钟
    TMOUT=180
