let query = BmobQuery(className: "Note")
    .whereKey("status", equalTo: 1)

let count = try await query.count()
print("符合条件的记录数: \(count)")