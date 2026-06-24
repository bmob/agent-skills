// 批量创建
let objects = [
    BmobObject(className: "Note", data: ["title": "笔记1"]),
    BmobObject(className: "Note", data: ["title": "笔记2"]),
    BmobObject(className: "Note", data: ["title": "笔记3"])
]

for object in objects {
    try await object.save()
}

// 批量更新
try await BmobObject.updateBatch(objects)