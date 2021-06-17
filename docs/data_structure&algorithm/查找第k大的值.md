#### 需求：

设计一个找到数据流中第 k 大元素的类（class）。

> 注意是排序后的第 k 大元素，不是第 k 个不同的元素。

请实现 KthLargest 类：

- KthLargest(int k, int[] nums) 使用整数 k 和整数流 nums 初始化对象。
- int add(int val) 将 val 插入数据流 nums 后，返回当前数据流中第 k 大的元素

#### 全量排序

使用python中sorted排序，每次加入元素后，都重新进行排序，然后取第k个元素

```python
class KthLargest(object):
    def __init__(self, k, nums):
        self.k = k
        self.nums = nums

    # 插入元素
    def add(self, item):
        self.nums.append(item)
        if len(self.nums) < self.k:
            return None
        else:
            self.nums = sorted(self.nums, reverse=True)
            return self.nums[self.k-1]
```

#### 仅作一次全量排序

列表nums逆序排列后，取前k个元素，重新赋予nums
插入元素item时，将len(nums)与k比较：

  - len(nums) < k，将item追加到nums中；
  - len(nums) >= k，比较nums[-1]与item：
    - nums[-1] < item，则将二者替换；
    - nums[-1] >= item，不作处理
    

再次将nums倒序排列，返回nums[-1]

```python
class KthLargest(object):
    def __init__(self, k, nums):
        self.k = k
        self.nums = sorted(nums, reverse=True)[:k]
    
    # 插入元素并返回第k大的值
    def add(self, item):
        if len(self.nums) < self.k:
            self.nums.append(item)
        elif item > self.nums[-1]:
            self.nums[-1] = item
        self.nums = sorted(self.nums, reverse=True)
        if len(self.nums) < self.k:
            return None
        else:
            return self.nums[-1]
```

#### 利用`heapq`小顶堆方式

使用小顶堆，python模块heapq
先将全量列表nums逆序排列，取前k个元素，然后原地转为小顶堆；
插入元素item时，先判断当前列表nums长度和k的大小：

 - 如果len(nums) < k，则直接将item加入小顶堆，heapq.heappush(nums, item)
 - 如果len(nums) >= k，则比较当前小顶堆中最小元素min（即nums[0]）和item：
   - 如果min >= item，则不处理
   - 如果min < item，则小顶堆中的最小的元素与item替换，headq.headreplace(nums, item)

最后返回nums[0]

```python
import heapq

class KthLargest(object):
    def __init__(self, k, nums):
        self.k = k
        self.nums = sorted(nums, reverse=True)[:self.k]
        heapq.heapify(self.nums)
    
    def add(self, item):
        if len(self.nums) < self.k:
            heapq.heappush(self.nums, item)
        elif self.nums[0] < item:
                heapq.heapreplace(self.nums, item)

        if len(self.nums) < self.k:
            return None    
        return self.nums[0]
```

