// 恢复本地缓存的用户
BmobUser.restoreCurrent()

if let currentUser = BmobUser.current {
    print("用户名: \(currentUser.username ?? "")")
    print("手机号: \(currentUser.mobilePhoneNumber ?? "")")
    print("Session: \(currentUser.sessionToken ?? "")")
}