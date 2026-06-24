let acl = BmobACL()
acl.setReadAccess(enabled: true, forRole: .public)
acl.setReadAccess(enabled: true, forRoleName: "Admin")  // Admin 角色可读
acl.setWriteAccess(enabled: true, forRoleName: "Admin") // Admin 角色可写

note.acl = acl