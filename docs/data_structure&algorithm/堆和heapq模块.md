#### 堆

堆是一个二叉树，它的每个父节点的值都只会小于或大于所有孩子节点的值

#### 小顶堆

根节点（或堆顶）的关键字是堆里所有节点关键字中最小者，称为小顶堆。

小顶堆要求根节点的关键字既小于或等于左子树的关键字值，又小于或等于右子树的关键字值

#### 大顶堆

根节点（或堆顶）的关键字是堆里所有节点关键字中最大者，称为大顶堆。

大顶堆要求根节点的关键字既大于或等于左子树的关键字值，又大于或等于右子树的关键字值

<img src="https://i.loli.net/2021/01/22/nfu9TCesjBrwK3V.png" alt="image.png" style="zoom: 40%;" />

#### `heapq`模块

`heapq`模块提供了堆队列算法的实现，也称为优先队列算法，默认为小顶堆，堆顶元素即为最小元素。

- `heapq.heappush(heap, item)` 

  将item的值加入堆heap中

  ```python
  In [1]: import heapq
  
  In [2]: heap = [2, 4, 5, 6, 7]
  
  In [3]: heapq.heappush(heap, 1)
  
  In [4]: heap, heap[0]
  [1, 4, 2, 6, 7, 5] 1
  ```

- `heapq.heappop(heap)`

  弹出并返回堆heap中的最小元素，使用`heap[0]`，可以访问最小元素和不删除

  ```python
  In [5]: heapq.heappop(heap)
  1
  
  In [6]: heap, heap[0]
  [2, 4, 5, 6, 7] 2
  ```

- `heapq.heappushpop(heap, item)`

  将item放入堆item中，然后弹出并返回heap的最小元素

  ```python
  In [7]: heapq.heappushpop(heap, 8)
  2
  
  In [8]: heap, heap[0]
  [4, 6, 5, 8, 7] 4
  ```

- `heapq.heapreplace(heap, item)`

  弹出并返回heap中最小的一项，同时推入新的item，堆的大小不变

  ```python
  In [9]: heapq.heapreplace(heap, 3)
  4
  
  In [10]: heap, heap[0]
  [3, 6, 5, 8, 7] 3
  ```

- `heapq.heapify(x)`

  将list x转换成堆（原地、线性时间内）

  ```python
  In [17]: x = [4, 5, 7, 0, 2, 11, 6]
  
  In [18]: x, x[0]
  [4, 5, 7, 0, 2, 11, 6] 4
  
  In [19]: heapq.heapify(x)
  
  In [20]: x, x[0]
  [0, 2, 6, 5, 4, 11, 7] 0
  ```

- 堆排序：

  将所有值push入堆中，然后每次弹出一个最小值来实现排序

  ```python
  In [21]: def heapsort(iterable):
      ...:     h = []
      ...:     for value in iterable:
      ...:         heapq.heappush(h, value)
      ...:     return [heapq.heappop(h) for _ in range(len(h)) ]
  
  In [22]: heapsort([1, 3, 6, 4, 2, 8, 0, 11, 13])
  Out[22]: [0, 1, 2, 3, 4, 6, 8, 11, 13]
  ```

  

