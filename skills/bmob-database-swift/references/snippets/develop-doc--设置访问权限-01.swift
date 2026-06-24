let note = BmobObject(className: "Note")
note["title"] = "私有笔记"
note["content"] = "只有我自己能看"

// 创建 ACL：默认禁止读写
let acl = BmobACL()
acl.setReadAccess(enabled: true, forUserId: BmobUser.current?.objectId ?? "")
acl.setWriteAccess(enabled: true, forUserId: BmobUser.current?.objectId ?? "")

note.acl = acl
try await note.save()