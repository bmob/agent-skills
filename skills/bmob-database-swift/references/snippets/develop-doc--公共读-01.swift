let acl = BmobACL()
acl.setReadAccess(enabled: true, forRole: .public)  // 所有人可读
acl.setWriteAccess(enabled: true, forUserId: BmobUser.current?.objectId ?? "")

note.acl = acl