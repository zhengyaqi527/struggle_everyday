> 在css中，所有的元素都是被一个个`盒子（box）`，理解这些盒子的基本原理，是我们使用css实现精准布局、处理元素排列的关键。



### 块级盒子(Block boxes) 和内联盒子(Inline boxes)

#### 块级盒子 `Block`

- 每个盒子都会换行；
- 盒子会在内联的方向上扩展并占据父容器在该方向上的所有可利用空间，在绝大多数情况下意味着盒子回和父容器一样宽；
- `width` 和 `height` 属性可以发挥作用；
- 内边距 `padding`、外边距 `margin` 和边框 `border` 会将其他元素从盒子周围推开

除非特殊指定，诸如标题(`<h1>`等)和段落(`<p>`)默认情况下都是块级的盒子。

#### 内联盒子 `Inline`

- 盒子不会产生换行；
- `width` 和 `height` 属性将不起作用；
- 垂直方向的内边距、外边距和边框会应用但不会把其他处于 `inline` 状态的盒子推开；
- 水平方向的内边距、外边距和边框会应用而且也会把其他处于 `inline` 状态的盒子推开

用做链接的 `<a>` 元素、 `<span>`、 `<em>` 以及 `<strong>` 都是默认处于 `inline` 状态的。



### 什么是CSS盒模型

完整的css盒模型应用于块级盒子，内联盒子只使用盒模型中定义的部分内容。

模型定义了盒的每一部分：`margin` `padding` `border` `content`，合在一起就可以看到在页面创建的内容。



#### 盒模型的各个部分

CSS中组成一个盒子需要：

- `Content box`：这个区域用于显示内容，大小可以通过设置 `weight` 和 `height`;
- `Padding box`：包围在内容区域外面的空白区域，大小通过`padding`相关属性设置；
- `Border box`：边框盒包裹内容区域和内边距区域，大小通过 `border`相关属性设置；
- `Margin box`：这是最外面的区域，是盒子和其他元素之间的空白区域，大小通过 `margin` 相关属性设置

如图：

![图片.png](https://i.loli.net/2020/11/02/FabZcq9LDzpw1gB.png)



 #### 标准盒模型 `content-box`

在标准模型中，如果给盒设置`width` 和 `height`，实际上设置的是`content box` 。`padding` 和 `border` 再加上设置的宽高一起决定整个盒子的大小。

如果设置了 `width`  `height`  `padding`  `border`  `margin` 如下:

```css
.box {
    width: 350px;
    height: 150px;
    padding: 25px;
    margin: 25px;
    border: 5px solid block;
}
```

如果使用标准盒模型，尺寸为 `padding` +`border` +`content box`：

- 宽度：`350 + 25*2 + 5*2 = 410px`

- 高度：`150 + 25*2 + 5*2 =210px `

  ![图片.png](https://i.loli.net/2020/11/03/8y1SWOpYJwZLuCD.png)

  > 注：`margin`不计入实际大小。当然 `margin`会影响盒子在页面所在的空间，但是影响的是盒子的外部空间。盒子的范围到边框 `border` 为止，不会延伸到 `margin`

  

#### 替代（IE）盒模型 `border-box`

CSS还有一个替代盒模型。使用这个模型，所有的宽度都是可见宽度，所以内容宽度是该宽度减去边框和填充部分。使用上面相同的样式得到：

- 盒模型： `width = 350px`, `height = 150px`
  
- 内容区域：`width = 290px`, `height = 90px `

![图片.png](https://i.loli.net/2020/11/03/4fuCzrhnZK3WRGq.png)

  

默认浏览器会使用标准模型，如果需要使用替代模型，可以通过为其设置`box-sizing: border-box;` 来实现。

这样就可以告诉浏览器使用 `border-box` 来定义区域，从而设定你想要的大小。

```css
.box {
    box-sizing: border-box;
}
```

如果你希望所有元素都使用替代模式，而且确实很常用，设置 `box-sizing` 在 `<html>` 元素上，然后设置所有元素继承该属性

```css
html {
    box-sizing: border-box;
}
*, *::before, *::after {
    box-sizing: inherit;
}
```



### 内边距 外边距 边框

#### 外边距 `margin`

外边距是盒子周围一圈看不到的空间，它会把其他元素从盒子旁边推开。

外边距属性值可以是正也可以是负，设置复制会导致和其他内容重叠。无论使用标准模型还是替代模型，外边距总是在计算可见部分后额外添加。

我们可以使用`margin`属性一次控制一个元素的所有外边距，或者每边单独使用等价的普通属性控制

- `margin-top`
- `margin-right`
- `margin-bottom`
- `margin-left`

##### 外边距折叠

> 详见 [margin-collapse](../06_01_margin-collapse.md)



#### 边框 `border`

边框是在边距和填充框之间绘制的。

为边框设置样式时，有大量的属性可以使用：有一个边框，每个边框都有样式、宽度和颜色

- 可以使用 `border` 属性一次设置所有四个边框的宽度、颜色和样式；
- 也可以用以下属性分别设置每边的宽度、颜色和样式：
  - `border-top`
  - `border-right`
  - `border-bottom`
  - `border-left`z
- 设置所有边的颜色、样式或宽度
  - `border-width`
  - `border-style`
  - `border-color`



#### 内边距 `padding`

内边距位于边框和内容区域之间。与外边距不同的是，不能设置负值的内边距，所有的值必须是`0` 或者正值。

应用于元素的任何背景都将显示在内边距后面，内边距通常用于将内容推离边框。

我们可以使用`padding`属性一次控制一个元素的所有内边距，或者每边单独使用等价的普通属性控制

- `padding-top`
- `padding-right`
- `padding-bottom`
- `padding-left`






