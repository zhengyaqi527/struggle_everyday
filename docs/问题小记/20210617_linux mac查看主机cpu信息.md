### Linux

#### proc简介

在linux的根目录下存在一个/proc目录，/proc文件系统是一种虚拟文件系统，以文件系统目录和文件形式提供一个指向内核数据结构的接口，通过它能够查看和改变各种系统属性。`/proc`目录下的大部分文件都是只读的，部分文件是可写的，我们通过这些可写的文件来修改内核的一些配置。

#### cpuinfo

`cpuinfo` 文件中展示了系统CPU的提供商和相关配置信息。

#### 几个概念：物理cpu 核数 逻辑cpu

- 物理CPU数 `physical id`：主板上实际插入的cpu数量，可以数不重复的 `physical id` 有几个

- CPU核心数 `cpu cores`：单块CPU上面能处理数据的芯片组的数量，如双核、四核等 

- 逻辑CPU数 `processor`：可以数不重复的 `processor` 有几个

  - 逻辑CPU = 物理CPU颗数 × 每颗中核数   　    # 不支持超线程技术或没有开启此技术

  - 逻辑CPU = 物理CPU颗数 × 每颗中核数 * 2 　 # 表示CPU支持超线程技术

    > 简单来说，超线程技术可使处理器中的1 颗内核如2 颗内核那样在操作系统中发挥作用。这样一来，操作系统可使用的执行资源扩大了一倍，大幅提高了系统的整体性能

#### 文件内容

```shell
cat /proc/cpuinfo
```

执行结果如下图：

![image.png](https://i.loli.net/2021/06/17/T9EaJ4YCZHF8MPu.png)

具体解释如下(部分）：

- `processor` ：逻辑处理器的唯一标识符。

- `physical id` ：每个物理CPU的唯一标识符。

- `core id` ：每个内核的唯一标识符。

- `siblings` ：位于相同物理CPU中的逻辑处理器的数量。

- `cpu cores` ：位于相同物理CPU中的内核数量。

  >1. 拥有相同 `physical id` 的所有逻辑处理器共享同一个物理插座。每个 physical id 代表一个唯一的物理CPU。
  >2. `Siblings` 表示位于这一物理CPU上的逻辑处理器的数量。它们可能支持也可能不支持超线程（HT）技术。
  >3. 每个 `core id` 均代表一个唯一的处理器内核。所有带有相同 `core id` 的逻辑处理器均位于同一个处理器内核上。
  >4. 如果有一个以上逻辑处理器拥有相同的 `core id` 和 `physical id`，则说明系统支持超线程（HT）技术。
  >5. 如果有两个或两个以上的逻辑处理器拥有相同的 `physical id`，但是 `core id` 不同，则说明这是一个多内核处理器。`cpu cores` 条目也可以表示是否支持多内核。

#### 快速查询

- 查询系统有几颗物理cpu

  ```she
  ~$ cat /proc/cpuinfo | grep "physical id" | sort | uniq
  physical id	: 0
  
  ~$ cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l
  1
  ```
  
- 查询系统每颗物理cpu的核心数：

  ```she
  ~$ cat /proc/cpuinfo | grep "cpu cores" | uniq
  cpu cores	: 2
  ```

- 查询系统有多少个逻辑cpu

  ```shell
  ~$ cat /proc/cpuinfo | grep "processor"
  processor	: 0
  processor	: 1
  processor	: 2
  processor	: 3
  ~$ cat /proc/cpuinfo | grep "processor" | wc -l
  4
  ```

- 查询系统的每颗物理cpu核心是否启用超线程技术，如果启用此技术那么每个物理核心又可分为两个逻辑处理器。

  ```she
  ~$ cat /proc/cpuinfo | grep -e "cpu cores" -e "siblings" | sort | uniq
  cpu cores	: 2
  siblings	: 4
  ```

  > 如果cpu cores数量和siblings数量一致，则没有启用超线程，否则超线程被启用。



### MacOS

#### system_profiler

在macOS中，并不能使用 `cat /proc/cpuinfo` 来查看CPU的信息，但我们可以用 `system_profiler` 命令查看系统基本硬件信息，如下：

```shell
$ system_profiler SPHardwareDataType
Hardware:

    Hardware Overview:

      Model Name: MacBook Pro
      Model Identifier: MacBookPro17,1
      Chip: Apple M1
      Total Number of Cores: 8 (4 performance and 4 efficiency)
      Memory: 16 GB
      System Firmware Version: 6723.81.1
      Serial Number (system): C043G3SVQ65N
      Hardware UUID: 3A46E7F5-34E1-5D29-95B4-F6F0F8DFB3FB
      Provisioning UDID: 00008103-001239061431331E
      Activation Lock Status: Enabled
```

#### sysctl

上述命令得到的信息过于简单，但系统提供了另一个命令 `sysctl`，可以让我们得到更丰富的cpu信息，如下：

```she
$ sysctl machdep.cpu
machdep.cpu.cores_per_package: 8
machdep.cpu.core_count: 8
machdep.cpu.logical_per_package: 8
machdep.cpu.thread_count: 8
machdep.cpu.brand_string: Apple M1 

$ sysctl hw.physicalcpu
hw.physicalcpu: 8
$ sysctl hw.logicalcpu
hw.logicalcpu: 8
```

