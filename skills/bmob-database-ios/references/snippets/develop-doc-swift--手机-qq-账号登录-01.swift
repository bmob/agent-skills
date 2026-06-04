let dic = ["access_token": _tencentOauth.accessToken, "uid": _tencentOauth.openId, "expirationDate": _tencentOauth.expirationDate]
BmobUser.loginInBackgroundWithAuthorDictionary(dic, platform: BmobSNSPlatformQQ) { (user, error) in
    print("objectId \(user?.objectId ?? "")")
}