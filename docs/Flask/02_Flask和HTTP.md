# 请求响应循环

- 请求-响应循环：

  每一个Web应用都包含一种处理模式，即**请求-响应循环(`Request-Reponse Cycle`)**，客户端发出请求，服务端处理请求并返回响应。

  客户端(`client side`)：是指用来提供给用户的和服务器通信的各种软件，如浏览器。

  服务端(`server side`)：则指为用户提供服务的服务器，也就是web应用程序运行的地方。

- Flask Web程序工作流程：

  <img src="https://i.loli.net/2021/08/31/GJYu3rwZedysAj1.png" alt="image.png" style="zoom:33%;" />

  1. 用户访问一个URL，浏览器便生成对应的http请求，经有互联网发送到对应的web服务器；
  2. Web服务器接收请求，通过WSGI将HTTP格式的请求数据转换为Flask程序能够使用的Python数据；
  3. 在程序中，Flask程序根据请求的URL执行对应的视图函数，获取返回值生成响应；
  4. 响应依次经过WSGI转换生成HTTP响应，再经由Web服务器传递，最终被发出请求的客户端接收；
  5. 浏览器渲染响应中包含的HTML和CSS代码，并执行JS代码，最终把解析后的页面呈现在用户浏览器的窗口中。



# HTTP请求与Request对象

request对象封装了从客户端发来的请求报文，我们能从它获取请求报文中的所有数据。

- request对象常用的属性和方法

  | 属性/方法  | 说明                                                         |
  | ---------- | :----------------------------------------------------------- |
  | args       | Werkzeug的ImmutableMultiDict对象。存储解析后的查询字符串，可通过字段方式获取键值。（通过`query_string()`法可以获取为截止的原生查询字符串） |
  | blueprint  | 当前蓝图的名称                                               |
  | cookies    | 一个包含随请求提交的cookies字典                              |
  | data       | 包含字符串形式的请求数据                                     |
  | endpoint   | 与当前请求匹配的端点值                                       |
  | files      | Werkzeug的MutliDict对象，包含所有上传文件，可使用字典形式获取文件。使用的键为文件input标签中的name属性值，对应的值为Werkzeug的FileStorage对象，可调用save()方法并传入保存路径来保存文件 |
  | form       | Werkzeug的ImmutableMutliDict对象。和files类型，包含解析后的表单数据。表单数据通过input标签的name属性值作为键获取 |
  | values     | Werkzeug的CombineMutliDict对象，结合了args和form属性的值     |
  | get_data() | 获取请求中的数据，默认读取为字节字符串(bytestring)；将as_text参数设为True(默认为False)则返回值讲师解码后的unicode字符串 |
  | get_json() | 作为josn解析并返回数据，如果MIME类型不是json，返回None；解析出错则抛出Werkzeug提供的BadRequest异常 |
  | headers    | 一个Werkzeug的EnvironHeaders对象，包含首部字段，可以以字典的形式操作 |
  | is_json    | 通过MIME类型判断是否为json对象，返回布尔值                   |
  | json       | 包含解析后的json数据，内部调用get_json()，可通过字典的方式获取值 |
  | method     | 请求的HTTP方法                                               |
  | referrer   | 请求发起源的URL，即referer                                   |
  | scheme     | 请求的URL模式（http或https）                                 |
  | user_agent | UserAgent(UA)，包含了用户的客户端类型，操作系统类型等信息    |

  > Werkzeug的MutliDict类是字典的子类，它主要实现了同一个键对应多个值得情况。比如一个文件上传字段可能会接收多个文件，这是就可通过`getlist()`方法来获取文件对象列表。
  >
  > 而ImmutableMutliDict类继承了MutliDict类，但其值不可更改。
  >
  > 需要注意的是，和普通的字典类型不同，当我们从request对象的类型为MultiDict或ImmutableMutliDict的属性(如files、form、args)中直接使用键作为索引获取数据时，如果没有对应的键，那么会返回`HTTP 400`的错误响应，而不是`KeyError`异常。为了避免这个错误，应该使用`get()`方法获取数据，如果没有对应的值则返回`None`；`get()`方法的第二个参数还可以设置默认值，比如`request.get('name', ‘human’)`。

- 在Flask中处理请求

  URL是指向网络上资源的地址。在Flask中，我们需要让请求的URL匹配对应的视图函数，视图函数返回值就是URL对应的资源

  - **路由匹配**

    为了方便将请求分发到对应的视图函数，应用实例中存储了一个路由表(`app.url_map`)，其中定义了URL规则和视图函数的映射关系。

    当请求发来后，Flask会根据请求报文中的URL(path部分)来尝试与这个表中所有的URL规则进行匹配，调用匹配成功的视图函数。

    如果没有找到匹配的URL规则，说明程序中没有处理这个URL的视图函数，Flask会自动返回404错误响应。

    使用`flask routes`命令可以查看程序中定义的所有路由，这个路由列表有`app.url_map`解析得到。

  - **设置监听HTTP方法**

    视图函数默认监听的方法类型就是GET，但我们可以再`app.route()`装饰器中使用`methods`参数传入一个包含监听的HTTP方法的可迭代对象。

    ```python
    @app.route('/hello', methods=['GET', 'POST'])
    def hello():
      pass
    ```

    当某个请求的方法不符合要求时，请求将无法被正常处理，Flask会返回一个405错误响应(`Method Not Allowed`)。

  - **URL处理**

    URL中的变量部分默认类型为字符串，但Flask提供了一些转换器可以在URL规则里使用，见表：

    - 转换器列表

      | 转换器 | 说明                                                         |
      | ------ | ------------------------------------------------------------ |
      | string | 不包含斜线的字符串（默认值）                                 |
      | int    | 整型                                                         |
      | float  | 浮点型                                                       |
      | path   | 包含斜线的字符串(static路由的URL规则中的filename变量就使用了该转化器) |
      | any    | 匹配一系列给定值中的一个元素                                 |
      | uuid   | UUID字符串                                                   |

    - 转换器使用规则：

      转换器通过特定的规则指定，即**`<转换器:变量名>`**。

      如：`<int:year>`会把year的值转换为整型，因此可以再视图函数中直接对year进行数学运算

      ```python
      @app.route('goback/<int:year>')
      def go_back(year):
        return '<p>Welcome to %d</p>' %(2021 - year)
      ```

      在使用了转换器后，如果URL中传入的变量无法成功进行转换，那么会直接返回404错误响应。

    - any转换器

      用法：在转换器后添加括号来给出可选值，如`<any(value1, value3, ...):变量名>`

      ```python
      @app.route('/colors/<any(blue, white, red):color>')
      def three_colors(color):
        return '<p>Love is {}.</p>'.format(name)
      ```

      也可以在any转换器中传入一个预先定义的列表，通过格式化字符串的方式来构建URL规则字符串

      ```python
      colors = ['blue', 'white', 'red']
      @app.route('/colors/<any({}):color>'.format(str(colors)[1:-1]))
      def three_colors(colors):
        ...
      ```

- 请求钩子

  有时我们需要对请求进行预处理(`preprocessing`)和后处理(`postprocessing`)，这时可以试用Flask提供的一些请求钩子(`Hook`)，它们可以用来注册在请求处理的不同阶段执行的处理函数(或回调函数`Callback`)。

  这些请求钩子使用装饰器实现，通过应用实例app调用。

  - Flask默认实现的五种请求钩子

    | 钩子                 | 说明                                                         |
    | -------------------- | ------------------------------------------------------------ |
    | before_first_request | 注册一个函数，在处理第一个请求前执行                         |
    | before_request       | 注册一个函数，在处理每个请求前执行                           |
    | after_request        | 注册一个函数，如果没有未处理的异常抛出，会在每个请求结束后运行 |
    | teardown_request     | 注册一个函数，即使有未处理的异常抛出，也会在每个请求结束后运行（如果发生异常，会传入异常对象作为参数到注册的函数中） |
    | after_this_request   | 在视图函数内注册一个函数，会在这个请求结束后运行             |

    每个钩子可以注册任意多个处理函数，函数名不是必须与钩子名称相同，例：

    ```python
    @app.before_request
    def do_something():
      pass # 这里的代码会在每个请求处理前执行
    ```

  - 请求处理函数调用流程

    例：创建三个视图函数A、B、 C，其实视图函数C使用了after_this_request钩子，那么当请求A进入后，整个请求处理周期的请求处理函数调用流程如图：

    <img src="https://i.loli.net/2021/09/01/1ZUMKqaFAw9ohsO.png" alt="image.png" style="zoom: 75%;" />

    > after_request钩子和after_this_request钩子必须接收一个响应类对象作为参数，并且返回同一个或更新后的响应对象。



# HTTP响应与Response对象

- 在Flask中生成响应

  响应在Flask中使用Response对象表示，响应报文中的大部分内容由服务器处理，大多数情况下，我们只负责返回主体内容。视图函数的返回值构成了响应报文的主体内容，正确返回时状态码默认是200。Flask会调用`make_response()`方法将视图函数返回值转换为响应对象。

  完整的说，视图函数可以返回最多由三个元素组成的元组：**响应主体、状态码、首部字段**。其中首部字段可以为字典，或是两元素元组组成的列表。

  ```python
  @app.route('/hello')
  def hello():
    ...
    return '<h1>Hello Flask</h1>', 201, {'Location': 'http://www.example.com'}
  ```

  - 重定向

    对于重定向这一类特殊响应，Flask提供了一些辅助函数。

    除了手动生成302响应，还可以使用Flask提供的`redirect()`函数来生成重定向响应，参数`location`为重定向的目标URL，参数`code`为重定向状态码，默认为302(临时重定向)。

    如果需要再程序内重定向到其他视图，只需要在`redirect()`函数中使用`url_for()`函数生成目标URL即可。

    ```python
    @app.route('/hi')
    def hi():
      ...
      return redirect(url_for('hello'), code=301)
    ```

  - 错误响应

    大部分情况下，Flask会自动处理常见的错误响应。HTTP错误对应的异常类在Werkzeug的werkzeug.exceptions模块中定义，抛出这些异常即可返回对应的错误响应。如果想手动返回错误响应，放方便的办法是使用Flask提供的`abort()`函数，传入状态码即可返回对应的错误响应。

    ```python
    from flask improt Flask, abort
    ...
    @app.route('/error')
    def not_found():
      abort(404)
    ```

    注：一旦abort()函数被低啊用，abort()函数之后的代码将不会被执行。

- 响应格式

  在HTTP响应中，数据可以通过多种格式传输，不同的相应数据格式需要设置不同的`MIME`类型，`MIME`类型在首部的`Content-Type`字段中定义。

  - MIME类型

    **MIME类型(又称为media type或content type)是一种用来标识文件类型的机制**，它与文件扩展名相对应，可以让客户端区分不同的内容类型，并执行不同的操作。一般格式为`类型名/子类型名`，其中子类型名一般为文件扩展名，如png图片的MIME类型为`image/png`。

    如果想使用其他MIME类型(默认为HTML)，可以通过Flask提供的`make_reponse()`函数生成响应对象，传入响应主体作为参数，然后使用此对象的`mimetype`属性设置MIME类型，如：

    ```python
    from flask import make_response
    
    @app.route('/foo')
    def foo():
      response = make_response('hello flask')
      response.mimetype = 'text/plain'
      return response
    ```

    也可以直接设置首部字段，如：

    ```python
    ...
    	response.headers['Content-Type'] = 'text/html; charset=utf-8'
    ...
    ```

  - 常见的数据格式

    - 纯文本（MIME类型：`text/plain`）

    - HTML（MIMIL类型：`text/html`）

    - XML （MIMIL类型：`application/xml`）

      XML是指Extensible Markup Language（可扩展标记语言）。它是一种简单灵活的文本格式，被设计用来存储和交换数据。

      > XML的出现主要是为了弥补HTML的不足：对于仅仅需要数据的请求来说，THML提供的信息太过丰富了，而且不易于重用。XML和HTML一样都是标记性语言，使用标签来定义文本，但HTML中的标签用户显示内容，而XML中的标签只用于定义数据。XML一般作为AJAX请求的相应格式，或是Web API的响应格式。

    - JSON （MIMIL类型：`application/json`）

      JSON是指JavaScript Object Notation（JavaScript对象表示法），是一种流行的、轻量的数据交互格式。

      > JSON的出现又弥补了XML的诸多不足：XML有较高的重用性，但XML相对于其他文档格式来说体积稍大，处理和解析的速度较慢。JSON轻量、简洁、容易阅读和简洁，而且能和Web默认的客户端语言JavaScript更好兼容。
      >
      > JSON的结构基于**键值对的集合**和**有序的值列表**，这两种数据结构类似python中的字典和列表。正是因为这种通用的数据结构，使得JSON在同样基于这些结构的编程语言之间交换称为可能。

      Flask通过引入Python标准库中的json模块为程序提供了JSON支持。json.dumps()方法将字典、列表或元组序列化为JSON字符串，然后再修改MIME类型，即可返回JSON响应，如：

      ```python
      from flask import Flask, json, make_response
      ...
      @app.route('/')
      def foo():
        data = {
          'name': 'Tom',
          'gender': 'male'
        }
        response = make_response(json.dumps(data))
        response.mimetype = 'application/json'
        return response
      ```

      不过一般不直接使用，Flask通过包装json模块的dumps()、loads()等方法提供了更方便的`jsonify()`函数，仅需传入数据或参数，它就会对我们传入的内容进行序列化，转化为JSON字符串作为响应的主体，然后生成一个响应对象，并且设置正确的MIME类型，如：

      ```python
      from flask import jsonify
      ...
      @app.route('/foo')
      def foo():
        return jsonify(name='Grey Li', gender='male')
      ```

      jsonify()函数默认生成200响应，可通过附加状态码来自定义相应类型，如：

      ```python
      ...
      	reutrn jsonify(message='error'), 500
      ```

- Cookie

  HTTP是无状态(stateless)协议。即在一次请求响应结束后，服务器不会留下任何关于对方状态的信息。但是对于某些Web程序来说，客户端的某些信息又必须被记住，如用户的登录状态，这样才能根据用户的状态来返回不同的响应。为了解决这类问题，就有了Cookie技术。**Cookie技术通过再请求和响应报文中添加Cookie数据来保存客户端的状态信息。**

  **Cookie指Web服务器为了存储某些数据而保存在浏览器上的小型文本数据。**浏览器会在一定时间内保存它，并在下一次向同一个服务器发送请求时附带这些数据。Cookie通常被用来进行用户会话管理，保存用户的个性化信息以及记录和手机用户浏览数据以用来分析用户行为等。

  在Flask中，如果想在响应中添加一个cookie，最方便的方式是使用Response类提供的set_cookie()方法。

  - Response类常用的属性和方法

    | 方法/属性    | 说明                                                        |
    | ------------ | ----------------------------------------------------------- |
    | headers      | 一个Werkzeug的Headers对象，表示响应首部，可以像字典一样操作 |
    | status       | 状态码，文本类型                                            |
    | status_code  | 状态码，整型                                                |
    | mimetype     | MIME类型（仅包含内容类型部分）                              |
    | set_cookie() | 用来设置一个cookid                                          |

  - set_cookie()函数

    常用参数列表：

    | 参数     | 说明                                                         |
    | -------- | ------------------------------------------------------------ |
    | key      | cookie的键                                                   |
    | value    | cookie的值                                                   |
    | max_age  | cookie被保存的时间数，单位为秒；默认在用户回话结束(即关闭浏览器)时过期 |
    | expires  | 具体的过期时间，一个datetime对象或UNIX时间戳                 |
    | path     | 限制cookie只能在给定的路径可用，默认为整个域名               |
    | domain   | 设置cookie可用的域名                                         |
    | secure   | 设置为True，则只有https才可以使用                            |
    | httponly | 设置为True，则禁止客户端JavaScript获取cookie                 |

    ```python
    from flask import Flask, request, make_response, redirect, url_for
    
    @app.route('/set/<name>')
    def set_name(name):
      response = make_response(redirect(url_for('hello')))
      response.set_cookie('name', name)
      return response
    
    @app.route('/hello')
    def hello():
      name = request.args.get('name')
      if name is None:
      	name = request.cookies.get('name', 'Human')
      return '<h1>hello {}!</h1>'.format(name)
    ```

    请求流程大致为：

    1. 浏览器发送请求`GET /set/Grey `;
    2. 服务端收到请求后，交由`set_name()`视图函数进行处理：该视图函数生成重定向到`/hello`响应对象，并在生成的响应报文首部中创建一个`Set-Cookie`字段，即`Set-Cookie: name=Grey; path=/`；
    3. 收到响应对象后，浏览器保存了服务端设置的Cookie，再次请求`GET /hello`，并将cookie的内容储存于请求首部的Cookie字段中；
    4. 服务端收到请求后，交由`hello()`视图函数进行处理：该视图函数从请求参数或cookie获取name，并返回给客户端；
    5. 客户端渲染收到的响应内容。

- session：安全的Cookie

  Cookie在Web程序中发挥了很大的作用，其中最重要的功能是存储用户的认证信息。但是在浏览器中手动修改Cookie是很容易的事，如果直接把认证信息以明文的方式存储在Cookie中，那么恶意用户就可以通过伪造cookie的内容来获得对网站的权限，冒充他人的账户。为了避免这个问题，就需要对敏感的Cookie内容进行加密。而Flask则提供了session对象来对Cookie数据加密存储。

  在编程中，session指用户会话(user session)，又称为对话(dialogue)，即服务器和客户端/浏览器之间或桌面程序和用户之间建立的交互活动。**在Flask中，session对象用来加密Cookie。默认情况下，它会把数据存储在浏览器上一个名为session的cookie里。**

  - 设置程序秘钥

    session通过秘钥对数据进行签名以加密数据，因此需要先设置一个秘钥。这里的秘钥是一个具有一定复杂度和随机性的字符串。

    可通过Flask.secret_key属性、配置变量SECRET_KEY、设置系统环境变量或保存在.env文件中的方式来设置秘钥。

    ```python
    # Flask.secret_key属性
    app.secret_key = 'xxxx'
    # 配置变量SECRET_KEY
    app.config['SECRET_KEY'] = 'xxxx'
    ```

    ```python
    # 设置环境变量
    export SECRET_KEY=xxxx
    ```

    ```python
    # 通过os模块提供的getenv()方法读取系统环境变量
    import os
    app.secret_key = os.getenv('SECRET_KEY')
    ```

  - 模拟用户认证

    ```python
    from flask import Flask, redirect, url_for, session, request
    
    @app.route('/login')
    def login():
      session['Logged_in'] = True
      return redirect(url_for('hello'))
    
    @app.route('/hello')
    def hello():
      name = request.args.get('name')
      response = ''
      if name is None:
        name = request.cookie.get('name', 'Human')
        response = '<h1>Hello, {}!</h1>'.format(name)
        if 'Logged_in' in session:
          response += '[Authenticated]'
        else:
          response += '[Not Authenticated]'
      return response
        
    ```

    请求流程大致为：

    1. 浏览器发送请求`GET /login `;
    
    2. 服务端收到请求后，交由`login()`视图函数进行处理：该视图函数生成重定向到`/hello`响应对象，并在生成的响应报文首部中创建一个`Set-Cookie`字段，即`Set-Cookie: session=xxx; Path=/`；
    
    3. 收到响应对象后，浏览器保存了服务端设置的Cookie，再次请求`GET /hello`，并将cookie的内容储存于请求首部的Cookie字段中；

    4. 服务端收到请求后，交由`hello()`视图函数进行处理：该视图函数从请求参数或cookie获取name，判断Logged_in是否在session中，组合为响应主体并返回给客户端；

    5. 客户端渲染收到的响应内容。
    
  
  尽管session对象会对Cookie进行签名并加密，但这种方式仅能够确保session的内容不会被篡改，加密后的数据借助工具仍可以轻易读取（即使不知道秘钥， 如`session.items()`就可以获得session中的键值对集合）。因此，决不可在session中存储敏感信息。
  
    

# Flask上下文

可以把编程中的上下文理解为当前环境(`environment`)的快照(`snapshot`)。

Flask有两种上下文，程序上下文(`application context`)和请求上下文(`request context`)。

程序上下文中存储了程序运行所必须的信息；当客户端发来请求时，就出现了请求上下文，请求上下文中包含了请求的各种信息，比如请求的URL 请求方法等。

- 上下文全局变量

  在视图函数中，我们直接从Flask导入一个全局的request对象，然后在视图里直接调用request的属性获取数据。那么问题来了，我们在全局导入时request只是一个普通的python对象，为什么在处理请求时，视图函数里的request就会自动包含对应请求的数据？这是因为**Flask会在每个请求产生后自动激活当前请求的上下文，激活请求上下文后，request被临时设为全局可访问。而当每个请求结束后，Flask就销毁对应的请求上下文。**

  在多线程服务器中，在同一个时间可能会有多个请求在处理，每个请求都有各自不同的请求报文，所以请求对象也必然是不同的。因此，请求对象只在各自的线程内是全局的。Flask通过本地线程(thread local)技术将请求对象在特定的线程和请求中全局可访问。

  - Flask中的上下文变量：

    | 变量名      | 上下文类型 | 说明                                                         |
    | ----------- | ---------- | ------------------------------------------------------------ |
    | current_app | 程序上下文 | 指向处理请求的当前程序实例                                   |
    | g           | 程序上下文 | 替代python的全局变量用法，确保仅在当前请求中可用。用于存储全局数据，每次请求都会重设 |
    | request     | 请求上下文 | 封装客户端发出的请求报文数据                                 |
    | session     | 请求上下文 | 用户记住请求之间的数据，通过签名的Cookie实现                 |

  - current_app：

    既然已经有了程序实例app对象，为什么还需要current_app变量呢？

    在不同的视图函数中，request对象都表示与视图函数对应的请求，也就是当前请求(current request)。而程序也会有多个程序实例的情况，为了能获取对应的程序实例，而不是固定的某一个程序实例，我们就需要使用current_app变量。

  - g

    **g存储在程序上下文中，而程序上下文会随着每一个请求的进入而激活，随着每一个请求的处理完毕而销毁，所以每次请求都会重设这个值。**我们通常会使用它结合请求钩子来保存每个请求处理前所需要的全局变量，如当前登入的用户对象、数据库连接等。

    ```python
    from flask import g
    
    @app.before_request
    def get_name():
      g.name = request.args.get('name')
    ```

    设置此函数后，在其他视图中可以直接使用g.name获取对应的值.

    

- 激活上下文

  - Flask自动激活程序上下文场景：

    - 使用flask run命令启动程序；
    - 使用app.run()方法启动程序；
    - 执行使用@app.cli.command()装饰器注册的flask命令时；
    - 使用flask shell命令启动python shell时

  - 请求进入

    当请求进入时，Flask会自动激活请求上下文，这是我们可以使用request和session全局变量。另外，当请求上下文被激活时，程序上下文也被自动激活。当请求处理完毕后，请求上下文和程序上下文也会自动销毁。也就是说，在请求处理时，这两者拥有相同的生命周期。

  我们可以在视图函数中或在视图函数内调用的函数/方法中使用所有上下文全局变量。在使用flask shell命令打开的python shell中，或是自定义的flask命令函数中，我们可以使用current_app和g变量，也可以手动激活上下文来使用request和session。

  同样依赖于上下文的还有url_for()、jsonify()等函数，所以只能在视图函数中使用它们。其中jsonify()函数内部调用中使用了current_app变量，而url_for()则需要依赖请求上下文才可以正常运行。

  > 如果我们在没有激活相关上下文时就使用这些变量，Flask就会抛出RuntimeError异常：`RuntimeError: Working outside of application context.` 或是 `RuntimeError: Working outside of request contexte.`。

  - 手动激活上下文

    如果需要在没有激活上下文的情况下使用全局上下文变量，可以手动激活上下文。

    如：以下是在普通的python shell中，程序上下文对象使用app.app_context()获取，可以使用with语句执行上下文操作：

    ```shell
    $ python 
    >>> from demo_app import app
    >>> from flask import current_app
    >>> with app.app_context():
    ...     current_app.name
    ... 
    'demo_app'
    ```

    也可以显示的使用push()方法推送（激活）上下文，在执行完相关操作时使用pop()方法销毁上下文。

    ```shell
    $ python
    >>> from demo_app import app
    >>> from flask import current_app
    >>> app_ctx = app.app_context()
    >>> app_ctx.push()
    >>> current_app.name
    'demo_app'
    >>> app_ctx.pop()
    ```

    请求上下文可以通过test_request_context()方法临时创建：

    ```shell
    $ python
    >>> from demo_app import app
    >>> from flask import request
    >>> with app.test_request_context('/hello'):
    ...     request.method
    ... 
    'GET'
    ```

    

- 上下文钩子

  Flask为上下文提供一个`teardown_appcontext`钩子，使用它注册的回调函数会在程序上下文被销毁时调用，而且通常也会在请求上下文被销毁时调用。使用`@app.teardown_appcontext`装饰器注册的回调函数需要接收异常对象作为参数，当请求被正常处理时这个参数值将会是None，这个函数的返回值将被忽略。

  如：在每个请求处理结束后销毁数据库连接：

  ```python
  @app.teardown_appcontext
  def teardown_db(exception):
    ...
    db.close()
  ```

  

# HTTP进阶

- 重定向回上一个页面

  - 获取上一个页面的URL

    要重定向回上一个页面，最关键的是获取上一个页面的URL，一般有两种方式获取：

    1. HTTP referer

       HTTP referer(起源于referrer在HTTP规范中的错误拼写)是一个用来**记录请求发源地址的HTTP首部字段，即访问来源**。当用户在某个站点单击链接，浏览器向新链接所在的服务器发起请求，请求的数据中包含的HTTP_REFERER字段记录了用户所在的原站点URL。

       在Flask中，referer的值可以通过请求对象的referrer属性获取，即`request.referrer`。

    2. 查询参数

       在URL中手动加入包含当前页面URL的查询参数，这个查询参数一般命名为next，然后用request.args.get('next')获取这个值，然后重定向到对应的路径

       ```python
       return redirect(request.args.get('next'))
       ```

  - 对URL进行安全验证

    鉴于referer和next容易被篡改的特性，如果不对这些值进行验证，则会形成开放重定向问题(open rdirect)，确保URL安全的关键就是判断URL是否属于程序内部。

- 使用AJAX技术发送异步请求

  在传统的web应用中，程序的操作都是基于请求响应循环来实现的。每当页面状态需要变动，或是需要更新数据时，都伴随着一个发向服务器的请求。当服务器返回响应时，整个页面会重载，并渲染新页面。但是这种模式会有一些问题：首先频繁更新页面会牺牲性能，浪费服务器资源，同时降低用户体验。另外，对于一些操作性很强的程序来说，重载页面会显得不合理。

  - 认识AJAX

    **AJAX指异步Javascript和XML(Asynchronous JavaScript And XML)，它不是编程语言或通信协议，而是一系列技术的组合体。简单来说，AJAX基于`XMLHttpRequest`让我们可以在不重载页面的情况下和服务器进行数据交换。加上JavaScript和DOM，我们就可以在接收到响应数据后局部更新页面。而XML指的则是数据交换的格式，也可以是纯文本(Plain Text)、HTML或JSON。**

    在Web程序中，很多加载数据的操作都可以在客户端用AJAX实现，我们可以在客户端实现大部分页面逻辑，而服务器端则主要负责处理数据。这样可以避免每次请求都渲染整个页面，这不仅增强了用户体验，也降低了服务器的负载。AJAX让Web程序也可以像桌面程序那样获得更流畅的反应和动态效果。

    以删除某个资源为例，在普通程序中的流程如下：

    1. 当删除按钮被单击时会发送一个请求，页面变空白，在接收到响应前无法进行其他操作；
    2. 服务端接收请求，执行删除操作，返回包含整个页面的响应；
    3. 客户端接收到响应，重载整个页面。

    使用AJAX技术时的流程如下：

    1. 当点击删除按钮时，客户端在后台发送一个异步请求，页面不变，在接收响应前可以进行其他操作；
    2. 服务端接收到请求后执行删除操作，返回提示信息或无内容的204响应；
    3. 客户端收到响应，使用JavaScript更新页面，移除资源对应的页面元素。

  - 使用jQuery发送AJAX请求

    jQuery是流行的JavaScript库，它包装了JavaScript，让我们通过更简单的方式编写JavaScript代码。对于AJAX，它提供了多个相关的方法，使用它可以很方便地实现AJAX操作。更重要的是，jQuery处理了不同的浏览器对AJAX兼容问题，只需要编写一套代码，就可以在所有主流的浏览器正常运行。

  - 返回`局部数据`

    对于处理AJAX请求的视图函数来说，我们不会返回完整的HTML响应，这是一般会返回局部数据，常见的三种类型如下：

    1. 纯文本或举报HTML模板：

       纯文本可以在js中用来直接替换页面中的文本值，而局部HTML则可以直接插入到页面中；

    2. JSON数据

       JSON数据可以再JavaScript中直接操作

       ```python
       @app.route('/profile/<int:user_id>')
       def get_profile(user_id):
         ...
         return jsonify(username=username, bio=bio)
       ```

       在jQuery中的`ajax()`方法的success回调中，响应主体中的json字符串会被解析为json对象，我们可以直接获取并进行操作。

    3. 空值

       有些时候，程序中的某些接收AJAX请求的视图并不需要返回数据给客户端，比如用来删除文章的视图。这是我们可以直接返回空值，并将状态码指定为204（表示无内容）

       ```python
       @app.route('/posts/<int:post_id>', methods=['DELETE'])
       def delete_post(post_id):
         ...
         return '', 204
       ```

    4. 异步加载长文章实例

       需求：显示一篇很长的虚拟文章，文章正文下方有一个”加载更多“按钮，当加载按钮被单击时，会发送一个AJAX请求获取文章的更多内容并直接动态地插入到文章的下方。

       视图函数show_post()用于显示虚拟文章：

       ```python
       from jinja2.utils import generate_lorem_ipsum
       
       ...
       @app.route('/post')
       def show_post():
           post_body = generate_lorem_ipsum(n=2)
           res_html = '''
           <h1>A very long post</h1>
           <div class="body">%s</div>
           <button id="load">Load more</button>
           <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
           <script type="text/javascript">
               $(function() {
                   $('#load').click(function() {
                       $.ajax({
                           url: '/more',
                           type: 'get',
                           success: function(data) {
                               $('.body').append(data);
                           }
                       })
                   })
               })
           </script>
           ''' % post_body
           return res_html
       ```

       文章的随机正文通过Jinja2提供的`generate_lorem_ipsum()`函数生成，n参数用来指定段落的数量，默认为5，它会返回由随机字符组成的 虚拟文章。

       > 在出版业和设计业，lorem ipsum指一段常用的无意义的填充文字

       在第二个script标签中，代码最外层创建了一个`$(function() {...})`函数，这个函数用来在页面DOM加载完毕后执行代码。

       `$`符号是jQuery的简写，通常用于调用jQuery提供的多个方法，所以`$.ajax()`等同于`jQuery.ajax()`。

       我们为加载按钮(即`'#load'`)注册了一个单击事件处理函数，当加载按钮被单击时就会执行单击事件的回调函数。在这个回调函数中，我们使用`$.ajax()`方法发送一个AJAX请求到服务器，通过url将目标URL设为"/more"，通过type参数将请求的类型设为GET，当请求成果处理并返回2xx响应时(另外还包括304响应)，会触发success回调函数。success回调函数接收的第一个参数为服务器返回的响应主体，在这个回调函数中，我们在文章正文（通过$('.body')选择）底部使用append()方法插入返回的data数据。

       处理”/more“的视图函数load_post()会返回随机文章正文：

       ```python
       @app.route('/more')
       def load_post():
           return generate_lorem_ipsum(n=1)
       ```

       

- HTTP服务端推送

  无论是传统的HTTP请求-响应式的通信模式，还是异步的AJAX式请求，服务端始终处于被动的应答状态，只有在客户端发出请求的情况下，服务端才会返回响应。这种通信模式被称为**客户端拉取（client pull)。**在这种模式下，用户只能通过刷新页面或主动单击加载按钮来拉取新数据。

  然而，在谋新长江下，我们需要的通信模式是**服务器端的主动推送（server push)**。如社交网站在导航栏实时显示新提醒和私信的数量，用户的用户状态更新等。

  实现服务器端推送的一系列技术被合称为**HTTP Server Push (服务器端推送)**，目前常用的推送技术如下：

  | 名称                    | 说明                                                         |
  | ----------------------- | ------------------------------------------------------------ |
  | 传统轮询                | 在特定的时间间隔内，客户端用AJAX技术不断向服务器发起HTTP请求，然后获取新的数据并更新页面 |
  | 长轮询                  | 与传统轮询类似，但是如果服务器端没有返回数据，那就保持连接一直开启，直到有数据时才返回。取回数据后再次发送另一个请求 |
  | Server-Sent Events(SSE) | SSE通过HTML5中的EventSource API实现。SSE会在客户端和服务器端简历一个单项通道，客户端监听来自服务端的数据，而服务端可以在任意时间发送数据，两者建立类似订阅/发布的通信模式 |

  

- Web安全防范

  - 注入攻击（Injection）

    注入攻击包括系统命令注入、SQL注入、NoSQL注入、ORM注入等。重点介绍SQL注入。
    - 攻击原理

      在编写SQL语句时，如果直接将用户传入的数据作为参数使用字符串拼接的方式插入到SQL查询中，那么攻击者可以通过注入其他语句来执行攻击操作，这些攻击操作包括可以通过SQL语句做的任何事情：获取敏感数据、修改数据、删除数据库表..

    - 防范方法

      1. 使用ORM可以在一定程度上避免SQL注入问题；

      2. 验证输入类型；

      3. 参数化查询。在构造SQL语句时避免使用拼接字符串或字符串格式化的方式来构建SQL语句，而要使用各类接口库提供的参数化查询方法，以sqlite3库为例：

         ```python
         # 参数化查询 (推荐)
         db.execute('select * from student where name=?;', name)
         # 字符串格式化（避免）
         db.execute('select * from student where name=%s;' % name)
         ```

      4. 转义特殊字符，比如引号、分好和横线等。使用参数化查询时，各类接口库会为我们做转义工作。

  - XSS攻击
  
    XSS(Cross-Site Scripting)，跨站脚本攻击
  
    - 攻击原理
  
      XSS是注入攻击的一种，攻击者通过将代码注入到被攻击者的网站中，用户一旦访问网页就会执行被注入的恶意脚本。XSS攻击主要分为反射形XSS攻击（Reflected XSS Attack）和存储型XSS攻击（Stored XSS Attack）。
  
      反射形XSS攻击：通过URL注入攻击脚本，只有当用户访问这个URL时才会执行脚本攻击；
  
      存储型XSS攻击：与反射形XSS攻击类似，不过会把攻击代码存储到数据库中，任何用户访问包含冬季代码的页面都会被殃及
  
    - 防范方法
  
      1. HTML转义：转义后确保用户输入的内容在浏览器中作为文本显示，而不是作为代码解析。
  
         我们可以使用Jinja2提供的escape()函数对用户传入的数据进行转义：
  
         ```python
         from jinja2 import escape
         
         @app.route('/hello')
         def hello():
           name = request.args.get('name')
           return '<h1>Hello, %s!<h1>' % escape(name)
         ```
  
      2. 验证用户输入：除了转义用户输入外，还需要对用户的输入数据进行类型验证
  
  - CSRF攻击
  
    CSRF(Cross Site Request Forgery)，跨站请求伪造攻击。随着大部分程序的完善，各种框架都内置了对CSRF保护的支持，但目前仍有5%的程序受到威胁。
  
    - 攻击原理
  
      攻击者利用用户在浏览器中保存的认证信息，向对应的站点发送伪造请求
  
    - 防范方法
  
      1. 正确使用HTTP方法
      2. CSRF令牌校验：通过再客户端页面中加入伪随机数来防御CSRF攻击，这个伪随机数通常被称为CSRF令牌(token)。




​    

​    

​    

​    

