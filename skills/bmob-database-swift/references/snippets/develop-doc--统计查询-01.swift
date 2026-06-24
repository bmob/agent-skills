let query = BmobQuery(className: "Order")
    .selectKeys(["amount"])
    .statistics()
    .groupBy(["category"])

let stats = try await query.statistics()