Title: ulimit -SHn 65535 含义详解
Date: 2012-04-22 22:57:46
Tags: ulimit


linux下用ulimit设置连接数最大值，默认是1024. 在高负载下要设置为更高，但最高只能为65535. ulimit只能做临时修改，重启后失效。

可以加入 `ulimit -SHn 65535` 到 /etc/rc.local 每次启动启用。
终极解除 Linux 系统的最大进程数和最大文件打开数限制：

`vim /etc/security/limits.conf`

 # 添加如下的行

	* soft nproc 11000 * hard nproc 11000 * soft nofile 655350 * hard nofile 655350
