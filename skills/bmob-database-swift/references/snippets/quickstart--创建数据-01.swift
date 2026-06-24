let note = BmobObject(className: "Note")
note["title"] = "我的第一条笔记"
note["content"] = "Hello Bmob!"
note["score"] = 100

do {
    try await note.save()
    print("保存成功，objectId: \(note.objectId!)")
} catch {
    print("保存失败: \(error)")
}