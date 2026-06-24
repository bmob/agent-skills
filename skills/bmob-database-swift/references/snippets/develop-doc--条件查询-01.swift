let query = BmobQuery(className: "Note")
    .whereKey("status", equalTo: 1)           // 等于
    .whereKey("score", greaterThan: 80)        // 大于
    .whereKey("priority", lessThanOrEqualTo: 3) // 小于等于
    .whereKey("title", notEqualTo: "草稿")      // 不等于

let results = try await query.find()