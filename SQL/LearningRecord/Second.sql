USE sql_store;

SELECT * / 1, 2  -- 纵向筛选列，甚至可以是常数，可用AS关键字设置列别名（AS可省略），注意 DISTINCT 关键字的使用。
FROM customers  -- 选择表
WHERE customer_id < 4  -- 横向筛选行
ORDER BY first_name  -- 排序

-- 单行注释

/*
多行注释
*/
