https://zhuanlan.zhihu.com/p/222932740感谢这位前辈的笔记

【第一章】做好准备
Getting Started (时长25分钟)

这一章其实没什么笔记可做……

1. 介绍
Introduction (0:18)

……

2. 什么是SQL
What is SQL (3:24)

A DATABASE is a collection of data stored in a format that can easily be accessed
数据库是一个以易访问格式存储的数据集合
为了管理我们的数据库 我们使用一种叫做数据库管理系统（DBMS, Database Management System）的软件。我们连接到一个DBMS然后下达查询或者修改数据的指令，DBMS就会执行我们的指令并返回结果

DBMS


有关系型和非关系型两类数据库，在更流行的关系型数据库中，我们把数据存储在通过某些关系相互关联的数据表中，每张表储存特定的一类数据，这正是关系型数据库名称的由来。（如：顾客表通过顾客id与订单表相联系，订单表又通过商品id与商品表相联系）
SQL（Structured Query Language，结构化查询语言）是专门用来处理（包括查询和修改）关系型数据库的标准语言
不同关系型数据库管理系统语法略有不同，但都是基于标准SQL，本课使用最流行的开源关系型数据库管理系统，MySQL
3. MySQL Mac版本安装
Installing MySQL on Mac (4:58)

……

4. MySQL Windows版本安装
Installing MySQL on Windows (5:20)

注意

Mosh是用Installer一次性安装了MySQL和workbench，若已安装MySQL而没有workbench的可 单独安装workbench

5. 创建数据库
Creating the Databases (8:32)

注意

如果MySQL版本较低导致导入 create-databases.sql 时出现collate排序规则问题而报错，可以用记事本打开 create-databases.sql 将 utf8mb4_0990_ai_ci 全部替换（Ctrl+H）为 utf8mb4_general_ci 并保存，再次导入就能顺利运行了。

关于MySQL的版本，可参考文章：我TM究竟应该选哪个版本的MySQL?!

背景

查看 数据概要，大致了解一下课程所用到数据的含义及其相互关系，这对理解课程有极大帮助

6. 你会学到什么
What You'll Learn (2:31)

见 Mosh_完全掌握SQL课程_学习笔记
