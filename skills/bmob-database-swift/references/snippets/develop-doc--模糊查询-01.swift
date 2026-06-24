// 正则匹配
let query = BmobQuery(className: "Note")
    .whereKey("title", matchesRegex: ".*入门.*")

// 前缀匹配
let query = BmobQuery(className: "Note")
    .whereKey("title", startsWith: "Swift")

// 后缀匹配
let query = BmobQuery(className: "Note")
    .whereKey("email", endsWith: "@example.com")