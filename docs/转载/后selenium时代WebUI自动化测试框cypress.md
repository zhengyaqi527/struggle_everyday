> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 https://cloud.tencent.com/developer/article/1509385

Chapter1

当前最流行的 Web UI 自动化测试方案

**1**

selenium+webdriver

优点：selenium 的 API 封装遵循 W3C 提供的 webdriver 标准，很好的支持主流浏览器 chrome，firefox，IE，Safari 等，无论从资料量，社区活跃度，第三方拓展方案等都是首选

缺点：这个方案的一般工作流程是：测试用例 -> 测试框架 -> selenium -> webdriver -> 浏览器，这个流程每加一个环节，用例的编写，维护和调试成本都会上升

那还有没有其他的方案呢？答案是肯定的

**2**

Inject script 方案

什么是 inject script？

Inject script 的方式是指在浏览器打开的 Web 应用内注入测试引擎、测试用例等脚本，将测试用例执行在被测试应用的运行时中（这跟使用 selenium 调用 js 脚本是不一样的）

inject script 和 selenium webdriver 的区别：

依托于 selenium 构建的测试框架的核心问题在于都是从外部控制浏览器和 Web 应用，执行命令或者获取信息都需要通过网络请求进行交互，因此交互的信息需要进行序列化。这不仅限制了交互的内容，还对 debug 带来了极大的不便，同时网络请求带来的开销也让测试变得更加缓慢。

与之相反的是 inject script 选择从内部控制浏览器，测试用例代码将和被测试的 Web 应用运行在同一个浏览器运行时中，可以理解为注入的脚本即为测试客户端，与后端建立通信，所有的操作指令都是通过 Javascipt 实现并执行，本质上只是函数的调用，客户端和后端之间的通信仅用于测试结果的收集，不包含具体的指令执行

**Chapter2**

Inject script 方案的代表：Cypress

1

Cypress 简介

先看看 cypress 是如何做自我介绍的

web 技术已经进化了，web 的测试技术最终还是跟上了脚步，是谁呢？

对在浏览器中运行的任何东西进行快速、简单和可靠的测试

当然是 cypress

出现前：selenium 方案

需要框架：Mocha Qunit Jasmine Karma

需要断言库：Chai Expect.js

二次封装：Protractor Nightwatch Webdriver

第三方库：Sinon TestDouble

cypress 是一个一体化测试框架 mock ，断言 ，打桩都有了唯独没有 selenium

2

**Cypress 特点**

**特点一、从不使用 selenium**

大多数端到端测试工具都是基于 selenium 的，这就是为什么它们都有相同的问题。为了让 Cypress 与众不同，Cypress 使用全新的架构，它运行在与应用程序相同的运行循环中，而 selenium 则通过网络执行远程命令

**特点二、专注于做好端到端测试**

Cypress 不是一个通用的自动化框架，也不是一个用于后端服务的单元测试框架。已经有很好的工具可以做到这一点。相反，我们专注于一件事——当您为您的网络应用程序编写端到端测试时，提供良好的使用体验

**特点三、在任何前端框架或网站上工作**

Cypress 可以测试任何在网络浏览器中运行的东西。Cypress 周围的所有架构都是为了特别好地处理现代 JavaScript 框架而构建的。我们有数百个项目使用最新的 React，Angular，Vue，Elm 等。框架。Cypress 也同样适用于旧的服务器渲染页面或应用程序

**特点四、只能用 JavaScript 编写**

虽然您可以从任何其他语言编译成 JavaScript，但最终测试代码是在浏览器本身内部执行的。没有语言或驱动程序绑定——现在有，将来也只会有 JavaScript

**特点五、一体化**

编写端到端测试需要许多不同的工具协同工作。有了赛普拉斯，你可以在一个地方得到多种工具。没有必要安装 10 个独立的工具和库来设置您的测试套件。我们采用了一些您可能已经熟悉的同类最佳工具，并使它们无缝地协同工作

**特点六、测试和开发同样适合**

我们的目标之一是让测试驱动的开发成为端到端测试的现实。当您在构建应用程序时使用柏树是最好的。我们给你尽快编码的能力

**特点七、运行速度飞一般的感觉**

这些架构上的改进首次释放了使用完整的端到端测试进行 TDD 的能力。cypress 已经是一个成熟的框架，因此测试和开发可以同时进行。您可以在通过测试驱动整个开发过程的同时更快地开发，因为: 您可以看到您的应用程序；您仍然可以访问开发工具；并且变化被实时反映。最终结果是你将会开发更多，你的代码将会更好，并且它将会被完全测试。如果您选择我们的仪表板服务，并行化和自动负载平衡将进一步提高您的测试速度

chapter3

小结

1

ThroughWorks 技术雷达

这里说明下为什么没选 TestCafe 作为 Inject Script 的代表

使用 ThroughWorks 技术雷达来解释 2019 年 4 月的资料

2

Cypress 已经采纳

3

而 TestCafe 还在试验中

如果你的团队没有 js 的学习成本或者，有一定的 js 基础，又面临 selenium 自动化性能差，响应时间长，资源加载慢等问题的困扰，不妨尝试下 Cypress

最后送上传送门：https://www.cypress.io/

本文分享自微信公众号 - 2019-09-18

本文参与[腾讯云自媒体分享计划](https://cloud.tencent.com/developer/support-plan)，欢迎正在阅读的你也加入，一起分享。