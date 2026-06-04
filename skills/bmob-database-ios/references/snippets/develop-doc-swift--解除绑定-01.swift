// 当前用户解除关联的微博账号
let user = BmobUser.getCurrentUser()
user.cancelLinkedInBackgroundWithPlatform(BmobSNSPlatformSinaWeibo) { (isSuccessful, error) in
    print("unbindResult \(isSuccessful)")
}