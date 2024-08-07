【十五章】保护数据库
Securing Databases (时长20分钟)

1. 介绍
Introduction (0:33)

导航

之前都是介绍本地数据库而你自己就是数据库的唯一用户，所以不必考虑安全问题。

但实际业务中数据库大多放在服务器里，你必须妥善处理好用户账户和权限的问题，合理决定谁拥有什么程度的权限以防止对数据的破坏和误用

这一章，我们学习如何增强数据库的安全性

2. 创建一个用户
Creating a User (3:12)

到目前为止我们一直使用的是 root 用户帐户，这是在安装 MySQL 时就设置的根账户

在生产环境中我们需要创建新用户并合理分配权限

例如，你有一个应用程序及其相关联的数据库，你要让使用你应用程序的用户拥有读写数据的权限，但他们不应该有改变数据库结构的权限，如创建和删除一张表，否则会出大问题

又如，你新招了一个DBA（数据库管理员），你需要给他新建一个账户，让他可以访问一个或多个数据库乃至整个MySQL服务器

导航

这节课我们学习如何创建帐户，之后学习如何设置权限

实例

设置一个新用户，用户名为 john，可以选择用 @ 来限制他可以从哪些地方访问数据库

CREATE USER john  
-- 无限制，可从任何位置访问 

CREATE USER john@127.0.0.1;  
-- 限制ip地址，可以是特定电脑，也可以是特定网络服务器（web server）

CREATE USER john@localhost;  
-- 限制主机名，特定电脑

CREATE USER john@'codewithmosh.com';  
-- 限制域名（注意加引号），可以是该域名内的任意电脑，但子域名则不行 

CREATE USER john@'%.codewithmosh.com'; 
-- 加上了通配符，可以是该域名及其子域名下的任意电脑
可以用 IDENTIFIED BY 来设置密码

CREATE USER john IDENTIFIED BY '1234' 
-- 可从任何地方访问，但密码为 '1234'
-- 该密码只是为了简化，请总是用很长的强密码
导航

下节课讲如何查看服务器上的用户

3. 查看用户
Viewing Users (1:29)

假设上节课我们最后用 CREATE USER john 创建了一个新账户 john，无限制，无密码

用两种方式可以查看MySQL服务器上的所有用户：

法1

在一个自动创建的名为 mysql 的数据库（导航里似乎是隐藏了看不到）里，有个user表记录了帐户信息，查询即可：

SELECT * FROM mysql.user;
可以看到罗列出的所有用户，除了 john 和 root 帐户，还有几个 MySQL 内部自动建立和使用的帐户（用户名均为 mysql.*）

Host 字段表示用户可以从哪里访问数据库，john 是一个通配符 %，表示他可以从任意位置访问数据库，其它几个用户都是 localhost，表示都只能从本电脑访问数据库，不能从远程链接访问

后面的一系列字段都是各种权限的配置，后面会细讲

法2

也可以直接点击左侧导航栏的 Administration 标签页里的 Users and Privileges，同样可以查看服务器上的用户列表和信息

导航

下节课讲如何删除用户

4. 删除用户
Dropping Users (0:48)

案例

假设之前创建了 bob 的帐户，允许在 codewithmosh.com 域名内访问数据库，密码是 '1234'：

CREATE USER bob@codewithmosh.com IDENTIFIED BY '1234';
之后 bob 离开了组织，就应该删除它的账户，注意依然要在用户名后跟上 @主机名（host）

DROP bob@codewithmosh.com;
最佳实践

记得总是及时删除掉组织中那些不用的账户

导航

下节课讲如何修改密码

5. 修改密码
Changing Passwords (1:06)

人们时常忘记自己的密码，作为管理员，你时常被要求修改别人的或自己的密码，这很简单，有两种方法：

法1

用 SET 语句

SET PASSWORD FOR john = '1234';
-- 修改john的密码

SET PASSWORD = '1234';  
-- 修改当前登录账户的密码
法2

用导航面板：还是在 Administration 标签页 Users and Privileges 里，点击用户 john，可修改其密码，最后记得点 Apply 应用。另外还可以点击 Expire Password 强制其密码过期，下次用户登录必须修改密码。

导航

以上是关于用户帐户的内容，接下来我们讲权限

6. 权限许可
Granting Privileges (4:53)

创建用户后需要分配权限，最常见的是两种情形：

常见情形1. 对于网页或桌面应用程序的使用用户，给予其读写数据的权限，但禁止其增删表或修改表结构

例如，我们有个叫作 moon 的应用程序，我们给这个应用程序建个用户帐户名为 moon_app (app指明这代表的是整个应用程序而非一个人)

CREATE USER moon_app IDENTIFIED BY '1234';
给予其对 sql_store 数据库增删查改以及执行储存过程（EXECUTE）的权限，这是给终端用户常用的权限配置

GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE
-- GRANT子句表明授予哪些权限
ON sql_store.* 
-- ON子句表明可访问哪些数据库和表
-- ON sql_store.*代表可访问某数据库所有表，常见设置
-- 只允许访问特定表则是 ON sql_store.customers，不常见
TO moon_app;
-- 表明授权给哪个用户
-- 如果该用户有访问地址限制，也要加上，如：@ip地址/域名/主机名
这样就完成了权限配置

我们来测试一下，先用这个新账户 moon_app 建立一个新连接（点击 workbench 主页 MySQL connections 处的加号按钮）：

将连接名（Connection Name）设置为：moon_app_connection； 主机名（Hostname）和端口（Post）是自动设置的，分别为：127.0.0.1 和 3306； 用户名（Username）和密码（Password）输入建立时的设置的用户名和密码：moon_app 和 1234

在新连接里测试，发现果然只能访问 sql_store 数据库而不能访问其他数据库（导航面板也只会显示 sql_store 数据库）

USE sql_store;
SELECT * FROM customers;

USE sql_invoicing;
/* Error Code: 1044. Access denied for user 
'moon_app'@'%' to database 'sql_invoicing' */
常见情形2. 对于管理员，给予其一个或多个数据库乃至整个服务器的管理权限，这不仅包括表中数据的读写，还包括增删表、修改表结构以及创建事务和触发器等

可以谷歌 MySQL privileges，第一个结果就是官方文档里罗列的所有可用的权限及含义，其中的 ALL 是最高权限，通常我们给予管理员 ALL 权限

GRANT ALL
ON sql_store.*
-- 如果是 *.*，则代表所有数据库的所有表或整个服务器
TO john;
导航

以上就是权限配置的两种最常见情形，接下来讲如何查看已经给出的权限

7. 查看权限
Viewing Privileges (1:34)

查看以给出的权限仍然有 SQL语句 和 导航菜单 两种方法：

法1

查看 john 的权限

SHOW GRANTS FOR john;
去掉 FOR john，即查看当前登录帐户的权限

SHOW GRANTS;
可以看到，当前root帐户拥有最高权限，除了 ALL 的所有权限外，还有另外一个叫 PROXY 的权限。感觉 root 帐户和 john 这样的 DBA 帐户的区别就跟群主和群管理员的区别一样

法2

依然可以通过导航栏 Administration 标签页里的 Users and Privileges 来查看各用户的权限，其中 Administrative Roles 展示了该用户的角色（Roles, 如 DBA，有很多可选项，感觉像是预设权限组合）和全局权限（Global Privileges）, 而 Schema Privileges 则显示该用户在特定数据库的权限，因为 root 和 john 的权限是针对所有数据库的，所以没有特定数据库权限而 moon_app 就显示有针对 sql_store 数据库的权限，所有这些都是可以选择和更改的，记得最后要点Apply应用

导航

下节课讲如何撤销权限

8. 撤销权限
Revoking/Dropping Privileges (1:20)

有时你可能发现给某人的权限给错了，或者给某人的权限过多导致他滥用权限，这节课学习如何收回权限，很简单，和给予权限很类似

案例

之前说过，应该只给予 moon_app 读写 sql_store 数据库的表内数据以及执行储存过程的权限，假设我们错误的给予了其创建视图的权限：

GRANT CREATE VIEW 
ON sql_store.*
TO moon_app;
要收回此权限，只用把语句中的 GRANT 变 REVOKE，把 TO 变 FROM 就行了，就这么简单：

REVOKE CREATE VIEW 
ON sql_store.*
FROM moon_app;
思想

不要给予一个账户过多权限，总是给予他所必须的最小权限，不然就在系统中创造了太多的安全漏洞

9. 总结
Wrap Up (0:44)

全面掌握SQL课程 到此结束，欢迎大家到 codewithmosh.com 继续学习Mosh的其它编程课程~
