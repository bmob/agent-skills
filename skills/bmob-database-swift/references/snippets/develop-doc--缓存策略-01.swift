var query = BmobQuery(className: "Note")
query.cachePolicy = .cacheThenNetwork  // 先取缓存再查网络

let results = try await query.find()