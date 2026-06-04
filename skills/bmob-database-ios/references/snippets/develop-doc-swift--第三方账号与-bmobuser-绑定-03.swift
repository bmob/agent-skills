// 微信账号关联到当前用户
let dic = ["access_token": accessToken, "uid": openId, "expirationDate": expirationDate]
let user = BmobUser.getCurrentUser()
user.linkedInBackgroundWithAuthorDictionary(dic, platform: BmobSNSPlatformWeiXin) { (isSuccessful, error) in
    print("bindResult \(isSuccessful)")
}