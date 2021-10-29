> 本文由 [简悦 SimpRead](http://ksria.com/simpread/) 转码， 原文地址 [zhuanlan.zhihu.com](https://zhuanlan.zhihu.com/p/37892676)， 本人亦有部分修改

在做 flask web 工程项目中，避免不了需要创建模型类，连接数据库，并且插入数据。寡人在做此操作的过程中碰到一个不太人性化的问题。

对于数据库字段而言，在很多的项目中，很多字段都需要设置默认值，我们一般情况下都会在字段的属性列添加一个 default 属性来制定该字段的默认值。如：

```python
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), default='admin', nullable=True)
    age = db.Column(db.Integer)
```

我们的字段是这样设置的话，如果我们用 ORM 的方式（db.session）去添加或更新数据时，我们在数据库看到的数据确实对于设置的默认值生效了。但这并不代表咱们数据库的表结构已经按照我们设置的默认值修改了。

```python
# ORM添加数据
$ flask shell
>>> from app import db, User
>>> u = User()
>>> db.session.add(u)
>>> db.session.commit()
```

```sql
db_demo_2=# select * from "user";
 id | name  | age 
----+-------+-----
  1 | admin |      
```

可以进入数据库通过`\d`来查看一下表名，你会发现此表的 **name** 字段的默认值为**空 null**

```sql
db_demo_2=# \d user
                                   Table "public.user"
 Column |         Type          | Collation | Nullable |             Default              
--------+-----------------------+-----------+----------+----------------------------------
 id     | integer               |           | not null | nextval('user_id_seq'::regclass)
 name   | character varying(64) |           |          | 
 age    | integer               |           |          | 
```

那既然表结构的 **name** 字段的默认值为空，那为什么在插入和更新数据时，又没有指定 **name** 的值，而显示的确实我在模型类设置的 **default** 值呢？

那是因为我们在执行 db 相关命令的时候，**SQLAlchemy** 自动在内部帮我们添加进去的。

我们可以通过另外的两种方式来验证一下：

1. 通过可视化数据库，用表的方式插入，提交之后，之前用 **default** 设置的默认值居然是 **null**。
2. 通过 sql 语句插入相应的数据，你同样会发现之前用 **default** 设置的默认值居然也是 **null。**

```shell
-- sql语句插入
db_demo_2=# insert into "user" (age) values (10);
INSERT 0 1
db_demo_2=# select * from "user";
 id | name  | age 
----+-------+-----
  1 | admin |      
  2 |       |  10
```

解决方法就是，在定义Model是，将**default**改为**server_default**即可：

```python
name = db.Column(db.String(64), server_default='no-admin', nullable=True)
```

设置成功后，再查看一下表结构，可以看到name字段的默认值已经变成了'no-admin'

```sql
db_demo_2=# \d "user"
                                   Table "public.user"
 Column |         Type          | Collation | Nullable |             Default              
--------+-----------------------+-----------+----------+----------------------------------
 id     | integer               |           | not null | nextval('user_id_seq'::regclass)
 name   | character varying(64) |           |          | 'no-admin'::character varying
 age    | integer               |           |          | 
```

这时我们再用sql语句差插入一条数据，可以看到name列是使用刚刚设置的`server_default`的值**no-admin**

```sql
db_demo_2=# insert into "user" (age) values (12);
INSERT 0 1
db_demo_2=# select * from "user";
 id |   name   | age 
----+----------+-----
  1 | admin    |    
  2 |          |  10
  3 | no-admin |  12
```

但是这样也有一个问题，当我们需要设置的默认值是整型或者布尔型时，你会发现报错：

```python
class User(db.Model):
    ...
    age = db.Column(db.Integer, server_default=10)
    is_confirmed = db.Column(db.Boolean, server_default=False)
```

```shell
...
sqlalchemy.exc.ArgumentError: Argument 'arg' is expected to be one of type '<class 'str'>' or '<class 'sqlalchemy.sql.elements.ClauseElement'>' or '<class 'sqlalchemy.sql.elements.TextClause'>', got '<class 'int'>'
```

这之类的错误，意思是说 **server_default** 只接收字符串类型的值，并不接受**整型或者布尔型**的值，那怎么解决呢？

解决方法也很简单，可以利用sqlalchemy提供的text()方法，将整型或布尔型默认值转换成字符串类型：

```
from sqlalchemy import text

class User(db.Model):
    ...
    age = db.Column(db.Integer, server_default=text('10'))
    is_confirmed = db.Column(db.Boolean, server_default=text('False'))
```

更新后，查看一下表结构：

```sql
db_demo_2=# \d "user"
                                      Table "public.user"
    Column    |         Type          | Collation | Nullable |             Default              
--------------+-----------------------+-----------+----------+----------------------------------
 id           | integer               |           | not null | nextval('user_id_seq'::regclass)
 name         | character varying(64) |           |          | 'no-admin'::character varying
 age          | integer               |           |          | 10
 is_confirmed | boolean               |           |          | false
```

插入一条数据查看默认值：

```sql
db_demo_2=# insert into "user" (name) values ('Rose');
INSERT 0 1
db_demo_2=# select * from "user";
 id |   name   | age | is_confirmed 
----+----------+-----+--------------
  1 | admin    |    
  2 |          |  10
  3 | no-admin |  12
  4 | Rose     |  10 | f
```

