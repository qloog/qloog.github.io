Title: CentOS VPS上安装VPN教程
Date: 2011-11-05 22:55:30
Tags: VPS, CentOS, VPN


为了能翻个墙，浏览下国外网站，今天也自己安装一个VPN,方便使用！

一、 首先检查你VPS的PPP和TUN有没有启用：

> cat /dev/ppp cat /dev/net/tun

显示结果为：

> cat: /dev/ppp: No such device or address和cat: /dev/net/tun: File descriptor in bad

表明通过，上述两条只要有一个没通过都不行。如果没有启用，你可以给VPS提供商Submit 一个 Ticket请求开通： Hello Could you enabled TUN-TAP for me? I want run pptp-vpn on my VPS. Thank you. 确认PPP和TUN启用后，开始安装ppp和iptables：

> yum install -y ppp iptables

![11](/static/uploads/2011/11/11.png)

二、安装pptp：

> rpm -ivh http://acelnmp.googlecode.com/files/pptpd-1.3.4-1.rhel5.1.i386.rpm（32位系统） rpm -ivh http://acelnmp.googlecode.com/files/pptpd-1.3.4-1.rhel5.1.x86_64.rpm（64位系统）

![12](/static/uploads/2011/11/12.png) 

三、配置pptp，编辑/etc/pptpd.conf文件：

> vim /etc/pptpd.conf

![13](/static/uploads/2011/11/13.png) 

把下面字段前面的#去掉：

> localip 192.168.0.1 remoteip 192.168.0.234-238,192.168.0.245

![14](/static/uploads/2011/11/14.png) 

四、编辑/etc/ppp/options.pptpd 文件：

> vim /etc/ppp/options.pptpd

![15](/static/uploads/2011/11/15.png) 

去掉ms-dns前面的#，并使用Google的DNS服务器，修改成如下字段：

> ms-dns 8.8.8.8 ms-dns 8.8.4.4

![16](/static/uploads/2011/11/16.png) 

五、设置VPN账号密码，编辑/etc/ppp/chap-secrets这个文件：

> vim /etc/ppp/chap-secrets

![](//static/uploads/2011/11/17.png) 

六、修改内核设置，使其支持转发，编辑 /etc/sysctl.conf 文件：

> vim /etc/sysctl.conf

将"net.ipv4.ip_forward"的值改为1，同时在"net.ipv4.tcp_syncookies = 1"前面加# ![18](/staic/uploads/2011/11/18.png) 

七、使sysctl.conf配置文件生效并添加iptables转发规则：

> sysctl -p iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j SNAT --to-source ***.***.***.***

(***.***.***.***为你VPS的公网IP地址) 保存iptables转发规则：

> /etc/init.d/iptables save

重启iptables：

> /etc/init.d/iptables restart

重启pptp服务：

> /etc/init.d/pptpd restart

设置开机自动运行pptp服务：

> chkconfig pptpd on

设置开机自动运行iptables服务：

> chkconfig iptables on

![19](/static/uploads/2011/11/19.png) 

至此，Linux VPS架设VPN完成，如果连接出现错误619则输入如下命令解决：

> rm /dev/ppp mknod /dev/ppp c 108 0

如果出现错误734则修改/etc/ppp/options.pptpd文件，在require-mppe-128字段前面加#然后windows客户端连接按下图设置即可。 ![20](/static/uploads/2011/11/20.png) 

最后附上一个下载地址： [pptpd](/static/uploads/2011/11/pptpd.zip) 使用说明如下：

解压 unzip pptpd.zip #修改权限 chmod +x pptpd.sh #执行安装 sh pptpd.sh

OK，现在可以连接VPN来浏览国外网站了！
如果连接VPN后，无法上网，常用的解决方法：

1、修复连接，主要是用于清空DNS缓存，如图： ![dns_repire](/static/uploads/2011/11/dns_repire.jpg) 

注：如果清空后依然无法上，可以尝试重启电脑。

2、在VPN中修改DNS为谷歌DNS：8.8.8.8 ![vpn_dns](/static/uploads/2011/11/vpn_dns.jpg)


