Title: SecureCRT rz 上传rar,gif等文件报错的处理方法
Date: 2011-12-09 12:18:37
Tags: SecureCRT


## 一、linux 与 windows 文件传输：rz/sz
ZModem is a full-duplex file transfer protocol that supports fast data transfer rates and effective error detection. ZModem is very user friendly, allowing either the sending or receiving party to initiate a file transfer. ZModem supports multiple file (”batch”) transfers, and allows the use of wildcards when specifying filenames. ZModem also supports resuming most prior ZModem file transfer attempts.

rz，sz是便是Linux/Unix同Windows进行ZModem文件传输的命令行工具
windows端需要支持ZModem的telnet/ssh客户端(比如SecureCRT)
运行命令rz，即是接收文件，SecureCRT就会弹出文件选择对话框，选好文件之后关闭对话框，文件就会上传到当前目录
注意：单独用rz会有两个问题：上传中断、上传文件变化(md5不同)，解决办法是上传是用rz -be，并且去掉弹出的对话框中“Upload files as ASCII”前的勾选。
-b binary 用binary的方式上传下载，不解释字符为ascii
-e 强制escape 所有控制字符，比如Ctrl+x，DEL等
-y 强制覆盖原有文件
运行命令sz file1 file2就是发文件到windows上(保存的目录是可以配置) 比ftp命令方便多了，而且服务器不用再开FTP服务了
PS：Linux上rz/sz这两个小工具安装lrzsz-x.x.xx.rpm即可。
用binary和ascii上传究竟有什么区别呢?引一段E文：  

Ascii or Binary? The general rule of thumb is if you can view the file in a text editor like notepad (ie. .html, .js, .css files etc) you should upload in ASCII mode, most others (including images, sound files, video, zip files, executable’s etc) should be uploaded in Binary.  
Exceptions to the Rule It seems all things related to computers have exceptions to the rules. Yes, this is yet another case of it.  
If your text files contain international characters (ie. Chinese or Japanese text), they are to be uploaded as binary. The reason is that ascii takes into account differences between DOS and UNIX files (7 bits) but it doesn’t do well with text using higher bits.  
Why Does It Matter What Mode You Transfer Files With? If you upload images etc. as ascii you’ll end up with corrupted files. Some browsers seem capable of figuring it out, but not all… and not all the time. Netscape is much more picky, so you’d end up with broken or missing pictures for your Netscape users. (Yup, I learned this the hard way)  
Same thing with uploading text files as binary. While this is less important for html files, scripts will have a HUGE problem with it and will just not work. This is the most common cause of the “Server 500 Error – Malformed Headers”, and other equally unlovely errors that have caused many a webmaster to bang their heads against their computers.  
So What Does Uploading In ASCII Do? I’d wondered this for a while and finally decided to learn why uploading in ascii is so important for some file types. What I found out is that different Operating System’s use different ways to specify that a line has ended. So if you’re using a different operating system than your server (which is very likely),the files will have extra characters at the end of each line that the server doesn’t recognize. So it’ll usually print them out resulting in script errors.
Setting Your FTP Program to “Auto”Most FTP programs have the option to set your upload to auto. What this usually does is compare the file type you’re transferring against a list of known file types and set it to binary or ascii upload on its own.  
By default, most FTP programs will have a pre-set list of files to be transferred in ascii and will upload / download everything else in binary. (These settings are in different places depending on the program you are using. Check the “Read Me” file or their Website if you can’t find it.) Be sure to double check that the files you want to transfer are in the appropriate list.  
SummaryASCII? Files .htm .html .shtml .php .pl .cgi .js .cnf .css .forward .htaccess .map .pwd .txt .grp .ctl
Binary Files .jpg .gif .png .tif .exe .zip .sit .rar .ace .class .mid .ra .avi .ocx .wav .mp3 .au

先设定SecureCRT上传下载文件保存路径
`options -> session -> Xmodem/Zmodem -> upload / download -> ok`
然后确认一下系统中是否有 sz rz 这两个命令(FreeBSD下命令是 lrz、lsz)
如果没有，则需要安装，安装方法可以见：http://www.lnmp100.com//10
1、将linux上文件传到PC机上

	shell> sz /etc/rc.local
例：

	[root@test root]# sz /etc/rc.local
	rz
	Starting zmodem transfer. Press Ctrl+C to cancel.
	Transferring rc.local…
	100% 464 bytes 464 bytes/s 00:00:01 0 Errors
2、将PC机上文件传到linux上

	shell> rz
选择要传送的文件，确定。  
我使用的是SecureCRT5.5  
SecureCR下的文件传输协议有ASCII、Xmodem、Zmodem  
文件传输协议  
文件传输是数据交换的主要形式。在进行文件传输时，为使文件能被正确识别和传送，我们需要在两台计算机之间建立统一的传输协议。这个协议包括了文件的识别、传送的起止时间、错误的判断与纠正等内容。常见的传输协议有以下几种：  
ASCII：这是最快的传输协议，但只能传送文本文件。  
Xmodem：这种古老的传输协议速度较慢，但由于使用了CRC错误侦测方法，传输的准确率可高达99.6%。  
Ymodem：这是Xmodem的改良版，使用了1024位区段传送，速度比Xmodem要快。  
Zmodem：Zmodem采用了串流式(streaming)传输方式，传输速度较快，而且还具有自动改变区段大小和断点续传、快速错误侦测等功能。这是目前最流行的文件传输协议。  
除以上几种外，还有Imodem、Jmodem、Bimodem、Kermit、Lynx等协议，由于没有多数厂商支持，这里就略去不讲。  
SecureCRT可以使用linux下的zmodem协议来快速的传送文件.  
你只要设置一下上传和下载的默认目录就行
`options->session options ->Terminal->Xmodem/Zmodem` 下
在右栏directory设置上传和下载的目录

## 二、使用Zmodem从客户端上传文件到linux服务器
1.在用SecureCRT登陆linux终端.  
2.选中你要放置上传文件的路径，在目录下然后输入rz命令,SecureCRT会弹出文件选择对话框，在查找范围中找到你要上传的文件，按Add按钮。然后OK就可以把文件上传到linux上了。  
或者在Transfer->Zmodem Upoad list弹出文件选择对话框，选好文件后按Add按钮。然后OK窗口自动关闭。然后在linux下选中存放文件的目录，输入rz命令。liunx就把那个文件上传到这个目录下了。  
使用Zmodem下载文件到客户端：    
`sz filename`  
zmodem接收可以自行启动.下载的文件存放在你设定的默认下载目录下.