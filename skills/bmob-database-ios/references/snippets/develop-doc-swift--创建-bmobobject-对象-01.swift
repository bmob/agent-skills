// 创建一个带有 className 的 BmobObject 对象
// className: 表示对象名称（类似数据库表名）
BmobObject(className: String)

// 创建一个带有 className 和 objectId 的 BmobObject 对象
BmobObject(outDatatWithClassName: String, objectId: String)

// 从字典创建 BmobObject
BmobObject(dictionary: Dictionary)