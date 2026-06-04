let dic = ["access_token": accessToken, "uid": openId, "expirationDate": expirationDate]
BmobUser.loginInBackgroundWithAuthorDictionary(dic, platform: BmobSNSPlatformWeiXin) { (user, error) in
    print("objectId \(user?.objectId ?? "")")
}