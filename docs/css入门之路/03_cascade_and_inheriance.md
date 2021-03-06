- 冲突规则

  - 层叠

    Stylesheet cascade（层叠样式表），当应用两条同级别规则到一个元素的时候，写到后面的规则就是实际使用的规则

  - 优先级

    浏览器是根据优先级来决定当多个规则有不同选择器对应相同的元素的时候需要哪个规则。

    - 一个元素不是很具体，会选择页面上该类型的所有元素，所以它的优先级会低一些
    - 一个类选择器稍微具体点，它会选择页面中有特定 `class` 属性值的元素，所以它的优先级会高一些

  - 继承

    一些设置在父元素的css属性是可以被子元素继承的，有些则不能

- 理解继承

  - 控制继承

    css为控制继承提供了四个通用属性值。每个css属性都接收这些值。

    - `inherit` 设置该属性会使子元素属性和父元素相同，实际上，就是“开启继承”
    - `initial` 设置属性值和浏览器默认样式相同。如果浏览器默认样式中未设置且该属性是默认继承的，那么会设置成 `inherit`
    - `unset` 将属性重置为默认值，也就是属性如果自然继承那么就是 `inherit`，否则和 `unset` 一样
    - `revert` 很少有浏览器支持

  - 重设所有属性值

    CSS 的 shorthand 属性 `all` 可以用于同时将这些继承值中的一个应用于（几乎）所有属性。

    它的值可以是其中任意一个(`inherit`, `initial`, `unset`, or `revert`)。

    这是一种撤销对样式所做更改的简便方法，以便回到之前已知的起点。

    ```css
    blockquote {
        all: inherit;
    }
    ```

- 理解层叠

  - 资源顺序

    如果有超过一条规则，而且都是相同的权重，那么最后面的规则会应用。

    可以理解为 **后面的规则覆盖前面的规则**，直到最后一个开始设置样式。

  - 优先级

    一些情况下，有的规则最后出现，但是却应用了前面的规则，这是因为前面的具有更高的优先级，它范围更小，因此浏览器就把它选择为元素的样式。
  
    对浏览器来说，不同类型的选择器有不同的分值，把这些分数相加就得到特定选择器的权重，然后就可以进行匹配。
  
    一个选择器的优先级可以说是由四个部分相加，可以认为是 `个` `十`  `百` `千` —— 四位数的四个位数：
  
    - 千位：如果声明在 `style` 的属性（内联样式）则该位的一份。这样的声明没有选择器，所以它得分总是 `1000`；
    - 百位：选择器中包含ID选择器则该位的一分；
    - 十位：选择器中包含类选择器、属性选择器或者伪类则该位得一分；
    - 个位：选择器中包含元素、伪元素选择器，则该位得一分
  
    > 注：通用选择器(`*`)、组合符(`+`, `>`, `~`, ` ' '`)、否定伪类(`:not`)不会影响优先级
  
  - 重要程度