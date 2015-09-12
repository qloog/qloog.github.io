---
layout: post
title: Swift基础教程学习笔记快速入门篇
date:  2015-04-12 23:09:00
category: 技术
tags: Swift
---


Swift是一门强类型语言，所以当不同类型的变量在处理时如果不对应就会报错。  
不过我们在定义变量的时候可以不加，系统会自动去识别对应的类型。  
建议还是定义上比较好，看着会比较清晰。

### let 和 var的区别

let: 用于定义常量  
var: 用于定义变量  

> 区别：var value can be change, after initialize. But let value is not be change, when it is intilize once.

### 键盘隐藏

可以在 touchesEnded时触发：
resignFirstResponder

### 对于xcode6模拟器运行程序后不显示键盘，可能是因为连接到了真机键盘。

只需要打开模拟器，在菜单栏中选择：
设置模拟器：hardware -> keyboard -> connect hardware keyboard(快捷键shift+command+k)
默认情况下，xcode使用电脑键盘作为外接键盘，不再弹出虚拟键盘。

### 三个结构体 (貌似是oc里的)
CGPoint
CGSize 
CGRect 表示一个矩形的位置和大小

### 三元运算符

> see: https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/BasicOperators.html#//apple_ref/doc/uid/TP40014097-CH6-ID60

	a ?? b
	
	a != nil ? a! : b

	let defaultColorName = "red"
	var userDefinedColorName: String?   // defaults to nil
	 
	var colorNameToUse = userDefinedColorName ?? defaultColorName
	// userDefinedColorName is nil, so colorNameToUse is set to the default of "red
	
	userDefinedColorName = "green"
	colorNameToUse = userDefinedColorName ?? defaultColorName
	// userDefinedColorName is not nil, so colorNameToUse is set to "green"




## 常量和变量

	var a = 1
	a = 10
	var b = 2

	//定义后不可修改
	let c = a+b  

	pirntln(c)

## 类型

	//单引号的字符串会报错  
	var str="Hello"  

	//手动指明类型  
	var s:String = "world"  
	var i:Int = 100  
	var words:String = "test"  
	//可以不加，会自动做类型推断  

	println(str)

## 字符串连接操作

	var i = 100  
	var str = "Hello"  
	str = str + "jikexuanyuan"  
	//字符串加数字,会报错，需要做类型转换；或者用下面的操作：  
	str = "\(str), abcdef, \(100)"  
	str = "\(str), abcdef, \(i)"  

	//定义空字符串, 两个都是空，而且是相等的  
	var emptyString = ""  
	var anthorEmptyString = String()

	println(str)

	//判断字符串是否为空
	if emptyString.isEmpty() {
		println("Nothing to see here")
	}

	//字符串追加
	var welcome = "Hello"  
	let mark = "!"  
	welcome.append(mark) //Hello!

## 数组

	var arr = ["Hello", "jikexueyuan", 100, 2.3]
	println(arr)

	//空数组  
	var arr1 = []  
	//特定类型的空数组  
	var arr2 = [String]()

## 字典

	var dict = ["name":"jikexueyuan", "age":"16"]
	//动态赋值
	dict["sex"] = "Female"
	println(dict)
	//取特定值
	println(dict["name"])

	//类型要对应  
	var airports: [String: Int] = ["YYZ": 111, "DUB": 222]  
	var airports: [String: String] = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]
	//也可以不定义类型  
	var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

## 循环

	1.索引
	var arr = [String]()

	for index in 0...100{
		arr.append("Item\(index)")
	}
	println(arr)

	2.arr
	for value in arr{
		println(value)
	}

	3. while
	var i = 0
	while i<arr.count {
		println(arr[i])
		i++
	}

	4. 字典
	var dict = ["name":"jiekexueyuan", "age":16]
	for (key, value) in dict{
		println("\(key),\(value)")
	}

## 流程控制

	for index in 0..100{
		if index%2==0 {
			println(index)
		}
	}

	//带问号的是可选变量
	var myName:String?="jikexueyuan"
	//空赋值
	myName = nil 	

	if let name=myName {
		println("Hello \(name)")
	}

## 函数

	//需要指名类型，否则会报错
	func sayHello(name:String){
		println("Hello \(name)")
	}

	syaHello("jikexeuyuan")

	//当返回多个值的时候，需要对每一个做类型定义

	func getNums()->(Int, Int){
		return (2,3)
	}

	//使用
	let (a, b) = getNums()
	println(a)

	//函数当变量使用, 同时函数内也可以再写函数（闭包）
	var fun = sayHello()
	fun("shangsan")


## 面向对象

//可以有多个构造方法，但不能参数相同，否则认为是重复定义了，可以是参数不同的多个构造方法  

	class Hi{
		
		func sayHi() {
			println("Hi jikexueyuan")
		}
	}

//继承
	class Hello:Hi(){
		
		var _name:String
		
		//构造方法
		init(name:String) {
			self._name = name
		}
		
		//重写方法，需要加 override
		override func sayHi(){
			//println("Hello jiexiueyuan")
			println("Hello \(self._name)")
		}
	}
	
	var hi = Hi()
	hi.sayHi()
	
	var h = Hello()
	h.sayHi()

//有构造方法的时候
var h = Hello(name: "zhangsan")
h.sayHi()  

 > 类中的 静态方法不能被重写，而类方法可以被重写


## 开发IOS项目

	viewController 里写：
	
	@IBOutlet var wv:UIWebView
	
	viewDidLoad(){
		wv.loadRequest(NSURLRequest(URL:NSURL(String:"http://jikexueyuan.com")))
	}

  
//强制转换为字典，  as?  为强制转换

	if error == nil {
		if let json = NSJSONSerialization.XXXXXXX   as? NSDictionary {
	
		}
	}
	
查看当前系统swift的版本号：

	➜  ~  xcrun swift --version
	Apple Swift version 1.2 (swiftlang-602.0.53.1 clang-602.0.53)
	Target: x86_64-apple-darwin14.5.0
	➜  ~


	







