## 检测字段类型及默认值变化



### 数据库迁移

SQLAlchemy的开发者Michael Bayer写了一个数据库迁移工具——Alembic来帮助我们实现数据库的迁移，数据库迁移工具可以在不破坏数据的情况下更新数据库表的结构。扩展Flask-Migrate集成了Alembic，提供了一些flask命令来简化迁移工作，我们将使用它来迁移数据库。

当我们的表结构有变化时，可以使用`flask db migrate `来生成迁移脚本，然后执行`flask db upgrade `来执行数据库升级，达到更新表结构的变化。

但Alembic 检测表结构变化时，是有一定局限性的，具体表现在：

- 自动检测变化
  - 表的添加及删除；
  - 列的添加剂删除；
  - 列值是否可以为空；
  - 索引及显示命名的唯一约束变化；
  - 外键约束变化
- 可选检测变化
  - 列类型的变化：仅当设置`compare_type`为`True`时生效；
  - 列默认值(特指**server_default**)的变化：仅当设置`compare_server_default`为`True`时生效
- 不可检测变化
  - 表名的变化；
  - 列名的变化；
  - 匿名约束的变化；
  - 特殊的sqlalchemy类型(如Enum)；



### 字段类型及默认值变更

定义模型类User如下：

```python
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), server_default='no-admin', nullable=True)
    age = db.Column(db.Integer, server_default=text('10'))
```

当前的表结构如下：

```sql
db_demo_2=# \d "user"
                                      Table "public.user"
    Column    |         Type          | Collation | Nullable |             Default              
--------------+-----------------------+-----------+----------+----------------------------------
 id           | integer               |           | not null | nextval('user_id_seq'::regclass)
 name         | character varying(64) |           |          | 'no-admin'::character varying
 age          | integer               |           |          | 10
```

现在我修改name字段的字段长度为128，默认值为admin；age的默认值类型为db.String，代码如下：

```python
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(128), server_default='admin', nullable=True)
    age = db.Column(db.String(4), server_default='18')
```

默认情况下，执行`flask db migrate`后，检测不到表结构的变化：

```shell
$ flask db migrate -m 'change model User'
INFO  [alembic.runtime.migration] Context impl PostgresqlImpl.
INFO  [alembic.runtime.migration] Will assume transactional DDL.
INFO  [alembic.ddl.postgresql] Detected sequence named 'user_id_seq' as owned by integer column 'user(id)', assuming SERIAL and omitting
INFO  [alembic.env] No changes in schema detected.
```

这时候需要我们修改`migrations/env.py`文件中的配置项**compare_type**、**compare_server_default**：

```python
...
    with connectable.connect() as connection:
        context.configure(
            compare_type=True,
            compare_server_default=True,
            ...
        )
...
```

这时候再执行`flask db migrate`，就会自动生成迁移脚本：

```shell
$ flask db migrate -m 'change model User after changing configuration'
...
INFO  [alembic.autogenerate.compare] Detected type change from VARCHAR(length=64) to String(length=128) on 'user.name'
INFO  [alembic.autogenerate.compare] Detected server default on column 'user.name'
INFO  [alembic.autogenerate.compare] Detected type change from INTEGER() to String(length=4) on 'user.age'
INFO  [alembic.autogenerate.compare] Detected server default on column 'user.age'
  Generating
  /Users/zhengyaqi/.virtualenvs/bluelog/test_default/migrations/versions/a59c26b4165a_change_model_user_after_changing_.py
  ...  done
(bluelog) 
```

 升级后再查看表结构，就可以看到修改已经生效了：

```sql
db_demo_2=# \d "user"
                                       Table "public.user"
    Column    |          Type          | Collation | Nullable |             Default              
--------------+------------------------+-----------+----------+----------------------------------
 id           | integer                |           | not null | nextval('user_id_seq'::regclass)
 name         | character varying(128) |           |          | 'admin'::character varying
 age          | character varying(4)   |           |          | '18'::character varying
```





