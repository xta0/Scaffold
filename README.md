VZScaffold
=============

* VZScaffold 是一个命令行工具，它可以根据[Vizzle](https://github.com/Vizzle/Vizzle)自动生成Objective-C的代码模板

* 它的使用方式借鉴了Rails中的代码生成工具——Scaffold:

How to Use it
=============

VZScaffold使用ruby编写，在MAC上无需安装，可以直接使用：

`% cd scaffold`

`% ruby scaffold.rb --help`

输出如下：

`Usage: scaffold [options]`

`-p Package name, Package type, Optional package config file Path`

`-c ClassName,SuperClass,Path`

`-h, --help`


参数`-p`用来生成一个package，它包括：

* 完整的MVC代码
* Model的单元测试代码
* config文件和文件夹
* resource文件夹

参数 `-c`用来生成某个单独类的模板


Example
=============

* 例1 ： 我们要生成一个新业务包，名字叫MainPage，可输入下面命令：

`% ruby scaffold.rb -p MainPage`

* 例2 ： 我们要生成一个新业务包，名字叫MainPage，类型是一个list，可输入下面命令:

`% ruby scaffold.rb -p MainPage,type:list`

* 例3 ： 我们要生成一个类，名字叫MainPageModel，可输入下面命令:

`% ruby scaffold.rb -c MainPageModel:VZHTTPListModel`

* 例4 ： 我们要生成一个类，名字叫MainPageItem，并自动生成response.json文件中对应字段的的property，可输入下面命令:

`% ruby scaffold.rb -c MainPageItem:VZListItem,./response.json`


Template
=============

所有的代码模板在`./template/vizzle`文件夹下




