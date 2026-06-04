// createdAt 大于或等于 2014-07-15 00:00:00
let condition1 = ["createdAt": ["$gte": ["__type": "Date", "iso": "2014-07-15 00:00:00"]]]
// createdAt 小于 2014-10-15 00:00:00
let condition2 = ["createdAt": ["$lt": ["__type": "Date", "iso": "2014-10-15 00:00:00"]]]
let array = [condition1, condition2]
// 查询创建时间在 2014 年 7 月 15 日到 2014 年 10 月 15 日之间的数据
query.addTheConstraintByAndOperationWithArray(array)