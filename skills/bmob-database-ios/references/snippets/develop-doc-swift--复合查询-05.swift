// 查询 score 列中值大于 5 和小于 150 的数据
let array = [["score": ["$gt": 5]], ["score": ["$lt": 150]]]
query.addTheConstraintByAndOperationWithArray(array)