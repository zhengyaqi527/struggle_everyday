#### 类型、类和ID选择器

- 类型选择器

  也叫做`标签选择器` 或者 `元素选择器` ，因为它在文章中选择了一个HTML标签/元素的缘故。

  ```css
  h1 {
    color: red;
  }
  ```

  

- 通配选择器

  也叫做全局选择器，是由一个星号（`*`）代指的，他选中了文档中的所有内容（或者是父元素中的所有的内容，比如，它紧随在其他元素以及邻代运算符之后的时候）

  全局选择器的一种用法是让选择器更易读，更明显地表现他们的作用。

  ```css
  article *:first-child {
      color: red;
  }
  ```

  

- 类选择器

  类选择器以一个 `.` 开头，会选择文档中应用这个类的所有物件

  ```css
  .highlight {
      background-color: yellow;
  }
  ```

  - 指向特定元素的类

    ```css
    span.highlight {
        background-color: yellow;
    }
    h1.highlight {
        background-color: pink;
    }
    ```

  - 多个类被应用到一个元素

    当想匹配带有所有这些类的元素时，可以将这些类不加空格地连成一串

    ```css
    .notebox {
        border: 4px solid #666;
        padding: .5em
    }
    .notebox.danger {
        border-color: orange;
        font-weight: bold;
    }
    ```

    ```html
    <div class="notebox danger">
        This note is show danger!
    </div>
    ```

  

- ID选择器

  ID选择器以 `#` 开头 ，基本用法与类选择器一致。

  ```css
  #one {
      background-color: yellow;
  }
  ```

  可以将元素放在类型选择器之前，只指向元素和ID都匹配地内容

  ```css
  h1#heading {
      color: rebeccapurple;
  }
  ```



#### 属性选择器

- 属性是否存在和属性值选择器

  这些选择器允许基于一个元素自身是否存在某个属性或者基于某个属性拥有不同属性值的匹配，来选择元素

  | 选择器          | 示例                  | 描述                                                         |
  | --------------- | --------------------- | ------------------------------------------------------------ |
  | `[attr]`        | `a[title]`            | 匹配带有一个名为`attr`属性的元素                             |
  | `[attr=value]`  | `a[href="xxx"]`       | 匹配带有一个名为`attr`属性且属性值精确为`xxx`的元素          |
  | `[attr~=value]` | `p[class~="special"]` | 匹配带有一个名为`attr`属性且属性值精确为`special`或者s属性值列表中包含`special`的元素（属性值列表用空格分割） |
  | `[attr|=value]` | `div[lang|="zh"]`     | 匹配带有一个名为`attr`属性且属性值精确为`zh`或者是以`zh`开头后跟一个`-`的元素 |

  ```css
  li[class] {
      font-size: 200%;
  }
  
  li[class="a"] {
      background-color: yellow;
  }
  
  li[class~="a"] {
      color: red;
  }
  li[class|="zh"] {
      color: green;
  }
  ```

  ```HTML
  <h1>Attribute presence and value selectors</h1>
  <ul>
      <li>Item 1</li>
      <li class="a">Item 2</li>
      <li class="a b">Item 3</li>
      <li class="ab">Item 4</li>
      <li class="zh-cn">Item 5</li>
      <li class="zh">Item 6</li>
  </ul>
  ```

  

- 属性值子字符串匹配选择器

  这些选择器可以匹配属性值的子字符串

  | 选择器          | 示例                | 描述                                                        |
  | --------------- | ------------------- | ----------------------------------------------------------- |
  | `[attr^=value]` | `li[class^="box-"]` | 匹配一个带有名为`attr`的属性，其属性值以`box-`开头          |
  | `[attr$=value]` | `li[class$="-box"]` | 匹配一个带有名为`attr`的属性，其属性值以`-box`结尾          |
  | `[attr*=value]` | `li[class*="box"]`  | 匹配一个带有名为`attr`的属性，其属性值中至少出现了一次`box` |

  ```css
  li[class^="a"] {
      font-size: 200%;
  }
  
  li[class$="a"] {
      background-color: yellow;
  }
  
  li[class*="a"] {
      color: red;
  }
  ```

  ```html
  <h1>Attribute substring matching selectors</h1>
  <ul>
      <li class="a">Item 1</li>
      <li class="ab">Item 2</li>
      <li class="bca">Item 3</li>
      <li class="bcabc">Item 4</li>
  </ul>
  ```

  

- 大小写敏感

  HTML默认是大小写敏感的。如果想再大小写不敏感的情况下匹配属性值，那就要在闭合括号之前，使用 `i`值。这个标记是告诉浏览器，要以大小写不敏感的方式匹配。

  ```css
  li[class^="a"] {
      background-color: yellow;
  }
  
  li[class^="a" i] {
      color: red;
  }
  ```

  ```html
  <h1>Case-insensitivity</h1>
  <ul>
      <li class="a">Item 1</li>
      <li class="A">Item 2</li>
      <li class="Ab">Item 3</li>
  </ul>
  ```



#### 伪类和伪元素

- 伪类选择器

  - 什么是伪类

    伪类是选择器的一种，它用于选择处于特定状态的元素，比如当它们是这一类型的第一个元素时，或者当鼠标指针悬浮再元素上面的时候。它们表现得会像是向文档的某个部分应用了一个类一样，帮你在你的标记文本中减少多余的类，让你的代码更灵活、易于维护

    **伪类就是以`:`开头的关键字**

    ```css
    :pseudo-class-name
    ```

  - 简单伪类示例

    - :first-child 表示一组兄弟元素中的第一个元素 
    - :last-child 表示一组兄弟元素中的最后一个元素
    - :only-child  表示没有任何兄弟元素的元素 
    - :invalid  表示任意内容未通过验证的`<input>`或其他`<form>`元素(对于突出显示用户的字段错误非常有用)

    ```css
    article p:first-child {
        font-size: 120%;
        font-weight: bold;
    }   
    ```

  - 用户行为伪类

    一些伪类只会再用户以某种方式和文档交互的时候应用。这些用户行为伪类，有时叫做动态伪类，表现得像是一个类在用户和元素交互的时候交到了元素上一样。如：

    - `:hover` 会在用户将指针挪到元素上的时候才会激活
    - `:focus` 在会在用户使用键盘控制，选定元素的时候激活

  

- 伪元素选择器

  - 什么是伪元素

    伪元素表现得像是你往标记文本中加入全新HTML元素一样，而不是向现有的元素应用类。

    **伪元素以`::`开头**

    ```css
    ::pseudo-element-name
    ```

  - 简单伪元素示例

    - `::first-line` 表示第一行

      ```css
      article p::first-line {
          font-size: 120%;
          font-weight: bold;
      }
      ```

      ```html
      <article>
          <p>
              Pseudo-elements behave in a similar way, however they act as if you had added a whole new HTML element into the markup, rather than applying a class to existing elements.
          </p>
      </article>
      ```

  - 把伪类和伪元素组合起来

    ```css
    article p:first-child::first-line {
        font-size: 120%;
        font-weight: bold;
    }
    ```

    上面的例子可以把第一段第一行加粗

  - 用  `::before`  `::after`  生成内容

    `::before` 或 `::after` 于`content`属性连用，可以将css中的内容插入到文本中

    ```css
    .box::before {
        content: "This should show before the other content."
    }
    ```

    ```html
    <p class="box">Content in the box in my HTML page.</p>
    ```

    注：不推荐从css插入文本字符串，这些伪元素推荐的用法是插入一个小图标，作为视觉提醒

    ```css
    .box::after {
        content: "➥";
    }
    ```

    > 常见的伪类及伪元素：[参见](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/Building_blocks/Selectors/Pseudo-classes_and_pseudo-elements)



#### 关系选择器

- 后代选择器

  用一个空格符组合两个选择器。如果一个元素的祖先( 父亲，父亲的父亲，父亲的父亲的父亲 )元素匹配第一个选择器，且这个元素本身匹配第二个选择器，那么这个元素将会被选择。

  ```css
  .box p {
      color: red;
  }
  ```

  ```html
  <div class="box"><p>Text in .box</p></div>
  <p>Text not in .box</p>
  ```

- 子代关系选择器

  子代选择器是个大于号 `>`，只会在选择器选中直接子元素的时候匹配，继承关系上更远的后台则不会匹配

  ```css
  ul > li {
      border-top: 5px solid red;
  }
  ```

  ```html
  <ul>
      <li>Unordered Item 1</li>
      <li>Unordered Item 2
          <ol>
              <li>Item 2.1</li>
              <li>Item 2.2</li>
          </ol>
      </li>
  </ul>
  ```

- 邻接兄弟

  邻接兄弟选择器 `+` 用来选中 一个元素的兄弟元素，二者必须紧邻

  ```css
  p +img
  ```

  > 选中紧随 `<p>` 元素后的 `<img>` 元素

- 通用兄弟

  可以用通用兄弟选择器 `~` 来选中一个元素不直接相邻的兄弟元素

  ```css
  h1 ~ p 
  ```

  > 选中 `<h1>` 元素所有的 `<p>` 兄弟元素