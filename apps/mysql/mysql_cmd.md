MySQL Command Notes
===================

CMD
---

``` sql
CREATE DATABASE db_name;                        -- 创建数据库
DROP DATABASE db_name;                          -- 删除数据库

-- charset
SELECT @@character_set_database, @@collation_database;
                                                -- 查看所有数据库charset
SELECT SCHEMA_NAME,
       DEFAULT_CHARACTER_SET_NAME,
       DEFAULT_COLLATION_NAME
    FROM INFORMATION_SCHEMA.SCHEMATA;           -- 查看所有数据库charset
ALTER DATABASE foo CHARSET = utf8;              -- 设置数据库默认编码
ALTER DATABASE db_name CHARACTER SET utf8       -- 设置数据库默认编码

SHOW TABLE STATUS WHERE Name LIKE '%ff%';       -- 表状态(包含charset), WHERE 可选
ALTER TABLE foo CONVERT TO CHARSET utf8;        -- 转换表为utf-8
ALTER TABLE foo DEFAULT CHARSET = utf8;         -- 设置表默认编码

-- column
ALTER TABLE foo ADD COLUMN bar VARCHAR(100);    -- 增加列
ALTER TABLE foo MODIFY COLUMN bar VARCHAR(100) AFTER id;
                                                -- 修改列顺序

SELECT DATABASE();                              -- 当前数据库
SELECT CONCAT('http://', 'domain');             -- 字符串拼接
SELECT VERSION();                               -- mysql内查看版本
SELECT USER();                                  -- 当前用户
SHOW warnings;                                  -- 查看警告内容
SHOW variables LIKE 'version';                  -- mysql内查看版本

alter user 'root'@'%' identified by 'pwd';      -- 修改用户密码
```

Usage
-----

### 创建和更新日期

``` sql
CREATE TABLE foo (
    `creation_time`     DATETIME DEFAULT CURRENT_TIMESTAMP,
    `modification_time` DATETIME ON UPDATE CURRENT_TIMESTAMP
)
```

### shell中登录数据库

``` shell
# mysql -u $user -p$pw $db
# 上面会导致输出`-p $pw`的样子
mysql -u $user -p"$(echo $pw)" $db      # String格式变量
```

### 时间相关内置函数

    DATE('2017-05-23')          # 格式化字符串为日期
    CURDATE()                   # 当前日期
    NOW() - INTERVAL 10 DAY     # 当前时间的10天前

### 格式化日期

    DATE_FORMAT(date, format)
    DATE_FORMAT(NOW(), '%Y年%m月%d日')

### mysqldump

    -d                  # 不导出数据
    -no-data            # 同上

    --compact           # 紧凑结构?

### 查看表结构

    DESCRIBE table;
    SHOW CREATE TABLE table;        # 可以看编码

### 刷新权限

    flush privileges;

### 创建数据库

    create database data_name;
    grant all on foo.* to user@localhost with grant option;

### insert

    insert into table (key1, key2) values ( value1, value2);

### 导出表结构

> [导出数据库结构](http://stackoverflow.com/a/6175506/4757521)
> [仅包含X表或除了X表](https://dba.stackexchange.com/a/9309)

    # -d (--no-data)    不导出数据
    mysqldump -u blue -p123 -d hkgj_test customer_label customer_customerlabel product_label product_productlabel > ~/github/hkgj-api/20170517_labels_schema.sql
