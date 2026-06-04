// 查询 score 列中值大于 150 或者小于 5 的数据
let array = [["score": ["$gt": 150]], ["score": ["$lt": 5]]]
query.addTheConstraintByOrOperationWithArray(array)