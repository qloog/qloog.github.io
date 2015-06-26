Title: window下MongoDB的安装
Date: 2012-03-05 17:08:47


MongoDB 主页 <http://www.mongodb.org/>  
1、下载 在 http://www.mongodb.org/display/DOCS/Downloads 选择你要下载的版本. 我这里下载win32位的：http://downloads.mongodb.org/win32/mongodb-win32-i386-2.0.3.zip   
2、建立MongoDB数据存放目录及日志目录，例如：d:\DB\data ，d:\DB\log  
3、设置存放数据库文件的路径及日志目录 进入 cmd 提示符控制台


    D:\mongodb\bin> mongod.exe --dbpath=d:\DB\data --logpath=d:\DB\log\mongodb.log --rest

(这个cmd不要关了!)  

4、新打开一个CMD输入：d:\mongodb\bin>mongo.exe，如果出现下面提示，恭喜你安装成功了，很简单吧。 ![mongo_start](/static/uploads/2012/03/mongo_start.jpg)  
5、安装MongoDB到windows service里，这样避免每次开机手动启动。


    D:\>mongodb\bin\mongod.exe --dbpath d:\DB\data --logpath d:\DB\log\mongodb.log --install

  6、测试


    D:\mongodb\bin>mongo.exe

    MongoDB shell version: 2.0.3

    connecting to: test

    type "exit" to exit

    type "help" for help

    > use test

    switched to db test

    > db.foo.save({hello:1,word:2})

    > db.foo.find()

    { "_id" : ObjectId("4bc1854e0140000000006f05"), "hello" : 1, "word" : 2 }
