let query = BmobQuery(className: "Note")
    .limit(20)    // 每页 20 条
    .skip(40)     // 跳过前 40 条（获取第 3 页）