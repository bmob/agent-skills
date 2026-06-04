// 当前用户解除关联的手机 QQ 账号
let user = BmobUser.getCurrentUser()
user.cancelLinkedInBackgroundWithPlatform(BmobSNSPlatformQQ) { (isSuccessful, error) in
    print("unbindResult \(isSuccessful)")
}