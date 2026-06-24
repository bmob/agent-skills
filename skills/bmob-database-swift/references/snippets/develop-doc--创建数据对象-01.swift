// 创建新对象
let note = BmobObject(className: "Note")

// 设置字段（使用下标语法）
note["title"] = "我的笔记"
note["content"] = "这是内容"
note["priority"] = 1
note["isCompleted"] = false
note["tags"] = ["工作", "重要"]
note["metadata"] = ["viewCount": 100, "likeCount": 50]

// 保存
do {
    try await note.save()
    print("创建成功，objectId: \(note.objectId!)")
} catch {
    print("创建失败: \(error)")
}