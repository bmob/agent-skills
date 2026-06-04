// 当前用户取消关联微信账号
let user = BmobUser.getCurrentUser()
user.cancelLinkedInBackgroundWithPlatform(BmobSNSPlatformWeiXin) { (isSuccessful, error) in
    print("unbindResult \(isSuccessful)")
}