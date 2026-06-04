// 查询表中 score 列有值的数据
query.whereKeyExists("score")

// 查询表中 score 列没有值的数据
query.whereKeyDoesNotExist("score")