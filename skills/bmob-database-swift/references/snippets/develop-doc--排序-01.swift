let query = BmobQuery(className: "Note")
    .order(byDescending: "createdAt")    // 按创建时间降序
    .order(byAscending: "priority")       // 按优先级升序

// 添加多个排序
let query = BmobQuery(className: "Note")
    .order(byDescending: "status")
    .addAscendingOrder("createdAt")