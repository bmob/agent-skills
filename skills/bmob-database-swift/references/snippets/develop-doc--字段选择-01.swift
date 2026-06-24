// 只返回指定字段
let query = BmobQuery(className: "Note")
    .selectKeys(["title", "createdAt"])