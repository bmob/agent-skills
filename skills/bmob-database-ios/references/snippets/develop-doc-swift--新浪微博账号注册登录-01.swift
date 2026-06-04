let dic = ["access_token": token, "uid": uid, "expirationDate": date]
BmobUser.loginInBackgroundWithAuthorDictionary(dic, platform: BmobSNSPlatformSinaWeibo) { (user, error) in
    print("objectId \(user?.objectId ?? "")")
}