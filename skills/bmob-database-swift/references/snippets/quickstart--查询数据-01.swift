// 查询所有
let query = BmobQuery(className: "Note")
let results = try await query.find()

// 条件查询
let query = BmobQuery(className: "Note")
    .whereKey("score", greaterThan: 80)
    .order(byDescending: "createdAt")
    .limit(10)
let results = try await query.find()