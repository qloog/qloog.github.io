Title: textmate常用快捷键备忘
Date: 2013-03-09 21:48:30
Tags: textmate

mac下一款不错的工具，熟悉下快捷键还是有好处的。

## 视图切换
    	Ctrl + Option + Cmd + D     # 显示/隐藏左边文件导航树
    	Cmd + Option + W            # 切换代码折行
    	Cmd + Option + ->           # 切换左右Tab页
    	Cmd + Option + <-
    	Cmd + Shift + {             # 切换左右Tab页
    	Cmd + Shift + }
##  目录树视图
    	Ctrl + Cmd + R              # 跳转到当前打开文件所在的目录树的位置
    	Cmd + Up/Down               # 左边目录树向上，向下进入一层 
    	Cmd + Shift + Y             # 切换到文件的Git状态视图
##  文件导航
    	Cmd + T                     # 快速打开项目中文件
    	Cmd + Shift + T             # 快速打开当前文件里面的方法
    	Cmd + Option + Up           # 在同名文件中跳转(例如Tire.m ,Tire.h)
    	Cmd + Option + Down         # 在关联文件中跳转(例如topic.rb, topic_test.rb)
##  光标跳转
    	Ctrl + Tab                  # 切换到左边的导航树窗口
    	Shift + Tab                 # 切换到右边的代码编辑器窗口
    	Ctrl + V                    # 光标向下跳一个段落
    	Option + Up/Down            # 向上或者向下跳转一个段落
    	Cmd + Enter                 # 光标跳到当前行的下一行开始处
    	Cmd + L                     # 跳转到某行
    	Ctrl + Shift + ( )          # 在括号开闭间跳转
    	Ctrl + Up/Down              # 移动到括号开始和结束的地方
##  代码选择
    	Ctrl + W                    # 选择当前词汇
    	Ctrl + Option + B           # 选择当前字符串
    	Cmd + Shift + B             # 选择当前括号
    	Cmd + Shift + L             # 选择当前行
    	Ctrl + Option + P           # 选择整个段落
    	Option + Shift + Up/Down    # 向上或者向下选择一个段落
##  代码格式化
    	Cmd + [                     # 整块左移
    	Cmd + ]                     # 整块右移
    	Cmd + Option + [            # 对选中的多行代码进行格式化
##  代码折叠
    	F1                          # 折叠和展开代码段
    	Cmd + Option + 1            # 折叠顶层
    	Cmd + Option + 2            # 折叠第二层
    	Cmd + Option + 3            # 折叠第三层
##  代码编辑
    	Cmd + Shift + V             # 按照历史拷贝顺序来粘贴
    	Ctrl + Cmd + Option + V     # 显示剪贴板
    	Cmd + /                     # 注释和取消代码块注释
    	Cmd + Option + A            # 对多行内容进行同样的编辑
    	ESC                         # 自动补齐当前文件已经出现过的关键词
##  查找和替换
    	Ctrl+ S                     # 在当前文件下面出现搜索框，在当前文件快速扫描
    	Cmd + F                     # 在当前文章中查找
    	Cmd + Shift + F             # 在项目当中查找
    	Cmd + G                     # 继续查找下一个匹配
    	Cmd + Shift + G             # 查找上一个匹配
    	Cmd + Option + F            # 替换掉然后继续查找下一个
    	Cmd + Ctrl + F              # 当前文件全部替换
##  窗口操作
    	Cmd + W                     # 关闭当前Tab页
    	Cmd + Shift + W             # 关闭当前项目窗口
    	Cmd + Option + N            # 在当前项目里创建新文件
    	Option + F2                 # 显示当前文件的上下文菜单
    	Option + F1                 # 显示当前bundle的上下文菜单
    	Ctrl + Cmd + T              # 对bundle功能进行快捷选择
    	Ctrl + Shift + T            # 显示当前项目的TODO条目
##  HTML bundle
    	Ctrl + Shift + <            # 自动生成HTML标签
    	Ctrl + Shift + W            # 对选择的文字用HTML标签包围
    	Cmd + Option + .            # 对HTML tag进行结束标签补齐
    	Ctrl + Shift + Cmd + W      # 对选择的文字段落用HTML标签包围（多行模式，每行一个标签）
##  Rails bundle
    	Cmd + Option + Shift + Down # 切换Controller/View/Model/Test
    	Cmd + Option + Down         # 切换Model/Test, Controller/View 
    	Ctrl+ F                     # 跟踪类和方法的源代码定义
    	Ctrl + Shift + >            # 自动补齐 <%= %>
    	Ctrl + P                    #  params[:id]
    	Ctrl + J                    #  session[:user]
    	Ctrl + L                    #  =>
    	: Tab                       # Hash
##  TextMate 列编辑模式
    按住Option，用鼠标选择要插入字符的行。如果仅仅插入字符，注意选择0列，选择多列的话会把它们覆盖掉。选择完毕应该看到一条细细的竖线，然后输入要插入的字符。TextMate 会实时显示所有的更改。
