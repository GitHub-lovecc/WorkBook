【第五章】汇总数据
Summarizing Data (时长33分钟)

汇总统计型查询非常有用，甚至可能常常是你的主要工作内容

1. 聚合函数
Aggregate Functions (9:19)

小结

聚合函数：输入一系列值并聚合为一个结果的函数

实例

USE sql_invoicing;

SELECT 
    MAX(invoice_date) AS latest_date,  
    -- SELECT选择的不仅可以是列，也可以是数字、列间表达式、列的聚合函数
    MIN(invoice_total) lowest,
    AVG(invoice_total) average,
    SUM(invoice_total * 1.1) total,
    COUNT(*) total_records,
    COUNT(invoice_total) number_of_invoices, 
    -- 和上一个相等
    COUNT(payment_date) number_of_payments,  
    -- 【聚合函数会忽略空值】，得到的支付数少于发票数
    COUNT(DISTINCT client_id) number_of_distinct_clients
    -- DISTINCT client_id 筛掉了该列的重复值，再COUNT计数，会得到不同顾客数
FROM invoices
WHERE invoice_date > '2019-07-01'  -- 想只统计下半年的结果
练习

目标：

date_range	total_sales	total_payments	what_we_expect (the difference)
1st_half_of_2019			
2nd_half_of_2019			
Total			
思路：很明显要 分类子查询+聚合函数+UNION

USE sql_invoicing;

    SELECT 
        '1st_half_of_2019' AS date_range,
        SUM(invoice_total) AS total_sales,
        SUM(payment_total) AS total_payments,
        SUM(invoice_total - payment_total) AS what_we_expect
    FROM invoices
    WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'

UNION

    SELECT 
        '2st_half_of_2019' AS date_range,
        SUM(invoice_total) AS total_sales,
        SUM(payment_total) AS total_payments,
        SUM(invoice_total - payment_total) AS what_we_expect
    FROM invoices
    WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'

UNION

    SELECT 
        'Total' AS date_range,
        SUM(invoice_total) AS total_sales,
        SUM(payment_total) AS total_payments,
        SUM(invoice_total - payment_total) AS what_we_expect
    FROM invoices
    WHERE invoice_date BETWEEN '2019-01-01' AND '2019-12-31'
2. GROUP BY子句
The GROUP BY Clause (7:21)

小结

按一列或多列分组，注意语句的位置。

案例1：按一个字段分组

在发票记录表中按不同顾客分组统计下半年总销售额并降序排列

USE sql_invoicing;

SELECT 
    client_id,  
    SUM(invoice_total) AS total_sales
    ……
只有聚合函数是按 client_id 分组时，这里选择 client_id 列才有意义（分组统计语句里SELECT通常都是选择分组依据列+目标统计列的聚合函数，选别的列没意义）。若未分类，结果会是一条总 total_sales 和一条 client_id（该client_id无意义），即 client_id 会被压缩为只显示一条而非 SUM 广播为多条，可以理解为聚合函数比较强势吧。

……
FROM invoices
WHERE invoice_date >= '2019-07-01'  -- 筛选，过滤器
GROUP BY client_id  -- 分组
ORDER BY invoice_total DESC
若省略排序语句就会默认按分组依据排序（后面一个例子发现好像也不一定，所以最好别省略）

记住语句顺序很重要 WHERE GROUP BY ORDER BY，分组语句在排序语句之前，调换顺序会报错

案例2：按多个字段分组

算各州各城市的总销售额

如前所述，一般分组依据字段也正是 SELECT …… 里的选择字段，如下面例子里的 state 和 city

USE sql_invoicing;

SELECT 
    state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices
JOIN clients USING (client_id) 
-- 别忘了USING之后是括号，太容易忘了
GROUP BY state, city  
-- 逗号分隔就行
-- 这个例子里 GROUP BY 里去掉 state 结果一样
ORDER BY state
其实上面的例子里一个城市只能属于一个州中，所有归根结底还是算的各城市的销售额，GROUP BY …… 里去掉 state 只写 city （但 SELECT 和 ORDER BY 里保留 state）结果是完全一样的（包括结果里的 state 列），下面这个例子更能说明以多个字段为分组依据进行分组统计的意义

练习

在 payments 表中，按日期和支付方式分组统计总付款额

每个分组显示一个日期和支付方式的独立组合，可以看到某特定日期特定支付方式的总付款额。这个例子里每一种支付方式可以在不同日子里出现，每一天也可以出现多种支付方式，这种情况，才叫真·多字段分组。不过上一个例子里那种假·多字段分组，把 state 加在分组依据里也没坏处还能落个心安，也还是加上别省比较好

USE sql_invoicing;

SELECT 
    date, 
    pm.name AS payment_method,
    SUM(amount) AS total_payments
FROM payments p
JOIN payment_methods pm
    ON p.payment_method = pm.payment_method_id
GROUP BY date, payment_method
-- 用的是 SELECT 里的列别名
ORDER BY date
思想

解答复杂问题时，学会先分解拆分为简单的小问题或小步骤逐个击破。合理运用分解组合和IPO（input-process-output 输入-过程-输出）思想。

3. HAVING子句
The HAVING Clause (8:50)

小结

HAVING 和 WHERE 都是是条件筛选语句，条件的写法相通，数学、比较（包括特殊比较）、逻辑运算都可以用（如 AND、REGEXP 等等）

两者本质区别:

WHERE 是对 FROM JOIN 里原表中的列进行 事前筛选，所以WHERE可以对没选择的列进行筛选，但必须用原表列名而不能用SELECT中确定的列别名
相反 HAVING …… 对 SELECT …… 查询后（通常是分组并聚合查询后）的结果列进行 事后筛选，若SELECT里起了别名的字段则必须用别名进行筛选，且不能对SELECT里未选择的字段进行筛选。唯一特殊情况是，当HAVING筛选的是聚合函数时，该聚合函数可以不在SELECT里显性出现，见最后补充
案例

筛选出总发票金额大于500且总发票数量大于5的顾客

USE sql_invoicing;

SELECT 
    client_id,
    SUM(invoice_total) AS total_sales,
    COUNT(*/invoice_total/invoice_date) AS number_of_invoices
FROM invoices
GROUP BY client_id
HAVING total_sales > 500 AND number_of_invoices > 5
-- 均为 SELECT 里的列别名
若写：WHERE total_sales > 500 AND number_of_invoices > 5，会报错：Error Code: 1054. Unknown column 'total_sales' in 'where clause'

练习

在 sql_store 数据库（有顾客表、订单表、订单项目表等）中，找出在 'VA' 州且消费总额超过100美元的顾客（这是一个面试级的问题，还很常见）

思路：
1. 需要的信息在顾客表、订单表、订单项目表三张表中，先将三张表合并
2. WHERE 事前筛选 'VA' 州的
3. 按顾客分组，并选取所需的列并聚合得到每位顾客的付款总额
4. HAVING 事后筛选超过 100美元 的

USE sql_store;

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.unit_price) AS total_sales
FROM customers c
JOIN orders o USING (customer_id)  -- 别忘了括号，特容易忘
JOIN order_items oi USING (order_id)
WHERE state = 'VA'
GROUP BY 
    c.customer_id, 
    c.first_name, 
    c.last_name
HAVING total_sales > 100
补充

学第六章第6节时发现，当 HAVING 筛选的是聚合函数时，该聚合函数可以不在SELECT里显性出现。（作为一种需要记住的特殊情况）如：下面这两种写法都能筛选出总点数大于3k的州，如果不要求显示总点数，应该用后一种

SELECT state, SUM(points)
FROM customers
GROUP BY state
HAVING SUM(points) > 3000

或

SELECT state
FROM customers
GROUP BY state
HAVING SUM(points) > 3000
4. ROLLUP运算符
The ROLLUP Operator (5:05)

GROUP BY …… WITH ROLL UP 自动汇总型分组，若是多字段分组的话汇总也会是多层次的，注意这是MySQL扩展语法，不是SQL标准语法

案例

分组查询各客户的发票总额以及所有人的总发票额

USE sql_invoicing;

SELECT 
    client_id,
    SUM(invoice_total)
FROM invoices
GROUP BY client_id WITH ROLLUP
多字段分组 例1：分组查询各州、市的总销售额（发票总额）以及州层次和全国层次的两个层次的汇总额

SELECT 
    state,
    city,
    SUM(invoice_total) AS total_sales
FROM invoices
JOIN clients USING (client_id) 
GROUP BY state, city WITH ROLLUP
多字段分组 例2：分组查询特定日期特定付款方式的总支付额以及单日汇总和整体汇总

USE sql_invoicing;

SELECT 
    date, 
    pm.name AS payment_method,
    SUM(amount) AS total_payments
FROM payments p
JOIN payment_methods pm
    ON p.payment_method = pm.payment_method_id
GROUP BY date, pm.name WITH ROLLUP
练习

分组计算各个付款方式的总付款 并汇总

SELECT 
    pm.name AS payment_method,
    SUM(amount) AS total
FROM payments p
JOIN payment_methods pm
    ON p.payment_method = pm.payment_method_id
GROUP BY pm.name WITH ROLLUP
★总结

根据之后三篇参考文章，据说标准的 SQL 查询语句的执行顺序应该是下面这样的：

1. FROM JOIN 选择和连接本次查询所需的表
2. ON/USING WHERE 按条件筛选行
3. GROUP BY 分组
4. HAVING （事后/分组后）筛选行
5. SELECT 筛选列
注意1：若进行了分组，这一步常常要聚合）
注意2：SELECT 和 HAVING 在 MySQL 里的执行顺序我还有点疑问，见后面的叙述
6. DISTINCT 去重
7. UNION 纵向合并
8. ORDER BY 排序
9. LIMIT 限制

"SELECT 是在大部分语句执行了之后才执行的，严格的说是在 FROM、WHERE 和 GROUP BY （以及 HAVING）之后执行的。理解这一点是非常重要的，这就是你不能在 WHERE 中使用在 SELECT 中设定别名的字段作为判断条件的原因。"

这个顺序可以由下面这个例子的缩进表现出来（出右往左）（注意 DISTINCT 放不进去了只有以注释的形式展示出来，另外 SELECT 还是选择放在了 HAVING 之前）

                    SELECT name, SUM(invoice_total) AS total_sales
         -- DISTINCT
                                FROM invoices JOIN clients USING (client_id) 
                            WHERE due_date < '2019-07-01'
                        GROUP BY name  
                HAVING total_sales > 150

        UNION

                    SELECT name, SUM(invoice_total) AS total_sales
         -- DISTINCT
                                FROM invoices JOIN clients USING (client_id) 
                            WHERE due_date > '2019-07-01'
                        GROUP BY name  
                HAVING total_sales > 150

    ORDER BY total_sales
LIMIT 2
关于 SELECT 的位置

如后面几篇参考文章所说，按标准 SQL 的执行顺序， SELECT 是在 HAVING 之后
但根据前面的内容，似乎在 MySQL 里，SELECT 的执行顺序是在 WHERE GROUP BY 之后，而在 HAVING 之前 —— 因而 WHERE GROUP BY 要用原列名（后来发现只有 WHERE 里必须用原列名，GROUP BY 是原列名或列别名都可用（甚至可以用1，2来指代 SELECT 中的列，不过 Mosh 不建议这样做））而 HAVING 必须用 SELECT 里的列别名（聚合函数除外）
按实践经验来看，就按 2 来记忆和理解是可行的，但之后最好还是要去看书看资料把这个执行顺序的疑惑彻底搞清楚，这个还挺重要的。

参考文章1："十步完全理解 SQL"

主要看文中的第2点：SQL 的语法并不按照语法顺序执行，但注意文中只说了标准的SQL执行顺序，MySQL的执行顺序可能有所不同

参考文章2：SQL语句优化--执行顺序

参考文章3：查询执行顺序
