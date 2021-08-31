# 什么是Flask

Flask是使用python编写的Web微框架 `micro framework`（Flask核心简单且易于扩展，所以被称为微框架）。

Flask有两个主要依赖，一个是WSGI(Web Server Gateway Interface， Web服务器网关接口)工具集——`Werkzeug`，另一个是模板引擎`Jinja2`。

Flask只保留了Web开发的核心功能，其他的功能都由外部扩展实现，比如数据库集成、表单验证、文文件上传等。如果没有合适的扩展，你甚至可以自己动手开发。Flask不会替你做决定，也不会限制你的选择。总之，Flask可以变成任何你想要的东西，一切由开发者做主。



# 虚拟环境

在Python中，虚拟环境（virtual environment）就是隔离的python解释器环境。

通过创建虚拟环境，你可以拥有一个独立的python解释器环境，因为不同的项目常常会依赖不同版本的库或python版本。使用虚拟环境可以保持全局python解释器环境的干净，避免包和版本的混乱，并且可以方便地分区和记录每个项目的依赖，以便在新环境下复现依赖环境。



# 注册路由

- 客户端和服务器上的Flask程序的交互步骤：

  1. 用户在浏览器输入URL访问某个资源；

  2. Flask接收用户请求并分析请求的URL；

  3. 为这个URL找到对应的处理函数；

  4. 执行函数并生成响应，返回给浏览器；

  5. 浏览器接收并解析响应，将信息显示在页面中。

- **路由**

  作名词时表示管理URL和函数之间的映射；

  作动词时，表示按某种路线发送，即调用与请求URL对应的视图函数。

- 注册路由：

  在上面这些步骤中，大部分由Flask完成，开发者要做的只是简历处理请求的函数 (被称为`视图函数view function`)，并为其定义对应的URL规则。只需为函数附加`@app.route()`装饰器，并传入URL规则作为参数，就可以让URL与函数建立关联。这个过程被称为`注册路由（route）`。

- `@app.route()`

  route()装饰器的第一个参数是URL规则，用字符串表示，必须以斜杠`/`开始。这里的URL是相对URL(又称为内部URL)，即不包含域名的URL

- 为视图函数绑定多个URL

  一个视图函数可以绑定多个URL，用户访问每个URL都会触发对应的视图函数，获得响应

- 动态URL

  可以在URL规则中添加变量部分，使用`<变量名>`的形式表示。Flask处理请求时会把变量传入视图函数，所以我们可以添加参数获取这个变量值。

  因为URL中可以包含变量，所以我们传入`@app.route()`的字符串称为URL规则，而不是URL。Flask会解析请求的URL与视图函数的URL规则进行匹配。

  当URL规则中包含变量，但用户访问的URL中没有添加变量时，会匹配失败。常见的行为是在`@app.routes()`这个装饰器里使用`defaults`参数设置URL变量的默认值，这个参数接收字典作为输入，存储URL变量和默认值的映射。

  ```python
  @app.route('/greet', defaults={'name': 'Programer'})
  @app.route('/greet/<name>')
  def greet(name):
    return '<h1>hello {}!</h1>'.format(name)
  ```



# 启动开发服务器

Flask内置了一个简单的开发服务器（由依赖包Werkzeug提供），足够在开发和测试阶段使用。

- Flask CLI

  当安装了Flask后，会自动添加一个flask命令脚本，我们可以通过flask命令执行内置命令、扩展提供的命令或我们自己定义的命令。其中，`flask run`命令用来启动内置的开发服务器。

- 自动发现程序实例

  在执行`flask run`命令运行程序前，需要提供程序实例所在模块的位置，Flask会自动探测程序实例，规则如下：

  - 从当前目录寻找`app.py` 和`wsgi.py`模块，并从中寻找名为`app`或`application`的应用实例
  - 从环境变量`FLASK_APP`对应的值寻找名为`app`或`application`的应用实例

- 管理环境变量

  Flask的自动发现程序机制还有第三条规则：如果安装了·python-dotenv·，那么在使用·flask run·或其他命令时会使用它自动从`.flaskenv` 和`.env`文件中加载环境变量。

  当安装了`flask-dotenv`时，Flask加载环境变量的优先级是：手动设置的环境变量 > `.env`中设置的环境变量 > `.flaskenv`设置的环境变量。

  - `.flaskenv`：用于存储和Flask相关的公开环境变量，如FLASK_APP
  - `.env`：用来存储包含敏感信息的环境变量，该文件不应该提交到git仓库中

- 更多启动选项

  - 使服务外部可见：

    使用`flask run`启动的web服务器默认是对外不可兼得，可以添加`--host`选项讲主机地址设为`0.0.0.0`使其对外可见。

    ```shell
    flask run --host=0.0.0.0
    ```

    这会让服务器监听所有外部请求。

    > 个人计算机一般没有公网IP，所以你的程序只能被局域网内的其他用户通过你个人计算机的内网IP访问。

  - 改变默认端口

    Flask提供的web服务器默认监听5000端口，你可以在启动时传入参数`--port`改变它

    ```shell
    flask run --port=8000
    ```

- 设置运行环境

  - 开发环境(`development environment`)：开发者在本地编写和测试程序时的计算机环境
  - 生产环境(`production environment`)：网站部署上线供用户访问时的服务器环境

  Flask提供一个`FLASK_ENV`环境变量用来设置环境，默认为`production`。

  在开发环境下，调试模式(`Debug Mode`)将被开启，这时执行flask run启动程序会自动激活Werkzeug内置的调试器(`debugger`)和重载器(`reloader`)。

  - 调试器(`debugger`)

    Werkzeug提供的调试器非常强大，当程序出错时，可以在网页上看到详细的错误追踪信息，还允许开发者在错误页面上执行python代码。

    > 单机错误信息右侧的命令行图标，会弹出窗口要求输入PIN码，也就是启动服务器时命令行窗口打印出的调试器PIN码(`Debugger PIN`)。
    >
    > 输入PIN码后，单机错误堆栈某个节点右侧的命令行界面图标，会打开一个包含执行上下文信息的python shell，开始调试。

  - 重载器(`reloader`)

    重载器的作用就是监测文件变动，然后重新启动开发服务器。

    > 如果项目中使用了单独的css或js文件，那么浏览器可能会缓存这些文件，从而导致对文件作出的修改不会立即生效。（需要手动在浏览器中清空缓存）



# Flask 扩展

**扩展(`extension`)**即使用Flask提供的API接口编写的Python库，可以为Flask程序添加各种各样的功能。大部分扩展用来集成其他库，作为Flask和其他库之间的薄薄的一层胶水。

因为Flask扩展的编写有一些约定，所以初始化的过程大致相似。**大部分Flask扩展都会提供一个扩展类，实例化这个类，并传入我们创建的应用实例app作为参数，即可完成初始化过程。**通常，扩展会在传入的程序实例上注册一些处理函数，并加载一些配置。

例：某扩展实现了Foo功能，这个扩展的名称将是Flask-Foo或 Foo-Flask，程序包或模块的命名使用小写加下划线，即flask_foo(即导入时的名称)；用于初始化的类一般为Foo，实例化的类实例一般使用小写，即foo。

初始化这个假想中的Flask-Foo扩展的示例如下所示:

```python
from flask import Flask
from flask_foo import Foo

app = Flask(__name__)
foo = Foo(app)
```



# 项目配置

很多情况下，我们需要设置程序的某些行为，这是就需要使用配置变量。在Flask中，配置变量就是一些大写形式的Python变量，也可称为配置参数或配置键。使用统一的配置变量可以避免在程序中以硬编码(`hard coded`)的形式设置程序。

在一个项目中，可能会用到许多配置：Flask提供的配置、扩展提供的配置，还有程序特定的配置。这些配置变量都通过Flask对象的app.config属性作为统一的接口来设置和获取，它指向的Config类实际上是字典的子类，所以你可以像操作其他字典一样操作它。

- 加载配置

  Flask提供了很多种方式来加载配置：

  - 添加键值对设置一个配置

    ```python
    app.config['ADMIN_NAME'] = 'Peter'
    ```

  - 使用`update()`方法一次加载多个值

    ```python
    app.config.update(
    	TESTING=True;
      SECRET_KEY='_5#yF4Q8z\n\xec]/'
    )
    ```

  - 将配置变量存储在单独的Ptyhon脚本、JSON文件或是Python类中

- 读取配置

  - 从config字典里通过将配置变量的名称作为键读取对应的值

    ```python
    value = app.config['ADMIN_NAME']
    ```

  - 从Ptyhon脚本、JSON文件或是Python类中读取配置变量

某些扩展需要读取配置值来完成初始化操作，比如`Flask-SQLAlchemy`，因此我们应该尽量将加载配置的操作提前，最好**在应用实例app创建后加载配置**。

# URL和端点





# Flask CLI

除了Flask内置的`flask run`、`flask shell`等命令，我们也可以自定义命令。

- 以应用实例注册命令

  通过创建任意一个函数，并为其添加`@app.cli.command()`装饰器，我们就可以注册一个flask命令。

  示例：添加命令`create-user`并接收参数`name`

  ```python
  import click
  from flask import Flask
  
  app = Flask(__name__)
  
  @app.cli.command('create-user')
  @click.argument('name')
  def create_user(name):
    print('You have created the user {}'.format(name))
  ```

  ```shell
  flask create-user admin
  ```

  示例：已命令组的方式添加命令

  ```python
  import click
  from flask import Flask
  from flask.cli import AppGroup
  
  app = Flask(__name__)
  user_cli = AppGroup('user')
  
  
  @user_cli.command('create')
  @click.argument('name')
  def create_user(name):
    print('You have created the user {}'.format(name))
    
  app.cli.add_command(user_cli)
  ```

  ```shell
  flask user create admin
  ```

- 以蓝图注册命令

  如果你的应用使用蓝图，那么可以把CLI命令直接注册到蓝图上。当蓝图注册到应用上时，相关的命令就可以应用于flask命令了。

  > 默认情况下，定义的命令会嵌套于一个与蓝图相关匹配的组

  ```python
  import click
  from flask import Flask, Blueprint
  
  app = Flask(__name__)
  bp_student = Blueprint('student', __name__)
  
  @bp_student.cli.command('create')
  @click.argument('name')
  def create_user(name):
    print('The user {} has been created.'.formart(name))
    
  app.register_blueprint(bp_student)
  ```

  ```shell
  flask student create admin
  ```

  命令组名称可以在创建Blueprint对象时通过`cli_group`参数定义，也可以在创建之后使用`app.register_blueprint(bp,cli_group='xxx'`来变更

  ```python
  # 创建bp_student时，定义命令组
  bp_student = Blueprint('student', __name__, cli_group='other')
  # 注册bp_student事，定义命令组
  app.register_blueprint(bp_student, cli_group='other')
  ```

  ```shell
  flask other create admin
  ```

  