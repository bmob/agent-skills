// AND 查询
let query1 = BmobQuery(className: "Note").whereKey("status", equalTo: 1)
let query2 = BmobQuery(className: "Note").whereKey("priority", greaterThan: 2)

if let andQuery = BmobQuery.and([query1, query2]) {
    let results = try await andQuery.find()
}

// OR 查询
let query1 = BmobQuery(className: "Note").whereKey("type", equalTo: "work")
let query2 = BmobQuery(className: "Note").whereKey("type", equalTo: "personal")

if let orQuery = BmobQuery.or([query1, query2]) {
    let results = try await orQuery.find()
}