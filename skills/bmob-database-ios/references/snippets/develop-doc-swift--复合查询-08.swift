let query = BmobQuery(className: "Post")
// 列 author 为 Pointer 类型，指向用户表
// 假设用户 A 的 objectId 为 aaaa
let condition1 = ["author": ["__type": "Pointer", "className": "_User", "objectId": "aaaa"]]
// 假设用户 B 的 objectId 为 bbbb
let condition2 = ["author": ["__type": "Pointer", "className": "_User", "objectId": "bbbb"]]
let array = [condition1, condition2]
// 查找作者为用户 A 或者作者为用户 B 的数据
query.addTheConstraintByOrOperationWithArray(array)
query.findObjectsInBackgroundWithBlock { (array, error) in
}