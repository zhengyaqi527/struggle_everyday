- 在html中应用css的三种方式

  - 外部样式表

    外部样式表是指将CSS编写在扩展名为`.css` 的单独文件中，并从HTML`<link>` 元素引用它的情况。

    ```html
    <link href="style.css" rel="stylesheel">
    ```

  - 内部样式表

    内部样式表是指不使用外部CSS文件，而是将CSS放在HTML文件[``](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/head)标签里的[``](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/style)标签之中。

    ```html
    <head>
        <style>
            h1 {
                color: blue;
                background-color: yellow;
            }
        </style>
    </head>
    ```

  - 内联样式

    内联样式表存在于HTML元素的style属性之中，其特点是每个CSS表只影响一个元素（不推荐使用）

    ```html
    <p style="color:red;">This is a css example</p>
    ```

- css构成

  - 属性：人类可读的标识符，指示你想要更改的样式特征(例如`font-size`, `width`, `background-color`)
  - 值：每个指定的属性都有一个值，该值指示您希望如何更改这些样式特性
    - 函数：一个函数由函数名和一些括号组成，其中放置了该函数的允许值。

- css注释

  CSS中的注释以`/*`开头，以`*/`结尾

  ```css
  /*.special { 
    color: red; 
  }*/
  ```

  

  

