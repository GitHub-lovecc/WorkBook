【十四章】高效的索引
Indexing for High Performance (时长58分钟)

1. 介绍
Introduction (0:41)

这一章我们来看提高性能的索引，索引对大型和高并发数据库非常有用，因为它可以显著提升查询的速度

这一章我们将学习关于索引的一切，它们是如何工作的，以及我们如何创造索引来提升查询速度，学习和理解这一章对于程序员和数据库管理员十分重要

准备

打开 load_1000_customers.sql 并运行，该文件会向 sql_store 库的 customers 表插入上千条记录，这样我们就能看出索引对查询效率的影响

2. 索引
Indexes (2:49)

原理和作用

以寻找所在州（state）为 'CA' 的顾客为例，如果没索引，MySQL 就必须扫描筛选所有记录。索引，就好比书籍最后的那些关键词索引一样，按字母排序，这样就能按字母迅速找到需要的关键词所在的页数，类似的，对 state 字段建立索引时，其实就是把 state 列单独拿出来分类排序并建立与原表顾客记录的对应关系，然后就可以通过该索引迅速找到所在州为 'CA' 的顾客

另一方面，索引会比原表小得多，通常能够储存在内存中，而从内存读取数据总是比从硬盘读取快多了，这也会提升查询速度

如果数据量比较小，几百几千这种，没必要用索引，但如果是上百万的数据量，有无索引对查询效率的影响就很大了

注意

但建立索引也是有代价的，首先索引会占用内存，其次它会降低写入速度，因为每次修改数据时都会自动重建索引。所以不要对整个表建立索引，而只是针对关键的查询建立索引。

简化

严格来讲，应该用二叉树来描述索引，但只是为了学习如何操作索引的话没必要理解二叉树，所以这节课简化为用表格来展示索引以降低理解难度

导航

下节课我们学习如何创建索引

3. 创建索引
Creating Indexes (5:00)

案例

接着上面的例子，假设查询 'CA' 的顾客，为了查看查询操作的详细信息，前面加上 EXPLAIN 关键字

注意这里只选择 customer_id 是有原因的，之后会解释

EXPLAIN SELECT customer_id 
FROM customers WHERE state = 'CA';
得到很多信息，目前我们只关注 type 和 rows

type 是 ALL 而 rows 是 1010 行，说明在没有索引的情况下，MySQL扫描了所有的记录。可用下面的语句确认customers表总共就是1010条记录

SELECT COUNT(*) FROM customers;
-- 1010
现在创建索引，索引名习惯以idx或ix做前缀，后面的名字最好有意义，不要别取 idx_1、idx_2 这种没人知道是什么意思的名字

CREATE INDEX idx_state ON customers (state);
再次运行加上 EXPLAIN 的解释性查询语句

EXPLAIN SELECT customer_id FROM customers WHERE state = 'CA';
这次显示 type 是 ref 而 rows 只有 112，扫描的行数显著减少，查询效率极大提升。

另外，注意 possible keys 和 key 代表了 MySQL 找到的执行此查询可用的索引（之后会看到，可能不止一个）以及最终实际选择的最优的索引

练习

解释性查询积分过千的顾客id，建立索引后再来一次并对比两次结果

EXPLAIN SELECT customer_id 
FROM customers WHERE points > 1000;

CREATE INDEX idx_points ON customers (points);

EXPLAIN SELECT customer_id 
FROM customers WHERE points > 1000;
建立索引后的查询 type 为 range，表明我们查询的是一个取值范围的记录，扫描的行数 rows 从 1010 降为了 529，减了一半左右

导航

下节课学习如何查看索引

小结

解释性查询是在查询语句前加上 EXPLAIN

创建索引的语法：

CREATE INDEX 索引名（通常是 idx_列名） ON 表名 (列名);
4. 查看索引
Viewing Indexes (3:19)

实例1

查看 customers 表的索引：

SHOW INDEXES IN customers;
-- SHOW INDEXES IN 表名
可以看到有三个索引，第一个是 MySQL 为主键 customer_id 创建的索引 PRIMARY，被称作clustered index 聚合索引，每当我们为表创建主键时，MySQL 就会自动为其创建索引，这样就能快速通过主键（通常是某id）找到记录。后两个是我们之前手动为 state 和 points 字段建立的索引 idx_state 和 idx_points，它们是 secondary index 从属索引，MySQL 在创建从属索引时会自动为其添加主键列，如每个 idx_points 索引的记录有两个值：客户的积分points 和对应的客户编号 customer_id，这样就可以通过客户积分快速找到对应的客户记录

索引查询表中还列示了索引的一些性质，其中：

Non_unique 是否是非唯一的，即是否是可重复的、可相同的，一般主键索引是0，其它是1
Column_name 表明索引建立在什么字段上
Collation 是索引内数据的排序方式，其中A是升序，B是降序
Cardinality（基数）表明索引中独特值/不同值的数量，如 PRIMARY 的基数就是 1010，毕竟每条记录都都有独特的主键，而另两个索引的基数都要少一些，从之前 Non_unique 为 1 也可以看得出来 state 和 points 有重复值，这里的基数可以更明确看到 state 和 points 具体有多少种不同的值
Index_type 都是BTREE（二叉树），之前说过MySQL里大部分的索引都是以二叉树的形式储存的，但 Mosh 把它们表格化了以使其更清晰易懂
注意

Cardinality 这里只是近似值而非精确值，要先用以下语句重建顾客表的统计数据：

ANALYZE TABLE customers;
然后再用 SHOW INDEXES IN customers; 得到的才是精确的 Cardinality 基数

实例2

查看orders表的索引

SHOW INDEXES IN orders;
总共有四个： PRIMARY、fk_orders_customers_idx、fk_orders_shippers_idx、fk_orders_order_statuses_idx，第一个是建立在主键order_id上的聚合索引，后三个是建立在三个外键 customer_id、shipper_id、status 上的从属索引。

当我们建立表间链接时，MySQL会自动为外键添加索引，这样就能快速就行表连接（join tables）了

另外

还可以通过菜单方式查看某表中的索引，在左侧导航栏里 customers 表的子文件里就有一个 indexes 文件夹，点击里面的索引可以看到该索引的若干属性，其中 visible（可见性） 表示其是否可用（enabeled）

导航

下节课看如何对字符串列创建索引

5. 前缀索引
Prefix Indexes (3:40)

当索引的列是字符串时（包括 CHAR、VARCHAR、TEXT、BLOG），尤其是当字符串较长时，我们通常不会使用整个字符串而是只是用字符串的前面几个字符来建立索引，这被称作 Prefix Indexes 前缀索引，这样可以减少索引的大小使其更容易在内存中操作，毕竟在内存中操作数据比在硬盘中快很多

案例

为 customers 表的 last_name 建立索引并且只使用其前20个字符：

CREATE INDEX idx_lastname ON customers (last_name(20));
这个字符数的设定对于 CHAR 和 VARCHAR 是可选的，但对于 TEXT 和 BLOG 是必须的

最佳字符数

可最佳字符数如何确定呢？太多了会使得索引太大难以在内存中运行，太少又达不到筛选的效果，比如，只用第一个字符建立索引，那如果查找A开头的名字，索引可能会返回10万个结果，然后就必须对这10万个结果逐条筛选。

可以利用 COUNT、DISTINCT、LEFT 关键词和函数来测试不同数目的前缀字符得到的独特值个数，目标是用尽可能少的前缀字符得到尽可能多的独特值个数：

SELECT 
    COUNT(DISTINCT LEFT(last_name, 1)),
    COUNT(DISTINCT LEFT(last_name, 5)),
    COUNT(DISTINCT LEFT(last_name, 10))
FROM customers
结果是 '25', '966', '996'

可见从前1个到前5个字符，效果提升是很显著的，但从前5个到前10个字符，所用的字符数增加了一倍但识别效果只增加了一点点，再加上5个字符已经能识别出966个独特值，与1010的记录总数相去不远了，所以可以认为用前5个字符来创建前缀索引是最优的

导航

下节课学习一个很特殊又很强大的索引，全文索引

6. 全文索引
Fulltext Indexes (7:50)

这节课学习如何建立全文索引以支持全文检索的需求

案例

运行 create-db-blog.sql 得到 sql_blog 数据库，里面只包含一个 posts 表（文章表），每条记录就是一篇文章的编号 post_id、标题 title、内容 body 和 发布日期 data_published

假设我们创建了一个博客网站，里面有一些文章，并存放在上面这个 sql_blog 数据库里，如何让用户可以对博客文章进行搜索呢？

假设，用户想搜索包含 react 及 redux（两个有关前端的重要的 javascript 库）的文章，如果用 LIKE 操作符进行筛选：

USE sql_blog;
SELECT *
FROM posts
WHERE title LIKE '%react redux%'
    OR body LIKE '%react redux%';
有两个问题：

在没有索引的情况下，会对所有文本进行全面扫描，效率低下。如果用上节课讲的前缀索引也不行，因为前缀索引只包含标题或内容开头的若干字符，若搜索的内容不在开头，以依然需要全面扫描
这种搜索方式只会返回完全符合 '%react redux%' 的结果，但我们一般搜索时，是希望得到包含这两个单词的任意一个或两个，任意顺序，中间有任意间隔的所有相关结果，即 google 式的模糊搜索
我们通过建立 Fulltext Index 全文索引 来实现这样的搜索

全文索引对相应字符串列的所有字符串建立索引，它就像一个字典，它会剔除掉in、the这样无意义的词汇并记录其他所有出现过的词汇以及每一个词汇出现过的一系列位置

建立全文索引：

CREATE FULLTEXT INDEX idx_title_body ON posts (title, body);
利用全文索引，结合 MATCH 和 AGAINST 进行 google 式的模糊搜索:

SELECT *
FROM posts
WHERE MATCH(title, body) AGAINST('react redux');
注意MATCH后的括号里必须包含全文索引 idx_title_body 建立时相关的所有列，不然会报错

还可以把 MATCH(title, body) AGAINST('react redux') 包含在选择语句里， 这样还能看到各结果的 relevance score 相关性得分（一个 0 到 1 的浮点数），可以看出结果是按相关行降序排列的

SELECT *, MATCH(title, body) AGAINST('react redux')
FROM posts
WHERE MATCH(title, body) AGAINST('react redux');
全文检索有两个模式：自然语言模式和布林模式，自然语言模式是默认模式，也是上面用到的模式。布林模式可以更明确地选择包含或排除一些词汇（google也有类似功能），如：

尽量有 react，不要有 redux，必须有 form
……
WHERE MATCH(title, body) AGAINST('react -redux +form' IN BOOLEAN MODE);
2. 布林模式也可以实现精确搜索，就是将需要精确搜索的内容再用双引号包起来

……
WHERE MATCH(title, body) AGAINST('"handling a form"' IN BOOLEAN MODE);
小结

全文索引十分强大，如果你要建一个搜索引擎可以使用它，特别是要搜索的是长文本时，如文章、博客、说明和描述，否则，如果搜索比较短的字符串，比如名字或地址，就使用前置字符串

导航

接下来我们来看组合索引

7. 组合索引
Composite Indexes (5:12)

案例

查看 customers 表中的索引：

USE sql_store;
SHOW INDEXES IN customers;
目前有 PRIMARY、idx_state、idx_points 三个索引

之前只是对 state 或 points 单独进行筛选查询，现在我们要用 AND 同时对两个字段进行筛选查询，例如，查询所在州为 'CA' 而且积分大于 1000 的顾客id：

EXPLAIN SELECT customer_id
FROM customers
WHERE state = 'CA' AND points > 1000;
会发现 MySQL 在 idx_state、idx_points 两个候选索引最终选择了 idx_state，总共扫描了 112 行记录

相对于无索引时要扫描所有的 1010 条记录，这要快很多，但问题是，idx_state 这种单字段的索引只做了一半的工作：它能帮助快速找到在 'CA' 的顾客，但要寻找其中积分大于1000的人时，却不得不到磁盘里进行原表扫描（因为 idx_state 索引里并没有积分信息），如果加州有一百万人的话这就会变得很慢。

所以我们要建立 state 和 points 的组合索引：（两者的顺序其实很重要，下节课讲）

CREATE INDEX idx_state_points ON customers (state, points);
再次运行之前的查询，发现在 idx_state、idx_points、idx_state_points 三个候选索引中 MySQL 发现组合索引 idx_state_points 对我们要做的查询而言是最优的因而选择了它，最终扫描的行数由 112 降到了 58，速度确实提高了

之后会看到组合索引也能提高排序的效率

我们可以用 DROP 关键字删除掉那两个单列的索引

DROP INDEX idx_state ON customers;
DROP INDEX idx_points ON customers;
注意

新手爱犯的错误是给表里每一列都建立一个单独的索引，再加上 MySQL 会给每个索引自动加上主键，这些过多的索引会占用大量储存空间，而且数据每次数据更新都会重建索引，所以过多的索引也会拖慢更新速度

但实际中更多的是用到组合索引，所以不应该无脑地为每一列建立单独的索引而应该依据查询需求来建立合适的组合索引，一个组合索引最多可组合 16 列，但一般 4 到 6 列的组合索引是比较合适的，但别把这个数字当作金科玉律，总是根据实际的查询需求和数据量来考虑

导航

下节课讲组合索引的顺序问题

8. 组合索引的列顺序
Order of Columns in Composite Indexes (9:16)

组合索引的原理

对于组合索引，一定要从原理上去理解，比如 idx_state_lastname， 它是先对 state 建立分类排序的索引，然后再在同一州（如 'CA'）内建立 lastname 的分类排序索引，所以这个索引对两类查询有效：

1. 单独针对 state 的查询（快速找到州）

2. 同时针对 state 和 lastname 的查询（快速找到州再在该州内快速找到该姓氏）

但 idx_state_lastname 对单独针对 lastname 的查询无效，因为它必须在每个州里去找该姓氏，相当于全面扫描了。所以如果单独查找某州的需求存在的话，就还需要另外为其单独建一个索引 idx_state

基于对以上原理的理解，我们在确定组合索引的列顺序时有两个指导原则：

将最常使用的列放在前面
在建立组合索引时应该将最常用的列放在最前面，这样的索引会对更多的查询有效

（？其实没懂为什么要放在最前面？感觉优先包含最常用的列就行了，不一定要在最前面，下一条把独特性最高的列放在最前面以迅速缩小范围倒是很好理解）

2. 将基数（Cardinality）最大/独特性最高的列放在前面

因为基数越大/独特性越高，起到的筛选作用越明显，能够迅速缩小查询范围。比如如果首先以性别来筛选，那只能将选择范围缩小到一半左右，但如果先以所在州来筛选，以总共 20 个州且每个州人数相当为例，那就会迅速将选择范围缩小到 1/20

但最终仍然要根据实际的查询需求来决定，因为实际查询的筛选条件不一定能完全利用相应列的全部独特性，举例说明如下：

首先，为了比较的目的，针对 state 和 last_name 两列，同时建立两种顺序的索引 idx_state_lastname 和 idx_lastname_state

last_name 的独特性肯定是比 state 的独特性高的，可以用以下语句验证：

SELECT 
    COUNT(DISTINCT state),
    COUNT(DISTINCT last_name)
FROM customers;
-- 48, 996
所以如果查询语句的筛选条件为 WHERE state = 'CA' AND last_name = 'Smith'，这种目标是特定州和特定姓氏的的查询能够充分利用各列独特性，肯定用 idx_lastname_state 先筛选姓氏能更快缩小范围提高效率

但如果进行姓氏的模糊查询，如，要查询 在加州 且 姓氏以A开头 的顾客，我们可以用 USE INDEX （索引名） 子句来强制选择使用的索引，对两种索引的查询结果进行对比：

EXPLAIN SELECT customer_id
FROM customers
USE INDEX (idx_state_lastname)
-- 注意括号
-- 注意位置：FROM之后WHERE之前
WHERE state = 'CA' AND last_name LIKE 'A%';
-- 7 rows

EXPLAIN SELECT customer_id
FROM customers
USE INDEX (idx_lastname_state)
WHERE state = 'CA' AND last_name LIKE 'A%';
-- 40 rows
会发现 idx_state_lastname 反而扫描的行数更少，效率更高，把查找的 state 换为 'NY' 也是一样。这是因为 last_name 的筛选条件是 'LIKE' 而不是 '='，约束性更小（less restrictive），更开放（more open），并没有充分利用姓氏列的高独特性，对于这种针对姓氏的模糊查找，先筛选州反而能更快缩小范围提高效率，所以 idx_state_lastname 更有效

当然，如果对两列都进行模糊查询，如查询语句的筛选条件变为 WHERE state LIKE 'A%' AND last_name LIKE 'A%'，可以想得到，验证也能证实，idx_lastname_state 会重新胜出

总之，不仅要考虑各列的独特性高低，也要考虑常用的查询是否能充分利用各列的独特性，两者结合来决定组合索引里的排序，不确定就测试对比验证，所以，第二条原则也许应该改为将常用查询实际利用到的独特性程度最高的列放在前面

以上面的例子来说，如果业务中常用查询是特定州和特定姓（很可能）或者模糊州和模糊姓（不太可能），就用 idx_lastname_state 而 舍弃 idx_state_lastname（不十分必要的索引不要保留，浪费空间和拖慢更新），相反，如果常用查询是特定州和模糊姓，就用 idx_state_lastname 而舍 idx_lastname_state

假设后一种情况成立，即只保留 idx_state_lastname，还要注意一点是，如前所述， idx_state_lastname 对 单独针对 last_name 的查询无效，如果有这样的查询需要就还要另外为该列建一个可用的索引 idx_state

思想

总之，任何一个索引都只对一类查询有效而且对特定的查询内容最高效，我们要现实一些，要去最优化那些性能关键查询，而不是所有可能的查询（optimize performance critical queries, not all queries in the world）

能加速所有查询的索引是不存在的，随着数据库以及查询需求的增长和扩展，我们可能需要建立不同列的不同顺序的组合索引

9. 索引无效时
When Indexes are Ignored (5:03)

有时你有一个可用的索引，但你的查询却未能充分利用它，这里我们看两种常见的情形：

案例1

查找在加州或积分大于1000的顾客id

注意之前查询的筛选条件都是与（AND），这里是或（OR）

USE sql_store;
EXPLAIN SELECT customer_id FROM customers
WHERE state = 'CA' OR points > 1000;
发现虽然显示 type 是 index，用的索引是 idx_state_points，但扫描的行数却是 1010 rows

因为这里是 或（OR） 查询，在找到加州的顾客后，仍然需要在每个州里去找积分大于 1000 的顾客，所以要扫描所有的 1010 条索引记录，即进行了 全索引扫描（full index scan）。当然全索引扫描比全表扫描要快一点，因为前者只有三列而后者有很多列，前者在内存里进行而后者在硬盘里进行，但 全索引扫描 依然说明索引未被有效利用，如果是百万条记录还是会很慢

我们需要以尽可能充分利用索引地方式来编写查询，或者说以最迎合索引的方式编写查询，就这个例子而言，可另建一个 idx_points 并将这个 OR 查询改写为两部分，分别用各自最合适的索引，再用 UNION 融合结果（注意 UNION 是自动去重的，所以起到了和 OR 相同的作用，如果要保留重复记录就要用 UNION ALL，这里显然不是）

CREATE INDEX idx_points ON customers (points);

EXPLAIN

        SELECT customer_id FROM customers
        WHERE state = 'CA'

    UNION

        SELECT customer_id FROM customers
        WHERE points > 1000;
结果显示，两部分查询中，MySQL 分别自动选用了对该查询最有效的索引 idx_state_points 和 idx_points，扫描的行数分别为 112 和 529，总共 641 行，相比于 1010 行有很大的提升

案例2

查询目前积分增加 10 分后超过 2000 分的顾客id:

EXPLAIN SELECT customer_id FROM customers
WHERE points + 10 > 2010;
-- key: idx_points
-- rows: 1010
又变成了 1010 行全索引扫描，因为 column expression 列表达式（列运算） 不能最有效地使用索引，要重写运算表达式，独立/分离此列（isolate the column）

EXPLAIN SELECT customer_id FROM customers
WHERE points > 2000;
-- key: idx_points
-- rows: 4
直接从1010行降为4行，效率提升显著。所以想要 MySQL 有效利用索引，就总是在表达式中将列独立出来

导航

下节课讲用索引排序

10. 使用索引排序
Using Indexes for Sorting (7:02)

之前创建的索引杂七杂八的太多了，只保留 idx_lastname, idx_state_points 两个索引，把其他的 drop 了

USE sql_store;
SHOW INDEXES IN customers;
DROP INDEX idx_points ON customers;
DROP INDEX idx_state_lastname ON customers;
DROP INDEX idx_lastname_state ON customers;
SHOW INDEXES IN customers;
可以用 SHOW STATUS; 来查看Mysql服务器使用的众多变量，其中有个叫 'last_query_cost' 是上次查询的消耗值，我们可以用 LIKE 关键字来筛选该变量，即： SHOW STATUS LIKE 'last_query_cost';

按 state 给 customer_id 排序（下节课讲为什么是 customer_id），再按 first_name 给 customer_id 排序，对比：

EXPLAIN SELECT customer_id 
FROM customers
ORDER BY state;
-- type: index, rows: 1010, Extra: Using index
SHOW STATUS LIKE 'last_query_cost';  
-- cost: 102.749

EXPLAIN SELECT customer_id 
FROM customers
ORDER BY first_name;
-- type: ALL, rows: 1010, Extra: Using filesort 
SHOW STATUS LIKE 'last_query_cost';  
-- cost: 1112.749
注意查看 Extra 信息，非索引列排序常常用的是 filesort 算法，从 cost 可以看到 filesort 消耗的资源几乎是用索引排序的 10 倍，这很好理解，因为索引就是对字段进行分类和排序，等于是已经提前排好序了

所以，不到万不得已不要给非索引数据排序，有可能的话尽量设计好索引用于查询和排序

但如之前所说，特定的索引只对特定的查询（WHERE 筛选条件）和排序（ORDER BY 排序条件）有效，这还是要从原理上理解：

以 idx_state_points 为例，它等于是先对 state 分类排序，再在同一个 state 内对 points 进行分类排序，再加上 customer_id 映射到相应的原表记录
所以，索引 idx_state_points 对于以下排序有效：

ORDER BY state
ORDER BY state, points
ORDER BY points WHERE state = 'CA'
/* 第3个是 “对加州范围内的顾客按积分排序”，
为何有效，从原理上也是很好理解的 */
相反，idx_state_points 对以下索引无效或只是部分有效，这些都是会部分或全部用到 filesort 算法的：

ORDER BY points
ORDER BY points, state
ORDER BY state, first_name, points
总的来说一个组合索引对于按它的组合列 “从头开始并按顺序” 的 WHERE 和 ORDER BY 子句最有效

对于 ORDER BY 子句还有一个问题是升降序，索引本身是升序的，但可以 Backward index scan 倒序索引扫描，所以它对所有同向的（同升序或同降序）的 ORDER BY 子句都有效，但对于升降序混合方向的 ORDER BY 语句则不够有效，还是以 idx_state_points 为例，对以下 ORDER BY 子句有效，即完全是 Using index 且 cost 在一两百左右：

ORDER BY state 
ORDER BY state DESC
ORDER BY state, points
ORDER BY state DESC, points DESC
但下面这两种就不能充分利用 idx_state_points，会部分使用 filesort 算法且 cost > 1000

ORDER BY state, points DESC
ORDER BY state DESC, points
总结

特定索引只对特定查询和排序最有效，而且这些从索引的原理上都很好理解

建立什么索引取决于查询和排序需求，而查询和排序也要尽量去迎合索引以尽可能提高效率

11. 覆盖索引
Covering Indexes (1:58)

这节课讲为什么之前 SELECT 选择子句里只选 customer_id 这一个字段

实例

以 state 排序查询 customers 表，每次 SELECT 不同的列并对比结果：

USE sql_store;

-- 1. 只选择 customer_id:
EXPLAIN SELECT customer_id FROM customers
ORDER BY state;
SHOW STATUS LIKE 'last_query_cost';

-- 2. 选择 customer_id 和 state:
EXPLAIN SELECT customer_id, state FROM customers
ORDER BY state;
SHOW STATUS LIKE 'last_query_cost';

-- 3. 选择所有字段:
EXPLAIN SELECT * FROM customers
ORDER BY state;
SHOW STATUS LIKE 'last_query_cost';
会验证发现前两次是完全 Using index 而且 cost 均只有两百左右，而第3种是 Using filesort 而且 cost 超过一千，这从 idx_state_points 的原理上也很好理解：

前面提到过，从属索引除了包含相关列还会自动包含主键列（通常是某种id列）来和原表中的记录建立对应关系，所以 组合索引 idx_state_points 中包含三列：state、points 以及 customer_id，所以如果 SELECT 子句里选择的列是这三列中的一列或几列的话，整个查询就可以在只使用索引不碰原表的情况下完成，这叫作覆盖索引（covering index），即索引满足了查询的所有需求所以全程不需要使用原表，这是最快的

总结

设计索引时，先看 WHERE 子句，看看最常用的筛选字段是什么，把它们包含在索引中，这样就能迅速缩小查找范围，其次查看 ORDER BY 子句，看看能不能将这些列包含在索引中，最后，看看 SELECT 子句中的列，如果你连这些也包含了，就得到了覆盖索引，MySQL 就能只用索引就完成你的查询，实现最快的查询速度

12. 维护索引
Index Maintenance (1:25)

索引维护注意三点：

重复索引（duplicate index）：
MySQL 不会阻止你建立重复的索引，所以记得在建立新索引前前检查一下已有索引。验证后发现，具体而言：

同名索引是不被允许的：

CREATE INDEX idx_state_points ON customers (state, points);
-- Error Code: 1061. Duplicate key name 'idx_state_points'
对相同列的相同顺序建立不同名的索引，5.7 版本暂时允许，但 8.0 版本不被允许：

CREATE INDEX idx_state_points2 ON customers (state, points);
/* warning(s): 1831 Duplicate index 'idx_state_points2' 
defined on the table 'sql_store.customers'. 
This is deprecated (不赞成；弃用；不宜用) 
and will be disallowed in a future release. */
2. 冗余索引（redundant index）：

比如，已有 idx_state_points，那 idx_state 就是冗余的了，因为所有 idx_state 能满足的筛选和排序需求 idx_state_points 都能满足

但当已有 idx_state_points 时，idx_points 和 idx_points_state 并不是冗余的，因为它们可以满足不同的筛选和排序需求

3. 无用索引（unused index）:

这个很好理解，就是那些常用查询、排序用不到的索引没必要建立，毕竟索引是会占用空间和拖慢数据更新速度的

所以一再强调 考虑实际需求 的重要性

小结

要做好索引管理：

在新建索引时，总是先查看一下现有索引，避免重复、冗余、无用的索引，这是最基本的要求。
其次，索引本身要是要占用空间和拖慢更新速度的所以也是有代价的，而且不同索引对不同的筛选、排序、查询内容的有效性不同，因此，理想状态下，索引管理也应该是个根据业务查询需求需要不断去权衡成本效益，抓大放小，迭代优化的过程
13. 性能最佳实践 (文档)
Performance Best Practices

课程资料中有一个 Performance Best Practices.pdf 文件，总结了课程中提到过的性能最佳实践，翻译如下：

较小的表性能更好。不要存储不需要的数据。解决今天的问题，而不是明天可能永远不会发生的问题。
使用尽可能小的数据类型。如果你需要存储人们的年龄，一个TINYINT就足够了，无需使用INT。对于一个小的表来说，节省几个字节没什么大不了的，但在包含数百万条记录的表中却具有显著的影响。
每个表都必须有一个主键。
主键应短。如果您只需要存储一百条记录，最好选择 TINYINT 而不是 INT。
首选数字类型而不是字符串作为主键。这使得通过主键查找记录更快。
避免BLOB。它们会增加数据库的大小，并会对性能产生负面影响。如果可以，请将文件存储在磁盘上。
如果表的列太多，请考虑使用一对一关系将其拆分为两个相关表。这称为垂直分区（vertical partitioning）。例如，您可能有一个包含地址列的客户表。如果这些地址不经常被读取，请将表拆分为两个表（users 和 user_addresses）。
相反，如果由于数据过于碎片化而总是需要在查询中多次使用表联接，则可能需要考虑对数据反归一化。反归一化与归一化相反。它涉及把一个表中的列合并到另一个表（以减少联接数）。
请考虑为昂贵的查询创建摘要/缓存表。例如，如果获取论坛列表和每个论坛中的帖子数量的查询非常昂贵，请创建一个名为 forums_summary 的表，其中包含论坛列表及其中的帖子数量。您可以使用事件定期刷新此表中的数据。您还可以使用触发器在每次有新帖子时更新计数。
全表扫描是查询速度慢的一个主要原因。使用 EXPLAIN 语句并查找类型为 "ALL" 的查询。这些是全表扫描。使用索引优化这些查询。
在设计索引时，请先查看 WHERE 子句中的列。这些是第一批候选人，因为它们有助于缩小搜索范围。接下来，查看 ORDER BY 子句中使用的列。如果它们存在于索引中，MySQL 可以扫描索引以返回有序的数据，而无需执行排序操作（filesort）。最后，考虑将 SELECT 子句中的列添加到索引中。这为您提供了覆盖索引，能覆盖你查询的完整需求。MySQL 不再需要从原表中检索任何内容。
选择组合索引，而不是多个单列索引。
索引中的列顺序很重要。将最常用的列和基数较高的列放在第一位，但始终考虑您的查询。
删除重复、冗余和未使用的索引。重复索引是同一组具有相同顺序的列上的索引。冗余索引是不必要的索引，可以替换为现有索引。例如，如果在列（A、 B）上有索引，并在列 （A）上创建另一个索引，则后者是冗余的，因为前一个索引可以满足相同的需求。
在分析现有索引之前，不要创建新索引。
在查询中隔离你的列，以便 MySQL 可以使用你的索引。
避免 SELECT *。大多数时候，选择所有列会忽略索引并返回您可能不需要的不必要的列。这会给数据库服务器带来额外负载。
只返回你需要的行。使用 LIMIT 子句限制返回的行数。
避免使用前导通配符的LIKE 表达式（eg."%name"） 。
如果您有一个使用 OR 运算符的速度较慢的查询，请考虑将查询分解为两个使用单独索引的查询，并使用 UNION 运算符组合它们。
延伸阅读：

施瓦茨 (Baron Schwartz) 《高性能MySQL》
Tapio Lahdenmaki 《数据库索引设计与优化》
