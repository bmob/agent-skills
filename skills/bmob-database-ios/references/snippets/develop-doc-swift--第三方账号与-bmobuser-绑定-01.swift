// 新浪微博账号关联到当前用户
let dic = ["access_token": token, "uid": uid, "expirationDate": date]
let user = BmobUser.getCurrentUser()
user.linkedInBackgroundWithAuthorDictionary(dic, platform: BmobSNSPlatformSinaWeibo) { (isSuccessful, error) in
    print("bindResult \(isSuccessful)")
}