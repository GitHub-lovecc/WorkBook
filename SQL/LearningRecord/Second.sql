https://zhuanlan.zhihu.com/p/222932740感谢这位前辈的笔记

【第二章】在单一表格中检索数据
Retrieving Data From a Single Table (时长53分钟)

1. 选择语句
The SELECT Statement (5:50)

导航

第1节先看一下选择语句整体是什么样子，本章后面的小节会分别讲解其中各子句的具体写法

实例

USE sql_store;

SELECT * / 1, 2  -- 纵向筛选列，甚至可以是常数
FROM customers  -- 选择表
WHERE customer_id < 4  -- 横向筛选行
ORDER BY first_name  -- 排序

-- 单行注释

/*
多行注释
*/
2. 选择子句
The SELECT Clause (8:48)

小结

SELECT 是列/字段选择语句，可选择列，列间数学表达式，特定值或文本，可用AS关键字设置列别名（AS可省略），注意 DISTINCT 关键字的使用。

注意

SQL会完全无视大小写（绝大数情况下的大小写）、多余的空格（超过一个的空格）、缩进和换行，SQL语句间完全由分号 ; 分割，用缩进、换行等只是为了代码看着更美观结构更清晰，这些与Python很不同，要注意。

实例

USE sql_store;

SELECT
    DISTINCT last_name, 
    -- 这种选择的字段中部分取 DISTINCT 的是如何筛选的？
    first_name,
    points,
    (points + 70) % 100 AS discount_factor/'discount factor'
    -- % 取余（取模）
FROM customers
练习

单价涨价10%作为新单价

SELECT 
    name, 
    unit_price, 
    unit_price * 1.1 'new price'  
FROM products
如上面这个例子所示，取别名时，AS 可省，空格后跟别名就行，可看作是SQL会将将列变量及其数学运算之后的第一个空格识别为AS

3. WHERE子句
The WHERE Clause (5:17)

小结

WHERE 是行筛选条件，实际是一行一行/一条条记录依次验证是否符合条件，进行筛选

导航

3~9 节讲的都是写 WHERE 子句中表达筛选条件的不同方法，这一节（第3节）主要讲比较运算，第4节讲逻辑运算 AND、OR、NOT，5~9可看作都是在讲特殊的比较运算（是否符合某种条件）：IN、BETWEEN、LIKE、REGEXP、IS NULL。

所以总的来说WHERE条件就是数学→比较→逻辑运算，逻辑层次和执行优先级也是按照这三个的顺序来的。

实例

USE sql_store;

SELECT *
FROM customers
WHERE points > 3000  
/WHERE state != 'va'  -- 'VA'/'va'一样
比较运算符 > < = >= <= !=/<> ，注意等于是一个等号而不是两个等号

也可对日期或文本进行比较运算，注意SQL里日期的标准写法及其需要用引号包裹这一点

WHERE birth_date > '1990-01-01'
练习

今年（2019） 的订单

USE sql_store;

select *
from orders
where order_date > '2019-01-01'
-- 有更一般的方法，不用每年改代码，之后教
4. AND, OR, NOT运算符
The AND, OR and NOT Operators (6:52)

小结

用逻辑运算符AND、OR、NOT对（数学和）比较运算进行组合实现多重条件筛选
执行优先级：数学→比较→逻辑

实例

USE sql_store;

SELECT *
FROM customers
WHERE birth_date > '1990-01-01' AND points > 1000
/WHERE birth_date > '1990-01-01' OR 
      points > 1000 AND state = 'VA'
AND优先级高于OR，但最好加括号，更清晰

WHERE birth_date > '1990-01-01' OR 
      (points > 1000 AND state = 'VA')
NOT的用法

WHERE NOT (birth_date > '1990-01-01' OR points > 1000)
去括号等效转化为

WHERE birth_date <= '1990-01-01' AND points <= 1000
练习

订单6中总价大于30的商品

USE sql_store;

SELECT * FROM order_items
WHERE order_id = 6 AND quantity * unit_price > 30
注意优先级：数学→比较→逻辑

SELECT 子句，WHERE 子句以及后面的 ORDER BY 子句等都能用列间数学表达式

5. IN运算符
The IN Operator (3:03)

小结

用IN运算符将某一属性与多个值（一系列值）进行比较
实质是多重相等比较运算条件的简化

案例

选出'va'、'fl'、'ga'三个州的顾客

USE sql_store;

SELECT * FROM customers
WHERE state = 'va' OR state = 'fl' OR state = 'ga'
不能 state = 'va' OR 'fl' OR 'ga' 因为数学和比较运算优先于逻辑运算，加括号 state = ('va' OR 'fl' OR 'ga') 也不行，逻辑运算符只能链接布林值。

用 IN 操作符简化该条件

WHERE state IN ('va', 'fl', 'ga')
可加NOT

WHERE state NOT IN ('va', 'fl', 'ga')
这里可用NOT的原因：可以这么看，IN语句 IN ('va', 'fl', 'ga') 是在进行一种是否符合条件的判断，可看作是一种特殊的比较运算，得到的是一个逻辑值，故可用NOT进行取反

练习

库存量刚好为49、38或72的产品

USE sql_store;

select * from products
where quantity_in_stock in (49, 38, 72)
6. BETWEEN运算符
The BETWEEN Operator (2:12)

小结

用于表达范围型条件

注意

用AND而非括号
闭区间，包含两端点
也可用于日期，毕竟日期本质也是数值，日期也有大小（早晚），可比较运算
同 IN 一样，BETWEEN 本质也是一种特定的 多重比较运算条件 的简化
案例

选出积分在1k到3k的顾客

USE sql_store;

select * from customers
where points >= 1000 and points <= 3000
等效简化为：

WHERE points BETWEEN 1000 AND 3000
注意两端都是包含的 不能写作BETWEEN (1000, 3000)！别和IN的写法搞混

练习

选出90后的顾客

SELECT * FROM customers
WHERE birth_date BETWEEN '1990-01-01' AND '2000-01-01'
7. LIKE运算符
The LIKE Operator (5:37)

小结

模糊查找，查找具有某种模式的字符串的记录/行

注意

过时用法（但有时还是比较好用，之后发现好像用的还是比较多的），下节课的正则表达式更灵活更强大
注意和正则表达式一样都是用引号包裹表示字符串
USE sql_store;
SELECT * FROM customers
WHERE last_name like 'brush%' / 'b____y'
引号内描述想要的字符串模式，注意SQL（几乎）任何情况都是不区分大小写的

两种通配符：

% 任何个数（包括0个）的字符（用的更多）
_ 单个字符
练习

分别选择满足如下条件的顾客：

1. 地址包含 'TRAIL' 或 'AVENUE'

2. 电话号码以 9 结束

USE sql_store;

select * 
from customers
where address like '%Trail%' or 
      address like '%avenue%'
LIKE 执行优先级在逻辑运算符之后，毕竟 IN BETWEEN LIKE 本质可看作是比较运算符的简化，应该和比较运算同级，数学→比较→逻辑，始终记住这个顺序，上面这个如果用正则表达式会简单得多

where phone like '%9'
/where phone not like '%9'
LIKE的判断结果也是个TRUE/FASLE的问题，任何逻辑值/布林值都可前置NOT来取反

8. REGEXP运算符
The REGEXP Operator (9:21)

小结

正则表达式，在搜索字符串方面更为强大，可搜索更复杂的模板

实例

USE sql_store;

select * from customers
where last_name like '%field%'
等效于：

where last_name regexp 'field'
regexp 是 regular expression（正则表达式） 的缩写

正则表达式可以组合来表达更复杂的字符串模式

where last_name regexp '^mac|field$|rose' 
where last_name regexp '[gi]e|e[fmq]' -- 查找含ge/ie或ef/em/eq的
where last_name regexp '[a-h]e|e[c-j]'
一直不太明白位运算和逻辑运算的用法区别？比如 | 和 OR 的区别？感觉意思和用法差不多啊，只是用在的地方不一样，具体各自用在哪里还要学习……

正则表达式总结：

符号	意义
^	开头
$	结尾
[abc]	含abc
[a-c]	含a到c
|	logical or
（正则表达式用法还有更多，自己去查）

练习

分别选择满足如下条件的顾客：

1. first names 是 ELKA 或 AMBUR

2. last names 以 EY 或 ON 结束

3. last names 以 MY 开头 或包含 SE

4. last names 包含 BR 或 BU

select * 
from customers
where first_name regexp 'elka|ambur'
/where last_name regexp 'ey$|on$'
/where last_name regexp '^my|se'
/where last_name regexp 'b[ru]'/'br|bu'
9. IS NULL运算符
The IS NULL Operator (2:26)

小结

找出空值，找出有某些属性缺失的记录

案例

找出电话号码缺失的顾客，也许发个邮件提醒他们之类

USE sql_store;

select * from customers
where phone is null/is not null
注意是 IS NULL 和 IS NOT NULL 这里 NOT 不是前置于布林值，而是更符合英语语法地放在了be动词后

练习

找出还没发货的订单（在线商城管理员的常见查询需求）

USE sql_store;

select * from orders
where shipper_id is null
回顾

3~9 节全在讲WHERE子句中条件的具体写法 :

第3节：比较运算 > < = >= <= !=
第4节：逻辑运算 AND、OR、NOT
5~9节：特殊的比较运算（是否符合某种条件）：IN 和 BETWEEN、LIKE 和 REGEXP、IS NULL
所以总的来说WHERE条件就是

数学运算 → 比较运算（包括特殊的比较运算）→ 逻辑运算
逻辑层次和执行优先级也是按照这三个的顺序来的。

10. ORDER BY子句
The ORDER BY Clause (7:06)

小结

排序语句，和 SELECT …… 很像：

可多列
可以是列间的数学表达式
可包括任何列，包括没选择的列（MySQL特性，其它DBMS可能报错），
可以是之前定义好的别名列（MySQL特性，甚至可以是用一个常数设置的列别名）
任何一个排序依据列后面都可选加 DESC
注意

最好别用 ORDER BY 1, 2（表示以 SELECT …… 选中列中的第1、2列为排序依据） 这种隐性依据，因为SELECT选择的列一变就容易出错，还是显性地写出列名作为排序依据比较好

注：workbench 中扳手图标可打开表格的设计模式，查看或修改表中各列（属性），可以看到谁是主键。省略排序语句的话会默认按主键排序
实例

USE sql_store;

select name, unit_price * 1.1 + 10 as new_price 
from products
order by new_price desc, product_id
-- 这两个分别是 别名列 和 未选择列，都用到了 MySQL 特性
练习

订单2的商品按总价降序排列:

法1. 可以以总价的数学表达式为排序依据

select * from order_items 
where order_id = 2
order by quantity * unit_price desc
-- 列间数学表达式
法2. 或先定义总价别名，在以别名为排序依据

select *, quantity * unit_price as total_price 
from order_items 
where order_id = 2
order by total_price desc
-- 列别名
11. LIMIT子句
The LIMIT Clause (3:26)

小结

限制返回结果的记录数量，“前N个” 或 “跳过M个后的前N个”

实例

USE sql_store;

select * from customers
limit 3 / 300 / 6, 3
6, 3 表示跳过前6个，取第7~9个，6是偏移量，
如：网页分页 每3条记录显示一页 第3页应该显示的记录就是 limit 6, 3

练习

找出积分排名前三的死忠粉

USE sql_store;

select *
from customers
order by points desc 
limit 3
回顾

SELECT 语句完结了，里面的子句顺序固定要记牢，顺序乱会报错
select from where + order by limit
纵选列，确定表，横选行（各种条件写法和组合要清楚熟悉），最后再进行排序和限制
