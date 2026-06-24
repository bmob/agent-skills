// 查询所有记录
let query = BmobQuery(className: "Note")
let results = try await query.find()

// 查询单条
let note = try await query.get(objectId: "abc123")