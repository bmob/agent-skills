// 如果要查询某个属性等于某个值，示例代码如下：
query.equalTo("isLike", "==", 100);

// 如果要查询某个属性不等于某个值，示例代码如下：
query.equalTo("title", "!=", "bmob sdk");

// 如果要模糊查询某个值，示例代码如下（模糊查询目前只提供给付费套餐会员使用）：
query.equalTo("title","==", { "$regex": "" + k + ".*" });

// 查询大于某个日期的数据（只针对createdAt、updatedAt字段），示例代码如下
query.equalTo("createdAt", ">" "2018-08-21 18:02:52");

// 非createdAt和updatedAt字段类型，查询大于某个日期的数据，示例代码如下

query.equalTo("your_datetime_column", {"$gte":{"__type":"Date","iso":"2011-08-21 18:02:52"}});


/**
* equalTo 方法支持 "==","!=",">",">=","<","<="
*/

// 两条查询语句一起写，就相当于AND查询，如下示例代码，查询一个月的数据：

query.equalTo("createdAt", ">", "2018-04-01 00:00:00");
query.equalTo("createdAt", "<", "2018-05-01 00:00:00");

// 因为createdAt updatedAt服务器自动生成的时间，在服务器保存的是精确到微秒值的时间，所以基于时间类型比较的值要加1秒。
