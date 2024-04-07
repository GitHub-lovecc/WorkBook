https://zhuanlan.zhihu.com/p/222932740

USE sql_store;

SELECT * / 1, 2  -- 纵向筛选列，甚至可以是常数，可用AS关键字设置列别名（AS可省略），注意 DISTINCT 关键字的使用。
FROM customers  -- 选择表
WHERE customer_id < 4  -- 横向筛选行
ORDER BY first_name  -- 排序

-- 单行注释

/*
多行注释

SQL会完全无视大小写（绝大数情况下的大小写）、
多余的空格（超过一个的空格）、缩进和换行，SQL语句间完全由分号 ; 
分割，用缩进、换行等只是为了代码看着更美观结构更清晰，这些与Python很不同，要注意。
*/


USE sql_store;

SELECT
    DISTINCT last_name, 
    -- 这种选择的字段中部分取 DISTINCT 的是如何筛选的？
    first_name,
    points,
    (points + 70) % 100 AS discount_factor/'discount factor'
    -- % 取余（取模）
FROM customers

SELECT 
    name, 
    unit_price, 
    unit_price * 1.1 'new price'  
FROM products

USE sql_store;

SELECT *
FROM customers
WHERE points > 3000  
/WHERE state != 'va'  -- 'VA'/'va'一样
