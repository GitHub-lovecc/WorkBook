https://zhuanlan.zhihu.com/p/222932740感谢这位前辈的笔记

---A DATABASE is a collection of data stored in a format that can easily be accessed
---数据库是一个以易访问格式存储的数据集合，
---为了管理我们的数据库 我们使用一种叫做数据库管理系统（DBMS, Database Management System）的软件。
---我们连接到一个DBMS然后下达查询或者修改数据的指令，DBMS就会执行我们的指令并返回结果，
---有关系型和非关系型两类数据库，在更流行的关系型数据库中，我们把数据存储在通过某些关系相互关联的数据表中，
---每张表储存特定的一类数据，这正是关系型数据库名称的由来。（如：顾客表通过顾客id与订单表相联系，订单表又通过商品id与商品表相联系），
---SQL（Structured Query Language，结构化查询语言）是专门用来处理（包括查询和修改）关系型数据库的标准语言，
---不同关系型数据库管理系统语法略有不同，但都是基于标准SQL，本课使用最流行的开源关系型数据库管理系统，MySQL。
