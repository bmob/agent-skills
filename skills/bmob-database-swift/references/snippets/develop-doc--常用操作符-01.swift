// 数组包含查询
let query = BmobQuery(className: "Note")
    .whereKey("tags", containedIn: ["Swift", "iOS"])

// 字段存在性
let query = BmobQuery(className: "Note")
    .whereKeyExists("publishedAt")
    .whereKeyDoesNotExist("deletedAt")