【第四章】插入、更新和删除数据
Inserting, Updating, and Deleting Data (时长42分钟)

导航

第一章是课程简要介绍

第二、三章讲如何 “查询”，其中第二章讲单个表里如何“查询”，第三章讲如何使用多张表“查询”（通过横纵向连接）

这一章讲如何 “增、改、删”

前四章构成了SQL的基础 “增删改查”

1. 列属性
Column Attributes (3:24)

小结

点击表的扳手按钮：打开设计模式，介绍了一些表中字段/列的属性。

一个疑问：为什么 points 的默认值是带引号的0 '0' ？

2. 插入单行
Inserting a Row (5:46)

小结

INSERT INTO 目标表 （目标列，可选，逗号隔开）
VALUES (目标值，逗号隔开)
案例

在顾客表里插入一个新顾客的信息

法1. 若不指明列名，则插入的值必须按所有字段的顺序完整插入

USE sql_store;

INSERT INTO customers -- 目标表
VALUES (
    DEFAULT,
    'Michael',
    'Jackson',
    '1958-08-29',  -- DEFAULT/NULL/'1958-08-29'
    DEFAULT,
    '5225 Figueroa Mountain Rd', 
    'Los Olivos',
    'CA',
    DEFAULT
    );
法2. 指明列名，可跳过取默认值的列且可更改顺序，一般用这种，更清晰

INSERT INTO customers (
    address,
    city,
    state,
    last_name,
    first_name,
    birth_date,
    )
VALUES (
    '5225 Figueroa Mountain Rd',
    'Los Olivos',
    'CA',
    'Jackson',
    'Michael',    
    '1958-08-29',  
    )
```
3. 插入多行
Inserting Multiple Rows (3:18)

小结

VALUES …… 里一行内数据用括号内逗号隔开，而多行数据用括号间逗号隔开

案例

插入多条运货商信息

USE sql_store

INSERT INTO shippers (name)
VALUES ('shipper1'),
       ('shipper2'),
       ('shipper3');
练习

插入多条产品信息

USE sql_store;

INSERT INTO products 
VALUES (DEFAULT, 'product1', 1, 10),
       (DEFAULT, 'product2', 2, 20),
       (DEFAULT, 'product3', 3, 30)
或

INSERT INTO products (name, quantity_in_stock, unit_price)
VALUES ('product1', 1, 10),
       ('product2', 2, 20),
       ('product3', 3, 30)
还是感觉后面这种指明列名的要清晰一点

注意

对于AI (Auto Incremental 自动递增) 的id字段，MySQL会记住删除的/用过的id，并在此基础上递增

4. 插入分级行
Inserting Hierarchical Rows (5:53)

小结

订单表（orders表）里的一条记录对应订单项目表（order_items表）里的多条记录，一对多，是相互关联的父子表。通过添加一条订单记录和对应的多条订单项目记录，学习如何向父子表插入分级（层）/耦合数据（insert hierarchical data）：

关键：在插入子表记录时，需要用内建函数 LAST_INSERT_ID() 获取相关父表记录的自增ID（这个例子中就是 order_id)
内建函数：MySQL里有很多可用的内置函数，也就是可复用的代码块，各有不同的功能，注意函数名的单词之间用下划线连接
LAST_INSERT_ID()：获取最新的成功的 INSERT 语句 中的自增id，在这个例子中就是父表里新增的 order_id.
案例

新增一个订单（order），里面包含两个订单项目/两种商品（order_items），请同时更新订单表和订单项目表

USE sql_store;

INSERT INTO orders (customer_id, order_date, status)
VALUES (1, '2019-01-01', 1);

-- 可以先试一下用 SELECT last_insert_id() 看能否成功获取到的最新的 order_id

INSERT INTO order_items  -- 全是必须字段，就不用指定了
VALUES 
    (last_insert_id(), 1, 2, 2.5),
    (last_insert_id(), 2, 5, 1.5)
5. 创建表的副本
Creating a Copy of a Table (8:47)

小结

DROP TABLE 要删的表名、CREATE TABLE 新表名 AS 子查询

TRUCATE '要清空的表名'、INSERT INTO 表名 子查询

子查询里当然也可以用WHERE语句进行筛选

案例 1

运用 CREAT TABLE 新表名 AS 子查询 快速创建表 orders 的副本表 orders_archived

USE sql_store;

CREATE TABLE orders_archived AS
    SELECT * FROM orders  -- 子查询
SELECT * FROM orders 选择了 oders 中所有数据，作为AS的内容，是一个子查询

子查询： 任何一个充当另一个SQL语句的一部分的 SELECT…… 查询语句都是子查询，子查询是一个很有用的技巧。
注意

创建已有的表或删除不存在的表的话都会报错，所以建表和删表语句都最好加上条件语句（后面会讲）

案例 2

不再用全部数据，而选用原表中部分数据创建副本表，如，用今年以前的 orders 创建一个副本表 orders_archived，其实就是在子查询里增加了一个WHERE语句进行筛选。注意要先 drop 删掉 或 truncate 清空掉之前建的 orders_archived 表再重建或重新插入数据。

法1. DROP TABLE 要删的表名、CREATE TABLE 新表名 AS 子查询

USE sql_store;

DROP TABLE orders_archived;  -- 也可右键该表点击 drop
CREATE TABLE orders_archived AS
    SELECT * FROM orders
    WHERE order_date < '2019-01-01'
法2. TRUCATE '要清空的表名'、INSERT INTO 表名 子查询

INSERT INTO 表名 子查询 很常用，子查询替代原先插入语句中 VALUES(……,……),(……,……),…… 的部分

TRUNCATE 'orders_archived';
-- 也可右键该表点击 truncate  
/*新的 8.0版 MySQL 的语法好像变为了 TRUNCATE TABLE orders_archived？
那样就与 DROP TABLE orders_archived 一致了*/
INSERT INTO orders_archived  
-- 不用指明列名，会直接用子查询表里的列名
    SELECT * FROM orders  
    -- 子查询，替代原先插入语句中VALUES(……,……),(……,……),…… 的部分
    WHERE order_date < '2019-01-01'
练习

创建一个存档发票表，只包含有过支付记录的发票并将顾客id换成顾客名字

构建的思路顺序：

先创建子查询，确定新表内容：
A. 合并发票表和顾客表

B. 筛选支付记录不为空的行/记录

C. 筛选（并重命名）需要的列

2. 第1步得到的查询内容，可以先运行看一下，确保准确无误后，再作为子查询内容存入新创建的副本订单存档表 CREATE TABLE 新表名 AS 子查询

USE sql_invoicing;

DROP TABLE invoices_archived;  

CREATE TABLE invoices_archived AS
    SELECT i.invoice_id, c.name AS client, i.payment_date  
    -- 为了简化，就选这三列
    FROM invoices i
    JOIN clients c
        USING (client_id)
    WHERE i.payment_date IS NOT NULL
    -- 或者 i.payment_total > 0
6. 更新单行
小结

用 UPDATE …… 语句 来修改表中的一条或多条记录，具体语法结构：

UPDATE 表 
SET 要修改的字段 = 具体值/NULL/DEFAULT/列间数学表达式 （修改多个字段用逗号分隔）
WHERE 行筛选
实例

USE sql_invoicing;

UPDATE invoices
SET 
    payment_total = 100 / 0 / DEFAULT / NULL / 0.5 * invoice_total, 
    /*注意 0.5 * invoice_total 的结果小数部分会被舍弃，
    之后讲数据类型会讲到这个问题*/
    payment_date = '2019-01-01' / DEFAULT / NULL / due_date
WHERE invoice_id = 3
7. 更新多行
Updating Multiple Rows (3:14)

小结

语法一样的，就是让 WHERE…… 的条件包含更多记录，就会同时更改多条记录了

注意

Workbench默认开启了Safe Updates功能，不允许同时更改多条记录，要先关闭该功能（在 Edit-Preferences-SQL Editor-Safe Updates）

USE sql_invoicing;

UPDATE invoices
SET payment_total = 233, payment_date = due_date
WHERE client_id = 3  
-- 该客户的发票记录不止一条，将同时更改
/WHERE client_id IN (3, 4) 
-- 第二章 4~9 讲的那些写 WHERE 条件的方法均可用
-- 甚至可以直接省略 WHERE 语句，会直接更改整个表的全部记录
练习

让所有非90后顾客的积分增加50点

USE sql_store;

UPDATE customers
SET points = points + 50
WHERE birth_date < '1990-01-01'
8. 在Updates中用子查询
Using Subqueries in Updates (5:36)

小结

非常有用，其实本质上是将子查询用在 WHERE…… 行筛选条件中

注意

括号的使用
IN …… 后除了可接 （……, ……） 也可接由子查询得到的多个数据（一列多条数据），感觉和前面 VALUES 后可接子查询道理是相通的
案例

更改发票记录表中名字叫 Yadel 的记录，但该表只有 client_id，故先要从另一个顾客表中查询叫 Yadel 人的 client_id

实际中这是很可能的情形，比如一个App是通过搜索名字来更改发票记录的

USE sql_invoicing;

UPDATE invoices
SET payment_total = 567, payment_date = due_date

WHERE client_id = 
    (SELECT client_id 
    FROM clients
    WHERE name = 'Yadel');
    -- 放入括号，确保先执行

-- 若子查询返回多个数据（一列多条数据）时就不能用等号而要用 IN 了：
WHERE client_id IN 
    (SELECT client_id 
    FROM clients
    WHERE state IN ('CA', 'NY'))
最佳实践

Update 前，最好先验证看一看子查询以及WHERE行筛选条件是不是准确的，筛选出的是不是我们的修改目标， 确保不会改错记录，再套入 UPDATE SET 语句更新，如上面那个就可以先验证子查询：

SELECT client_id 
FROM clients
WHERE state IN ('CA', 'NY')
以及验证WHERE行筛选条件（即先不UPDATE，先SELECT，改之前，先看一看要改的目标选对了没）

SELECT *
FROM invoices
WHERE client_id IN (
    SELECT client_id 
    FROM clients
    WHERE state IN ('CA', 'NY')
)
确保WHERE行筛选条件准确准确无误后，再放到修改语句后执行修改：

UPDATE invoices
SET payment_total = 567, payment_date = due_date
WHERE client_id IN (
    SELECT client_id 
    FROM clients
    WHERE state IN ('CA', 'NY')
练习

将 orders 表里那些 分数>3k 的用户的订单 comments 改为 'gold customer'

思考步骤：

WHERE 行筛选出要求的顾客
SELECT 列筛选他们的id
将前两步 作为子查询 用在修改语句中的 WHERE 条件中，执行修改
USE sql_store;

UPDATE orders
SET comments = 'gold customer'
WHERE customer_id IN
    (SELECT customer_id
    FROM customers
    WHERE points > 3000)
9. 删除行
Deleting Rows (1:24)

小结

语法结构：

DELETE FROM 表 
WHERE 行筛选条件
（当然也可用子查询）
（若省略 WHERE 条件语句会删除表中所有记录（和 TRUNCATE 等效？））
案例

选出顾客id为3/顾客名字叫'Myworks'的发票记录

USE sql_invoicing;

DELETE FROM invoices
WHERE client_id = 3
-- WHERE可选，省略就是会删除整个表的所有行/记录
/WHERE client_id = 
    (SELECT client_id  
    /*Mosh 错写成了 SELECT *，将报错：
    Error Code: 1241. Operand should contain 1 column(s) 
    Operand n. [计] 操作数；[计] 运算对象；运算元 */
    FROM clients
    WHERE name = 'Myworks')
10. 恢复数据库
Restoring the Databases (1:06)

就是重新运行那个 create-databases.sql 文件以重置数据库
