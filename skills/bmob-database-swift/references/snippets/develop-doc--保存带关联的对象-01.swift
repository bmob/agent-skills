// 创建笔记并关联作者
let note = BmobObject(className: "Note")
note["title"] = "关联文章"
note["author"] = BmobPointer(className: "_User", objectId: "user123")
note["category"] = BmobPointer(className: "Category", objectId: "cat456")

try await note.save()