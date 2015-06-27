---
layout: post
title: Python采集博客园的新闻资讯
date: 2012-11-22 20:58:52
category: 技术
tags: Python 采集
---

最近想采集点新闻放到自己原本空空的表里，听说是Python挺方便，所以就用Python来采集，顺便练练手。 

## 环境 

  系统：CentOS 5.4 

  Python: 2.7.3 
  

## 附上具体的采集代码 
    
    
    #! /usr/bin/env python 
    # -*- coding: utf-8 -*- 
    
    import urllib
    import re,sys
    import string
    from xml.dom.minidom import parseString
    from sgmllib import SGMLParser  
    import MySQLdb
    import time
    reload(sys)
    sys.setdefaultencoding('utf8')
    
    
    class Constants:
        #站点
        HTML_SITE = "http://news.cnblogs.com"
        #聚体资源
        HTML_RESOURCE = HTML_SITE + "/news/rss"  
        #数据库配置
        DB_HOST = "localhost"     
        #数据库用户名
        DB_USER = "root"
        #数据库密码
        DB_PASSWORD = ""
        #数据库
        DB_DATABASE = "test"
        #数据库连接编码集
        CHARSET = "utf8"
        #代理服务器
        PROXY_ADRESS = ""
        #代理用户名
        PROXY_USERNAME = ""
        #代理用户密码
        PROXY_PASSWORD = ""
        #图片本地保存路径
        IMG_LOCALDSTDIR = "E:/image/"
        
    
        
    class ListUrls(SGMLParser):  
        def reset(self):  
            self.imgs = []  
            SGMLParser.reset(self)  
        def start_img(self, attrs):  
            src = [v for k, v in attrs if k == 'src']  
            if src:  
                self.imgs.extend(src)
    #数据库工具类
    class DBUTIL():
        def  getConnectionDB(self):
            try:
                conn = MySQLdb.connect(host=Constants.DB_HOST, user=Constants.DB_USER, passwd=Constants.DB_PASSWORD, db=Constants.DB_DATABASE, charset=Constants.CHARSET)
                return conn
            except:
                print "EROOR: get ConnectionDB is FAIL"
            
    #文章对象用于从网站中爬取然后存储在DB中
    class  actrict():
        title = ''
        source_link = ''
        createtime = ''
        body = ''
        
    class webcrawlerhttpurl(): 
        #获取HTML内容   
        def getUrlInfo(self, weburl):
            try :
                #proxyConfig = 'http://%s:%s@%s' % (Constants.PROXY_USERNAME, Constants.PROXY_PASSWORD, Constants.PROXY_ADRESS)
                #inforMation = urllib.urlopen(weburl, proxies={'http':proxyConfig})
                inforMation = urllib.urlopen(weburl)
                #header = inforMation.info()            
                #contentType = header.getheader('Content-Type')           
                status = inforMation.getcode()           
                if status == 200:            
                    html = inforMation.readlines()                        
                    return html    
                else:
                    return 'ERROR: get web %s% is fail and status=%s' % (weburl, status);
            except:
                print 'ERROR: get web %s% is fail' % (weburl);
            finally:
                inforMation.close()    
                
        #解析HTML
        def parseHtml(self, html, link):
            try:
                #body是一个list，需要转成string
                document = ""
                for line in html:
                    if line.split():
                        document = document + line
    
                #content
                content = document[re.search("news_body", doc).end():]
                content = content[:re.search("news_otherinfo", content).end()]  
                content = content.replace("'", "\\'") 
                print content
          
            except:
                print 'ERROR:PARSEHTML IS FAIL %s' % (link)        
            return content
        #解析RESS然后访问其中每个具体资源
        def parseRessXml(self, xml_file):  
                #body是一个list，需要转成string
                document = ""
                for line in xml_file:
                    document = document + line            
                doc = parseString(document)
                pkgs = doc.getElementsByTagName("item")            
                #遍历所有的资源地址
                i = 0;
                for pkg in pkgs:
                    try:
                        i = i + 1
                        print '-------------------PARSE HTML (%s)-----------------' % (i)
                        title = pkg.getElementsByTagName("title")
                        title = self.getText(title[0].childNodes)
                        link = pkg.getElementsByTagName("link")
                        link = self.getText(link[0].childNodes)
                        description = pkg.getElementsByTagName("description")
                        description = self.getText(description[0].childNodes)
                        createtime = pkg.getElementsByTagName("pubDate")
                        createtime = self.getText(createtime[0].childNodes)
       
                        #判断文章是否已存在
                        conn = DBUTIL().getConnectionDB()
                        cur = conn.cursor()                       
                        SQL = "SELECT COUNT(1) FROM core_pages WHERE source_link='%s'"%(link)
                        cur.execute(SQL)
                        alldata = cur.fetchall()
                       
                        if alldata[0][0] != 0:
                            print "Warning: DB already exist for this article"
                            continue;
                        
                        #封装成actrict类
                        actrict.title = title
                        actrict.source_link = link
                        actrict.createtime = time.time()
                        actrict.body = description 
                        #进行存本地数据库
                        self.putDB(actrict)
                    except :
                        print "ERROR: PARSE_XMLRESS IS FAIL %s" % (link)
    
        #解析XML取字符
        def getText(self, nodelist):
            rc = ""
            for node in nodelist:
                if node.nodeType == node.TEXT_NODE:
                    rc = rc + node.data
                if node.nodeType == node.CDATA_SECTION_NODE:
                    rc = rc + node.data
            return rc
        #保存图片文件
        def saveimg(self, imgs):
            for img in imgs :
                try:
                    if string.find(img, 'http') != 0:
                        img = Constants.HTML_SITE + img 
                    DstDir = Constants.IMG_LOCALDSTDIR          
                    imgPath = DstDir + img.split("/")[-1].split(";")[0]
                    print imgPath 
                    File = open(imgPath, "wb") 
                    #proxyConfig = 'http://%s:%s@%s' % (Constants.PROXY_USERNAME, Constants.PROXY_PASSWORD, Constants.PROXY_ADRESS)
                    #inforMation = urllib.urlopen(img, proxies={'http':proxyConfig})
                    inforMation = urllib.urlopen(img)
                    jpg = inforMation.read()
                    File.write(jpg)
                    print("INFO: SAVE IMG:" + imgPath)
                except :
                    print "ERROR: SAVA IMG IS FAIL:%s" % (img)
                finally:
                    inforMation.close()
                    File.close()
      
        #存储DB
        def putDB(self, actrict):
    
            title = actrict.title
            source_link = actrict.source_link
            createtime = actrict.createtime
            body = actrict.body
            print title
            try:    
                conn = DBUTIL().getConnectionDB()
                cur = conn.cursor()                       
                SQL = "INSERT INTO core_pages(cid,type,uid,title,body,createtime,source_link)VALUES\
                ('%s','%s','%s','%s','%s','%s','%s')" % (3,'news',1,title, body, createtime,source_link)
                cur.execute(SQL)
                conn.commit()
                print "INFO: SAVE ACTRICT IS SUCCESSFUL"
            except :
                    print "ERROR: SAVE ACTRICT IS FAIL"
            finally:     
                cur.close()      
                conn.close()
